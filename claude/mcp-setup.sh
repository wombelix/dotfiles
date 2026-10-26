#!/usr/bin/env bash

# SPDX-FileCopyrightText: 2026 Dominik Wombacher <dominik@wombacher.cc>
#
# SPDX-License-Identifier: MIT

# Add user-scope MCP servers for Claude Code, skip servers that already exist.
set -euo pipefail

if ! claude mcp get aws-knowledge-mcp-server > /dev/null 2>&1; then
  claude mcp add --transport http --scope user aws-knowledge-mcp-server https://knowledge-mcp.global.api.aws
fi

if ! claude mcp get opentofu > /dev/null 2>&1; then
  claude mcp add --transport http --scope user opentofu https://mcp.opentofu.org/mcp
fi

if ! claude mcp get ansible > /dev/null 2>&1; then
  # --transport stdio between --env and the name, so the CLI does not read the name as KEY=value
  claude mcp add --env WORKSPACE_ROOT=. --transport stdio --scope user ansible -- npx -y @ansible/ansible-mcp-server --stdio
fi
