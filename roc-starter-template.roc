app [main!] { pf: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import pf.Stdout
import pf.Arg exposing [Arg]

main! : List Arg => Result {} _
main! = |_args|
    hello : Str
    hello = "Hello, world!"

    if Str.contains(hello, "world") && !Str.is_empty(hello) then
        Stdout.line!(hello)
    else
        Err(BadHello("The variable hello did not contain 'world' or was empty: \"${hello}\""))

expect
    multi_line_str =
        """
        a
        b
        c
        """
    
    multi_line_str == "a\nb\nc"
