[![Roc-Lang][roc_badge]][roc_link]

[roc_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fpastebin.com%2Fraw%2FcFzuCCd7
[roc_link]: https://github.com/roc-lang/roc

# roc-agent

AI agent setup for Roc programming. Makes Claude write code in a loop until:
- `roc check` runs without errors or warnings.
- All top level expect tests pass with `roc test`.
- `roc dev` finishes with exit code 0.

The above options are configurable by setting the Bools `run_roc_test` and `run_roc_dev`.

Note: the roc-agent can currently only work with a single `.roc` file.

:bangbang: This lets Claude run code on your machine autonomously without restrictions. It is unlikely that Claude will screw something up on your machine, but use caution and make sure you don't copy paste a prompt from an untrusted source.

## Usage


1. Alter `prompt_text` and `system_prompt` in main.roc to fit your purpose.
1. Get an [Anthropic API key](https://www.merge.dev/blog/anthropic-api-key)
1. Run with:
    ```
    $ export ANTHROPIC_API_KEY=YOURAPIKEY
    $ roc main.roc
    ```
