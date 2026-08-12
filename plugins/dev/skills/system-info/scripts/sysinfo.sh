#!/bin/sh
set -eu

TOOLS="git node npm python3 docker rustc"
NOT_INSTALLED="not installed"

echo "== System =="
echo "os: $(uname -s) $(uname -r)"
echo "arch: $(uname -m)"
echo "hostname: $(hostname)"
echo "shell: ${SHELL:-unknown}"

echo "== Tools =="
for tool in $TOOLS; do
  if command -v "$tool" >/dev/null 2>&1; then
    echo "$tool: $("$tool" --version 2>/dev/null | head -n 1)"
  else
    echo "$tool: $NOT_INSTALLED"
  fi
done
