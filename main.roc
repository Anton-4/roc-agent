app [main!] {
    pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br",
    json: "https://github.com/lukewilliamboswell/roc-json/releases/download/0.12.0/1trwx8sltQ-e9Y2rOB4LWUWLS_sFVyETK8Twl0i9qpw.tar.gz",
}

import pf.Http
import pf.Stdout
import pf.Stderr
import pf.Env
import json.Json
import json.Option exposing [Option]
import Decode exposing [from_bytes_partial]
import pf.Cmd
import pf.File

import Prompt.PromptBuilder exposing [prompt_puzzle]
import "roc-starter-template.roc" as start_roc_template : Str

prompt_text : Str
prompt_text =
    prompt_puzzle(puzzle_question, start_roc_template, after_instructions)

puzzle_question =
    """
    Add a longest palindromic substring function to this Roc code, add tests using `expect`.
    That function should do the following:
    Given a string s, find the longest palindromic substring in s. A palindrome is a string that reads the same backward as forward.
    """

after_instructions =
    "Do not modify the `app [main!] {...` line above."

# Output of `roc test` and `roc check` gets written to this file
cmd_output_file = "last_cmd_output.txt"

# Claude will write to this file and execute `roc check` and `roc test` on it
claude_roc_file = "main_claude.roc"
claude_max_requests = 8
# Choose between:
# - smartest, expensive: "claude-3-7-sonnet-20250219"
# - decent, cheap, fast: "claude-3-5-haiku-20241022"
claude_model = "claude-3-7-sonnet-20250219"

http_request_timeout = 5 * 60 * 1000

main! = |_args|
    roc_version_check!({})?

    loop_claude!(claude_max_requests, prompt_text, [])?

    Ok({})

loop_claude! = |remaining_claude_calls, prompt, previous_messages|

    info!("Prompt:\n\n${prompt}\n")?

    info!("Asking Claude...\n")?
    claude_answer = ask_claude!(prompt, previous_messages)?

    info!("Claude's reply:\n\n${claude_answer}\nEND\n\n")?

    code_block_res = extract_markdown_code_block(claude_answer)

    when code_block_res is
        Ok(code_block) ->
            File.write_utf8!(code_block, claude_roc_file)?

            info!("Running `roc check`...\n")?
            check_output_result = execute_roc_check!({})

            strip_color_codes!({})?
            check_output = File.read_utf8!(cmd_output_file)?

            Stdout.line!("\n${Inspect.to_str(check_output)}\n\n")?

            when check_output_result is
                Ok({}) ->
                    info!("Running `roc test`...\n")?
                    test_output_result = execute_roc_test!({})

                    strip_color_codes!({})?
                    test_output = File.read_utf8!(cmd_output_file)?

                    when test_output_result is
                        Ok({}) ->
                            Stdout.line!("\n${Inspect.to_str(test_output)}\n\n")?

                            Ok({})

                        Err(e) ->
                            info!("`roc test` failed.\n")?

                            Stderr.line!(Inspect.to_str(e))?

                            retry!(remaining_claude_calls, previous_messages, prompt, claude_answer, test_output)

                Err(e) ->
                    info!("`roc check` failed.\n")?

                    Stderr.line!(Inspect.to_str(e))?

                    retry!(remaining_claude_calls, previous_messages, prompt, claude_answer, check_output)

        Err(e) ->
            Err(ExtractMarkdownCodeBlockFailed(Inspect.to_str(e)))

ask_claude! : Str, List { role : Str, content : Str } => Result Str _
ask_claude! = |prompt, previous_messages|
    escaped_prompt = escape_str(prompt)

    escaped_previous_messages =
        List.map(
            previous_messages,
            |message|
                { message & content: escape_str(message.content) },
        )

    api_key =
        Env.decode!("ANTHROPIC_API_KEY")
        |> Result.map_err(|_| FailedToGetAPIKeyFromEnvVar)
        |> try

    messages_to_send =
        List.append(escaped_previous_messages, { role: "user", content: "${escaped_prompt}" })
        |> messages_to_str

    request = {
        method: POST,
        headers: [
            { name: "x-api-key", value: api_key },
            { name: "anthropic-version", value: "2023-06-01" },
            { name: "content-type", value: "application/json" },
        ],
        uri: "https://api.anthropic.com/v1/messages",
        body: Str.to_utf8(
            """
            {
                "model": "${claude_model}",
                "max_tokens": 8192,
                "messages": ${messages_to_send}
            }
            """,
        ),
        timeout_ms: TimeoutMilliseconds(http_request_timeout),
    }

    response =
        Http.send!(request)?

    response_body =
        Str.from_utf8(response.body)

    when response_body is
        Ok(reply_body) ->
            json_decoder = Json.utf8_with({ field_name_mapping: SnakeCase })

            decoded : DecodeResult ClaudeReply
            decoded = from_bytes_partial(Str.to_utf8(reply_body), json_decoder)

            when decoded.result is
                Ok(claude_reply) ->
                    when List.first(claude_reply.content) is
                        Ok(first_content_elt) -> Ok(first_content_elt.text)
                        Err(_) -> Err(ClaudeReplyContentJsonFieldWasEmptyList)

                Err(e) -> Err(ClaudeJsonDecodeFailed("Error:\n\tFailed to decode claude API reply into json: ${Inspect.to_str(e)}\n\n\tbody:\n\t\t${reply_body}"))

        Err(err) ->
            Err(ClaudeHTTPSendFailed(err))

