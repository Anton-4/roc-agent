#!/usr/bin/env bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -exo pipefail

find . -type f -name "*.roc" | while read file; do
  # Check if file is ignored by git
  if git check-ignore -q "$file"; then
    continue
  fi

  roc format --check "$file"
done

roc check main.roc
roc check roc-starter-template.roc
roc check Prompt/example_code_basic_cli.roc

# Test basic-cli example code
HELLO=1 roc ./Prompt/example_code_basic_cli.roc -- \"https://www.roc-lang.org\" roc.html

roc test roc-starter-template.roc