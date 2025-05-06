app [main!] { cli: platform "https://github.com/roc-lang/basic-cli/releases/download/0.19.0/Hj-J_zxz7V9YurCSTFcFdu6cQJie4guzsPMUi5kBYUk.tar.br" }

import cli.Stdout

main! = |_args|
    Stdout.line!(Inspect.to_str(from_list([1, 2, 3])))

SimpleLinkedList : {
    head : [Cons, Nil],
}

Cons : {
    value : U64,
    next : [Cons, Nil],
}

from_list : List U64 -> SimpleLinkedList
from_list = |list|
    node =
        list
        |> List.walk(
            Nil,
            |acc, value|
                { value, next: acc },
        )
    { head: node }
