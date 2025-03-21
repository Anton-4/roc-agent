[![Roc-Lang][roc_badge]][roc_link]

[roc_badge]: https://img.shields.io/endpoint?url=https%3A%2F%2Fpastebin.com%2Fraw%2FcFzuCCd7
[roc_link]: https://github.com/roc-lang/roc

# roc-agent

LLM agent setup for Roc programming. Runs Claude in a loop until all tests pass.

:bangbang: This lets Claude run code on your machine autonomously without restrictions. It is unlikely that Claude will screw something up on your machine, but use caution and make sure you don't copy paste a prompt from an untrusted source.

## Usage

1. Get an [Anthropic API key](https://www.merge.dev/blog/anthropic-api-key)
2. Run with:
    ```
    $ export ANTHROPIC_API_KEY=YOURAPIKEY
    $ roc main.roc
    ```
