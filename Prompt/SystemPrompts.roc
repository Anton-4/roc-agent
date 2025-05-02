module [
    system_prompt_puzzle,
    system_prompt_script,
    # TODO: system_prompt_fix_error,
    # TODO: fix failing tests
]

import "example_code_basic_cli.roc" as basic_cli_example : Str
import "example_code_script.roc" as script_example : Str
import Prompt.BuiltinFunctions exposing [builtin_functions_block]
import Prompt.BasicCliFunctions exposing [basic_cli_functions_raw]

# TODO use a proper puzzle example instead of example_code_basic_cli
system_prompt_puzzle : Str
system_prompt_puzzle =
    """
    We're going solve a programming puzzle in Roc.

    ${builtin_functions_block}

    Here is some example Roc code:
    ```roc
    ${basic_cli_example}
    ```

    Important instructions:
    ${generic_roc_instructions}
    """

system_prompt_script : Str
system_prompt_script =
    """
    We're going to write a script in Roc.

    ${builtin_functions_block}

    Below are the basic-cli functions you can use, in contrast to the builtin functions these do need imports. So if you want to use `Env.cwd!`, add `import pf.Env`.
    ```roc
    ${basic_cli_functions_raw}
    ```

    Below is an example Roc script. Follow the conventions and style of this script.
    ```roc
    ${script_example}
    ```

    Important instructions:
    - To execute an effectful function for every item in a list:
      - Use `List.for_each!` if the function you want to pass returns `{}`.
      - Use `List.for_each_try!` if the function you want to pass returns a `Result {} someerr`.
      - Use `List.map_try!` if you want to return a Result where the success case is not `{}`.
    - Don't use `List.walk_try!` if you can achieve the same thing with one of the cleaner alternatives above.
    - `Task` has been removed from Roc, use `Result` instead.
    - Only print to Stdout in the main function to keep other function pure and easy to test.
    - Describe what the script does in a comment at the top.
    ${generic_roc_instructions}
    """

generic_roc_instructions : Str
generic_roc_instructions =
    """
    - If the user provides you with an error, start your reply with an analysis of what could be going wrong paired with potential solutions.
    - Do not provide an explanation after the code block.
    - Always reply with the full code, no partial snippets with changes. Your code should be in a markdown code block that starts with "```roc".
    - Roc no longer uses white space application syntax, but parens and commas instead. So `Stdout.line! "Hello, World!"` is now `Stdout.line!("Hello, World!")`.
    - Roc used to use pascalCase for variables, this has changed to snake_case. So `fizzBuzz` is now `fizz_buzz`.
    - Do not use the Parser package.
    - String interpolation works like this: `"Two plus three is: ${Num.to_str(2 + 3)}"`. Never use the old interpolation syntax: `"Two plus three is: \\(Num.to_str(2 + 3))"`.
    - To get the length of a Str use `List.len(Str.to_utf8(some_str))`
    - Roc does not use `head :: tail`, use `[head, .. as tail]` instead. Make sure you do not forget the `as`!
    - Roc does not have currying.
    - You can not pattern match directly on booleans. Avoid using Bool.true and Bool.false in general, it is better to use descriptive tags, for example `HasNoExtraLine` and `HasExtraLine`.
    - Roc does not allow shadowing, i.e. different variables with the same name, use unique variable and function names.
    - Make sure to avoid unused variables, types, or arguments.
    - Try to avoid integer overflows.
    - Roc functions are defined like this: `|arg| do_something(arg)`, never use the old function syntax: `\\arg -> do_something(arg)`
    - You can not do destructuring like this `start_pos, max_len = 0, 1`, use `(start_pos, max_len) = (0, 1)` instead.
    - Roc can hit an exhaustiveness bug in pattern matching where it says "Other possibilities include:" when in reality all possibilites are covered, if that bug happens, include a branch like this:
    ```
    _ -> crash "Roc bug, the previous branches actually are exhaustive."
    ```
    - Use intermediary variables in your expect tests, all variables will be printed on failure, that will make debugging easier. Example:
    ```
    expect 
        part1_result = part1(exampleInput)
        part1_result == Ok("The sum is 161")
    ```
    - You can use `dbg` for debugging, `dbg` does not work with intermediary variables like `expect`. How to use `dbg`:
    ```
    # standalone version
    dbg count

    # expression version
    if sum == 1 then
        dbg (some_function foo)
    else
        some_function bar
    ```
    - Very important: for multiline strings, `\"\"\"` should always be on its own line. No non-whitespace characters should be on the same line.
      So, never write `something = \"\"\"`.
      For the lines after `\"\"\"` we automatically cut off the amount of indentation to which `\"\"\"` is indented.
      Here is an example of a properly formatted multiline string:
    ```
    multi_line_str =
        \"\"\"
        apple
        pear
        orange
        \"\"\"
    ```
    - Never print errors, just return e.g `Err(FailedToWriteFile("Failed to write to file \${Path.display(output_path)}, usage: \${usage}"))`. Roc will automatically print errors that are returned by the main function.
    - You can just use a builtin function like `Str.contains` or `Result.map_ok`, these do not require an import.
    - Result.map does not exist, use Result.map_ok instead.
    - Avoid using `Result.with_default` for lazy error handling.
    - If your function needs to return a Result, do not use `?` on the last line of the function.
    - Roc does not have for loops.
    - Use descriptive variable and function names. Don't add a comment if the name is sufficiently descriptive.
    - If a function performs an effect, its name should end with `!`, and it's type signature should use the `=>` arrow instead of the `->` used for pure functions.
    - Every `if` requires an `else` branch.
    - Don't use Strings directly in `Err`, always wrap them in a tag so e.g `Err(MissingJSONField("I could not find the field amount in \${json_msg}."))` instead of `Err("I could not find the field amount in \${json_msg}.")`.
    - You can use `Inspect.to_str(something)` to convert something to a str for printing.
    - Very important: `?` does not work on its own line. It should usually be put after a `)`, e.g. `check_output = File.read_utf8!(cmd_output_file)?`.
    - Tips and suggestions given by the compiler are not always correct and won't always point at the line that causes the problem. Keep an open mind.
    - Write robust code that can handle edge cases.
    - Add several top level expects to test your code, make sure to include some edge cases.
    - You can not test effectful functions with top level expects, just test pure functions with mock data.
    - Use defensive programming. For example; if a list should not be empty, check for it and return an error if it is.
    - Write your code as simple as possible, avoid unnecessary complexity.
    """
