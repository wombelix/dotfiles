#!/bin/bash

# SPDX-FileCopyrightText: 2024 Dominik Wombacher
#
# SPDX-License-Identifier: MIT

declare -A TOOLS
TOOLS["reuse"]="pipx install reuse"
TOOLS["pre-commit"]="pipx install pre-commit"
TOOLS["shellcheck"]="<packagemanager> install ShellCheck"

RC=0

echoerr() {
    echo "[ERROR] $*" 1>&2;
    RC=1
}

echoinfo() {
    echo "[INFO] $*"
}

echoinfo "Verify that tools are installed"
for i in "${!TOOLS[@]}"
do
    if ! command -v "$i" &> /dev/null; then
        echoerr "$i not installed"
        RC=1
        break
    fi
done

if [ "$RC" == 0 ]; then
    echoinfo "Setup devel environment"
    pre-commit install
    reuse lint
    shellcheck -x ./*.sh
fi

exit $RC
