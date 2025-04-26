module [
    prompt_puzzle,
    prompt_script,
    # TODO: prompt_fix_error,
]

import "example_code_basic_cli.roc" as basic_cli_example : Str
import Prompt.BuiltinFunctions exposing [builtin_functions_block]
import Prompt.BasicCliFunctions exposing [basic_cli_functions_raw]

# TODO use a proper puzzle example instead of example_code_basic_cli
prompt_puzzle : Str, Str -> Str
prompt_puzzle = |puzzle_question, start_roc_template|
    """
    We're going solve a programming puzzle in Roc.

    ${builtin_functions_block}

    ${wrap_example(basic_cli_example)}

    # Puzzle

    ${puzzle_question}

    Use this as a starter template, do not modify the `app [main!] {...` line:
    ```roc
    ${start_roc_template}
    ```

    Extra instructions:
    ${generic_roc_instructions}
    """

prompt_script : Str, Str -> Str
prompt_script = |script_question, start_roc_template|
    """
    We're going to write a script in Roc.

    ${builtin_functions_block}

    These are the basic-cli functions you can use:
    ```roc
    ${basic_cli_functions_raw}
    ```

    ${wrap_example(basic_cli_example)}

    # Script

    ${script_question}

    Use this as a starter template, do not modify the `app [main!] {...` line:
    ```roc
    ${start_roc_template}
    ```

    Extra instructions:
    ${generic_roc_instructions}
    """

wrap_example : Str -> Str
wrap_example = |roc_example|
    """
    Here is some example Roc code:
    ```roc
    ${roc_example}
    ```
    """

generic_roc_instructions : Str
generic_roc_instructions =
    """
    - If the user provides you with an error, start your reply with an analysis of what could be going wrong paired with potential solutions.
    - Do not provide an explanation after the code block.
    - Always reply with the full code, no partial snippets with changes.
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
    - Make sure to properly format variables of multiline strings. Example:
    ```
    example_input_part1 =
        \"\"\"
        1abc2
        pqr3stu8vwx
        a1b2c3d4e5f
        treb7uchet
        \"\"\"
    ```
    """
