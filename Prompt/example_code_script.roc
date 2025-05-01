app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout
import pf.Arg exposing [Arg]
import pf.File

# This script performs the following tasks:
# 1. Reads the file basic-cli/platform/main.roc and extracts the exposes list.
# 2. For each module in the exposes list, it reads the corresponding file (e.g., basic-cli/platform/Path.roc) and extracts all functions in the module list.
# 3. Those functions are printed.

## For convenient string errors
err_s = |err_msg| Err(StrErr(err_msg))

main! : List Arg => Result {} _
main! = |_args|
    path_to_platform_main = "basic-cli/platform/main.roc"

    main_content =
        File.read_utf8!(path_to_platform_main)?

    exposed_modules =
        extract_exposes_list(main_content)?

    # Uncomment for debugging
    # Stdout.line!("Found exposed modules: ${Str.join_with(exposed_modules, ", ")}")?

    module_name_and_functions = List.map_try!(
        exposed_modules,
        |module_name|
            process_module!(module_name),
    )?

    module_name_and_functions
    |> List.for_each_try!(
        |{ module_name, exposed_functions }|
            List.for_each_try!(
                exposed_functions,
                |function_name|
                    Stdout.line!("${module_name}.${function_name}"),
            ),
    )?

    Ok({})

process_module! : Str => Result { module_name : Str, exposed_functions : List Str } _
process_module! = |module_name|
    module_path = "basic-cli/platform/${module_name}.roc"

    module_source_code =
        File.read_utf8!(module_path)?

    module_items =
        extract_module_list(module_source_code)?

    module_functions =
        module_items
        |> List.keep_if(starts_with_lowercase)

    Ok({ module_name, exposed_functions: module_functions })

expect
    input =
        """
        exposes [
            Path,
            File,
            Http
        ]
        """

    output =
        extract_exposes_list(input)

    output == Ok(["Path", "File", "Http"])

# extra comma
expect
    input =
        """
        exposes [
            Path,
            File,
            Http,
        ]
        """

    output = extract_exposes_list(input)

    output == Ok(["Path", "File", "Http"])

# single line
expect
    input = "exposes [Path, File, Http]"

    output = extract_exposes_list(input)

    output == Ok(["Path", "File", "Http"])

# empty list
expect
    input = "exposes []"

    output = extract_exposes_list(input)

    output == Ok([])

# multiple spaces
expect
    input = "exposes   [Path]"

    output = extract_exposes_list(input)

    output == Ok(["Path"])

extract_exposes_list : Str -> Result (List Str) _
extract_exposes_list = |source_code|

    when Str.split_first(source_code, "exposes") is
        Ok { after } ->
            trimmed_after = Str.trim(after)

            if Str.starts_with(trimmed_after, "[") then
                list_content = Str.replace_first(trimmed_after, "[", "")

                when Str.split_first(list_content, "]") is
                    Ok { before } ->
                        modules =
                            before
                            |> Str.split_on(",")
                            |> List.map(Str.trim)
                            |> List.keep_if(|s| !Str.is_empty(s))

                        Ok(modules)

                    Err _ ->
                        err_s("Could not find closing bracket for exposes list in source code:\n\t${source_code}")
            else
                err_s("Could not find opening bracket after 'exposes' in source code:\n\t${source_code}")

        Err _ ->
            err_s("Could not find exposes section in source_code:\n\t${source_code}")

expect
    input =
        """
        module [
            Path,
            display,
            from_str,
            IOErr
        ]
        """

    output = extract_module_list(input)

    output == Ok(["Path", "display", "from_str", "IOErr"])

# extra comma
expect
    input =
        """
        module [
            Path,
            display,
            from_str,
            IOErr,
        ]
        """

    output = extract_module_list(input)

    output == Ok(["Path", "display", "from_str", "IOErr"])

expect
    input =
        "module [Path, display, from_str, IOErr]"

    output = extract_module_list(input)

    output == Ok(["Path", "display", "from_str", "IOErr"])

expect
    input =
        "module []"

    output = extract_module_list(input)

    output == Ok([])

# with extra space
expect
    input =
        "module  [Path]"

    output = extract_module_list(input)

    output == Ok(["Path"])

extract_module_list : Str -> Result (List Str) _
extract_module_list = |source_code|

    when Str.split_first(source_code, "module") is
        Ok { after } ->
            trimmed_after = Str.trim(after)

            if Str.starts_with(trimmed_after, "[") then
                list_content = Str.replace_first(trimmed_after, "[", "")

                when Str.split_first(list_content, "]") is
                    Ok { before } ->
                        items =
                            before
                            |> Str.split_on(",")
                            |> List.map(Str.trim)
                            |> List.keep_if(|s| !Str.is_empty(s))

                        Ok(items)

                    Err _ ->
                        err_s("Could not find closing bracket for module list in source code:\n\t${source_code}")
            else
                err_s("Could not find opening bracket after 'module' in source code:\n\t${source_code}")

        Err _ ->
            err_s("Could not find module section in source_code:\n\t${source_code}")

expect starts_with_lowercase("hello") == Bool.true
expect starts_with_lowercase("Hello") == Bool.false
expect starts_with_lowercase("!hello") == Bool.false
expect starts_with_lowercase("") == Bool.false

starts_with_lowercase : Str -> Bool
starts_with_lowercase = |str|
    if Str.is_empty(str) then
        Bool.false
    else
        first_char_byte =
            str
            |> Str.to_utf8
            |> List.first
            |> impossible_err("We verified that the string is not empty")

        # ASCII lowercase letters range from 97 ('a') to 122 ('z')
        first_char_byte >= 97 and first_char_byte <= 122

impossible_err = |result, err_msg|
    when result is
        Ok something ->
            something

        Err err ->
            crash "This should have been impossible: ${err_msg}.\n\tError was: ${Inspect.to_str(err)}"
