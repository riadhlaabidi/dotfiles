#!/bin/sh

SUCCESS_CC=32
FAILURE_CC=31
SUCCESS_MSG="OK"
FAILURE_MSG="FAILED"

GIT_SSH="git@github.com:riadhlaabidi"

get_status() {
    if [[ $# -eq 1 ]]; then
        if [[ $1 -eq 0 ]]; then
            echo -e "\x1b[1;${SUCCESS_CC}m${SUCCESS_MSG}\x1b[m"
        else
            echo -e "\x1b[0;${FAILURE_CC}m${FAILURE_MSG}\x1b[m"
        fi
    fi
}
