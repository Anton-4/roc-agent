module [
    builtin_functions_block,
    builtin_functions_raw,
]

builtin_functions_block : Str
builtin_functions_block =
    """
    Below are the builtin functions you can use, they are available by default and can't be imported.
    ```roc
    ${builtin_functions_raw}
    ```
    """

# TODO test that these are up to date
## Builtin functions and values assembled from exercism and roc-lang/examples
builtin_functions_raw : Str
builtin_functions_raw =
    """
    Bool.false : Bool
    Bool.true : Bool
    Decode.from_bytes_partial : List U8, fmt -> DecodeResult val where val implements Decoding, fmt implements DecoderFormatting
    Dict.empty : {} -> Dict * *
    Dict.from_list : List (k, v) -> Dict k v
    Dict.get : Dict k v, k -> Result v [KeyNotFound]
    Dict.insert : Dict k v, k, v -> Dict k v
    Dict.insert_all : Dict k v, Dict k v -> Dict k v
    Dict.join_map : Dict a b, (a, b -> Dict x y) -> Dict x y
    Dict.keys : Dict k v -> List k
    Dict.map : Dict k a, (k, a -> b) -> Dict k b
    Dict.remove : Dict k v, k -> Dict k v
    Dict.single : k, v -> Dict k v
    Dict.to_list : Dict k v -> List (k, v)
    Dict.update : Dict k v, k, (Result v [Missing] -> Result v [Missing]) -> Dict k v
    Dict.walk : Dict k v, state, (state, k, v -> state) -> state
    Encode.to_bytes : val, fmt -> List U8 where val implements Encoding, fmt implements EncoderFormatting
    List.all : List a, (a -> Bool) -> Bool
    List.any : List a, (a -> Bool) -> Bool
    List.append : List a, a -> List a
    List.chunks_of : List a, U64 -> List (List a)
    List.concat : List a, List a -> List a
    List.contains : List a, a -> Bool where a implements Eq
    List.drop_at : List elem, U64 -> List elem
    List.drop_first : List elem, U64 -> List elem
    List.drop_if : List a, (a -> Bool) -> List a
    List.drop_last : List elem, U64 -> List elem
    List.find_first : List elem, (elem -> Bool) -> Result elem [NotFound]
    List.find_first_index : List elem, (elem -> Bool) -> Result U64 [NotFound]
    List.find_last_index : List elem, (elem -> Bool) -> Result U64 [NotFound]
    List.first : List a -> Result a [ListWasEmpty]
    List.get : List a, U64 -> Result a [OutOfBounds]
    List.intersperse : List elem, elem -> List elem
    List.is_empty : List * -> Bool
    List.join : List (List a) -> List a
    List.join_map : List a, (a -> List b) -> List b
    List.keep_if : List a, (a -> Bool) -> List a
    List.keep_oks : List before, (before -> Result after *) -> List after
    List.last : List a -> Result a [ListWasEmpty]
    List.len : List * -> U64
    List.map : List a, (a -> b) -> List b
    List.map2 : List a, List b, (a, b -> c) -> List c
    List.for_each! : List a, (a => {}) => {}
    List.for_each_try! : List a, (a => Result {} err) => Result {} err
    List.map_try : List elem, (elem -> Result ok err) -> Result (List ok) err
    List.map_try! : List elem, (elem => Result ok err) => Result (List ok) err
    List.map_with_index : List a, (a, U64 -> b) -> List b
    List.max : List (Num a) -> Result (Num a) [ListWasEmpty]
    List.min : List (Num a) -> Result (Num a) [ListWasEmpty]
    List.range : { end : [At (Num a), Before (Num a), Length U64], start : [After (Num a), At (Num a)], step ? Num a }* -> List (Num a)
    List.repeat : a, U64 -> List a
    List.replace : List a, U64, a -> { list : List a, value : a }
    List.reverse : List a -> List a
    List.sort_asc : List (Num a) -> List (Num a)
    List.sort_desc : List (Num a) -> List (Num a)
    List.sort_with : List a, (a, a -> [LT, EQ, GT]) -> List a
    List.split_at : List elem, U64 -> { before : List elem, others : List elem }
    List.split_on : List a, a -> List (List a) where a implements Eq
    List.sublist : List elem, { start : U64, len : U64 } -> List elem
    List.sum : List (Num a) -> Num a
    List.swap : List a, U64, U64 -> List a
    List.take_first : List elem, U64 -> List elem
    List.take_last : List elem, U64 -> List elem
    List.update : List a, U64, (a -> a) -> List a
    List.walk : List elem, state, (state, elem -> state) -> state
    List.walk! : List elem, state, (state, elem => state) => state
    List.walk_backwards : List elem, state, (state, elem -> state) -> state
    List.walk_try : List elem, state, (state, elem -> Result state err) -> Result state err
    List.walk_try! : List elem, state, (state, elem => Result state err) => Result state err
    List.walk_until : List elem, state, (state, elem -> [Continue state, Break state]) -> state
    List.walk_with_index : List elem, state, (state, elem, U64 -> state) -> state
    List.walk_with_index_until : List elem, state, (state, elem, U64 -> [Continue state, Break state]) -> state
    List.with_capacity : U64 -> List *
    Num.abs : Num a -> Num a
    Num.add : Num a, Num a -> Num a
    Num.add_checked : Num a, Num a -> Result (Num a) [Overflow]
    Num.bitwise_and : Int a, Int a -> Int a
    Num.bitwise_or : Int a, Int a -> Int a
    Num.ceiling : Frac * -> Int *
    Num.compare : Num a, Num a -> [LT, EQ, GT]
    Num.cos : Frac a -> Frac a
    Num.div : Frac a, Frac a -> Frac a
    Num.div_trunc : Int a, Int a -> Int a
    Num.div_trunc_checked : Int a, Int a -> Result (Int a) [DivByZero]
    Num.e : Frac *
    Num.int_cast : Int a -> Int b
    Num.is_approx_eq : Frac a, Frac a, { rtol ? Frac a, atol ? Frac a } -> Bool
    Num.is_even : Int a -> Bool
    Num.is_multiple_of : Int a, Int a -> Bool
    Num.max : Num a, Num a -> Num a
    Num.max_u64 : U64
    Num.min : Num a, Num a -> Num a
    Num.mul : Num a, Num a -> Num a
    Num.pow : Frac a, Frac a -> Frac a
    Num.pow_int : Int a, Int a -> Int a
    Num.rem : Int a, Int a -> Int a
    Num.round : Frac * -> Int *
    Num.shift_left_by : Int a, U8 -> Int a
    Num.shift_right_zf_by : Int a, U8 -> Int a
    Num.sin : Frac a -> Frac a
    Num.sqrt : Frac a -> Frac a
    Num.sub_checked : Num a, Num a -> Result (Num a) [Overflow]
    Num.sub_saturated : Num a, Num a -> Num a
    Num.to_f64 : Num * -> F64
    Num.to_frac : Num * -> Frac *
    Num.to_i64 : Int * -> I64
    Num.to_i8 : Int * -> I8
    Num.to_str : Num * -> Str
    Num.to_u16 : Int * -> U16
    Num.to_u32 : Int * -> U32
    Num.to_u64 : Int * -> U64
    Num.to_u64_checked : Int * -> Result U64 [OutOfBounds]
    Num.to_u8 : Int * -> U8
    Result.is_ok : Result ok err -> Bool
    Result.map_err : Result ok a, (a -> b) -> Result ok b
    Result.on_err : Result a err, (err -> Result a otherErr) -> Result a otherErr
    Result.try : Result a err, (a -> Result b err) -> Result b err
    Result.with_default : Result ok err, ok -> ok
    Result.map_ok : Result a err, (a -> b) -> Result b err
    Result.map2 : Result a err, Result b err, (a, b -> c) -> Result c err
    Set.contains : Set k, k -> Bool
    Set.empty : {} -> Set *
    Set.from_list : List k -> Set k
    Set.insert : Set k, k -> Set k
    Set.intersection : Set k, Set k -> Set k
    Set.is_empty : Set * -> Bool
    Set.keep_if : Set k, (k -> Bool) -> Set k
    Set.len : Set * -> U64
    Set.map : Set a, (a -> b) -> Set b
    Set.remove : Set k, k -> Set k
    Set.single : k -> Set k
    Set.to_list : Set k -> List k
    Set.union : Set k, Set k -> Set k
    Set.walk_until : Set k, state, (state, k -> [Continue state, Break state]) -> state
    Str.contains : Str, Str -> Bool
    Str.ends_with : Str, Str -> Bool
    Str.from_utf8 : List U8 -> Result Str [BadUtf8  { problem : Utf8Problem, index : U64 } ]
    Str.is_empty : Str -> Bool
    Str.join_with : List Str, Str -> Str
    Str.repeat : Str, U64 -> Str
    Str.replace_each : Str, Str, Str -> Str
    Str.replace_first : Str, Str, Str -> Str
    Str.split_first : Str, Str -> Result { before : Str, after : Str } [NotFound]
    Str.split_on : Str, Str -> List Str
    Str.starts_with : Str, Str -> Bool
    Str.to_i16 : Str -> Result I16 [InvalidNumStr]
    Str.to_i64 : Str -> Result I64 [InvalidNumStr]
    Str.to_u32 : Str -> Result U32 [InvalidNumStr]
    Str.to_u64 : Str -> Result U64 [InvalidNumStr]
    Str.to_utf8 : Str -> List U8
    Str.trim : Str -> Str
    Str.trim_end : Str -> Str
    """
