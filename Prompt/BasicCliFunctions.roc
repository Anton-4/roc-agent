module [
    basic_cli_functions_raw,
]

# TODO test that these are up to date
basic_cli_functions_raw : Str
basic_cli_functions_raw =
    """
    Arg.display : Arg -> Str
    Arg.to_os_raw : Arg -> [Unix (List U8), Windows (List U16)]
    Arg.from_os_raw : [Unix (List U8), Windows (List U16)] -> Arg
    Cmd.new : Str -> Cmd
    Cmd.arg : Cmd, Str -> Cmd
    Cmd.args : Cmd, List Str -> Cmd
    Cmd.env : Cmd, Str, Str -> Cmd
    Cmd.envs : Cmd, List (Str, Str) -> Cmd
    Cmd.clear_envs : Cmd -> Cmd
    Cmd.status! : Cmd => Result I32 [CmdStatusErr InternalIOErr.IOErr]
    Cmd.output! : Cmd => Output
    Cmd.exec! : Str, List Str => Result {} [CmdStatusErr InternalIOErr.IOErr]
    Dir.list! : Str => Result (List Path) [DirErr IOErr]
    Dir.create! : Str => Result {} [DirErr IOErr]
    Dir.create_all! : Str => Result {} [DirErr IOErr]
    Dir.delete_empty! : Str => Result {} [DirErr IOErr]
    Dir.delete_all! : Str => Result {} [DirErr IOErr]
    Env.cwd! : {} => Result Path [CwdUnavailable]
    Env.set_cwd! : Path => Result {} [InvalidCwd]
    Env.exe_path! : {} => Result Path [ExePathUnavailable]
    Env.var! : Str => Result Str [VarNotFound]
    Env.decode! : Str => Result val [VarNotFound, DecodeErr DecodeError] (where val implements Decoding)
    Env.dict! : {} => Dict Str Str
    Env.platform! : {} => { arch : ARCH, os : OS }
    Env.temp_dir! : {} => Path
    EnvDecoding.format : {} -> EnvFormat
    File.write! : val, Str, fmt => Result {} [FileWriteErr Path IOErr] (where val implements Encoding, fmt implements EncoderFormatting)
    File.write_bytes! : List U8, Str => Result {} [FileWriteErr Path IOErr]
    File.write_utf8! : Str, Str => Result {} [FileWriteErr Path IOErr]
    File.delete! : Str => Result {} [FileWriteErr Path IOErr]
    File.read_bytes! : Str => Result (List U8) [FileReadErr Path IOErr]
    File.read_utf8! : Str => Result Str [FileReadErr Path IOErr, FileReadUtf8Err Path _]
    Http.header : (Str, Str) -> Header
    Http.send! : Request => Result Response [HttpErr [Timeout, NetworkError, BadBody, Other (List U8)]]
    Http.get! : Str, fmt => Result body [HttpDecodingFailed, HttpErr _] (where body implements Decoding, fmt implements DecoderFormatting)
    Http.get_utf8! : Str => Result Str [BadBody Str, HttpErr _]
    Locale.get! : {} => Result Str [NotAvailable]
    Locale.all! : {} => List Str
    Path.display : Path -> Str
    Path.from_str : Str -> Path
    Path.from_bytes : List U8 -> Path
    Path.write_utf8! : Str, Path => Result {} [FileWriteErr Path IOErr]
    Path.write_bytes! : List U8, Path => Result {} [FileWriteErr Path IOErr]
    Path.write! : val, Path, fmt => Result {} [FileWriteErr Path IOErr] (where val implements Encoding, fmt implements EncoderFormatting)
    Sleep.millis! : U64 => {}
    Sqlite.prepare! : { path : Str, query : Str } => Result Stmt [SqliteErr ErrCode Str]
    Stderr.line! : Str => Result {} [StderrErr IOErr]
    Stderr.write! : Str => Result {} [StderrErr IOErr]
    Stderr.write_bytes! : List U8 => Result {} [StderrErr IOErr]
    Stdin.line! : {} => Result Str [EndOfFile, StdinErr IOErr]
    Stdin.bytes! : {} => Result (List U8) [EndOfFile, StdinErr IOErr]
    Stdin.read_to_end! : {} => Result (List U8) [StdinErr IOErr]
    Stdout.line! : Str => Result {} [StdoutErr IOErr]
    Stdout.write! : Str => Result {} [StdoutErr IOErr]
    Stdout.write_bytes! : List U8 => Result {} [StdoutErr IOErr]
    Tcp.connect! : Str, U16 => Result Stream ConnectErr
    Tcp.read_up_to! : Stream, U64 => Result (List U8) [TcpReadErr StreamErr]
    Tcp.read_exactly! : Stream, U64 => Result (List U8) [TcpReadErr StreamErr, TcpUnexpectedEOF]
    Tcp.read_until! : Stream, U8 => Result (List U8) [TcpReadErr StreamErr]
    Tcp.read_line! : Stream => Result Str [TcpReadErr StreamErr, TcpReadBadUtf8 _]
    Tcp.write! : Stream, List U8 => Result {} [TcpWriteErr StreamErr]
    Tcp.write_utf8! : Stream, Str => Result {} [TcpWriteErr StreamErr]
    Tty.enable_raw_mode! : {} => {}
    Tty.disable_raw_mode! : {} => {}
    Url.reserve : Url, U64 -> Url
    Url.from_str : Str -> Url
    Url.to_str : Url -> Str
    Url.append : Url, Str -> Url
    Utc.now! : {} => Utc
    Utc.to_millis_since_epoch : Utc -> I128
    Utc.from_millis_since_epoch : I128 -> Utc
    Utc.to_nanos_since_epoch : Utc -> I128
    Utc.from_nanos_since_epoch : I128 -> Utc
    Utc.delta_as_millis : Utc, Utc -> U128
    Utc.delta_as_nanos : Utc, Utc -> U128
    Utc.to_iso_8601 : Utc -> Str
    """