ClaudeReply : {
    id : Str,
    type : Str,
    role : Str,
    model : Str,
    content : List { type : Str, text : Str },
    stop_reason : Str,
    stop_sequence : Option Str,
    usage : {
        input_tokens : U64,
        output_tokens : U64,
    },
}

retry! = |remaining_claude_calls, previous_messages, old_prompt, claude_answer, new_prompt|
    if remaining_claude_calls > 0 then
        new_previous_messages = List.concat(previous_messages, [{ role: "user", content: old_prompt }, { role: "assistant", content: claude_answer }])

        loop_claude!((remaining_claude_calls - 1), new_prompt, new_previous_messages)
    else
        Err(ReachedMaxClaudeCalls)

execute_roc_check! = |{}|
    bash_cmd =
        Cmd.new("bash")
        |> Cmd.arg("-c")
        |> Cmd.arg("roc check main_claude.roc > last_cmd_output.txt 2>&1")

    cmd_exit_code = try(Cmd.status!, bash_cmd)

    if cmd_exit_code != 0 then
        Err(StripColorCodesFailedWithExitCode(cmd_exit_code))
    else
        Ok({})

execute_roc_test! = |{}|
    bash_cmd =
        Cmd.new("bash")
        |> Cmd.arg("-c")
        |> Cmd.arg(
            """
            (timeout 2m roc test main_claude.roc > last_cmd_output.txt 2>&1 || { ret=$?; if [ $ret -eq 124 ]; then echo "'roc test' timed out after two minutes!" >> last_cmd_output.txt; fi; exit $ret; })
            """,
        )

    cmd_exit_code = try(Cmd.status!, bash_cmd)

    if cmd_exit_code != 0 then
        Err(StripColorCodesFailedWithExitCode(cmd_exit_code))
    else
        Ok({})

# HELPERS

roc_version_check! : {} => Result {} _
roc_version_check! = |{}|
    try(info!, "Checking if roc command is available; executing `roc version`:")

    Cmd.exec!("roc", ["version"])
    |> Result.map_err(RocVersionCheckFailed)

strip_color_codes! = |{}|
    bash_cmd =
        Cmd.new("bash")
        |> Cmd.arg("removeColorCodes.sh")

    cmd_exit_code = try(Cmd.status!, bash_cmd)

    if cmd_exit_code != 0 then
        Err(StripColorCodesFailedWithExitCode(cmd_exit_code))
    else
        Ok({})

extract_markdown_code_block = |text|
    if !(Str.contains(text, "```roc")) then
        Err(NoRocCodeBlockInClaudeReply(text))
    else
        split_on_backticks_roc = Str.split_on(text, "```roc")
        split_on_backticks =
            List.get(split_on_backticks_roc, 1)?
            |> Str.split_on("```")

        when List.get(split_on_backticks, 0) is
            Ok(code_block_dirty) -> Ok(remove_first_line(code_block_dirty))
            Err(_) -> crash("This should be impossible due to previous if")

remove_first_line = |str|
    Str.split_on(str, "\n")
    |> List.drop_first(1)
    |> Str.join_with("\n")

messages_to_str : List { role : Str, content : Str } -> Str
messages_to_str = |messages|
    messages_str =
        List.map(
            messages,
            |message|
                """
                {"role": "${message.role}", "content": "${message.content}"}
                """,
        )
        |> Str.join_with(", ")

    """
    [${messages_str}]
    """

info! = |msg|
    Stdout.line!("\u(001b)[34mINFO:\u(001b)[0m ${msg}")

escape_str : Str -> Str
escape_str = |str|
    Str.replace_each(str, "\\", "\\\\")
    |> Str.replace_each("\n", "\\n")
    |> Str.replace_each("\t", "\\t")
    |> Str.replace_each("\"", "\\\"")

