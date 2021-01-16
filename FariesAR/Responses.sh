#!/bin/bash
# Responses.sh

# DevNote: This App utilizes the HtmlStructure App's positioning layout.
# @see HtmlStructure/Responses.sh for information on what positions
# are defined.

########################## DO NOT MODIFY THE FOLLOWING LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ##########################
set -o posix; logErrorMsg() { printf "\n\e[43m\e[30m%s\n\e[0m" "${1}" >> /dev/stderr; }; logErrorMsgAndExit1() { logErrorMsg "${1}"; exit 1; }; determineDirectoryPath() { local CURRENT_FILE_PATH CURRENT_DIRECTORY_PATH; CURRENT_FILE_PATH="${BASH_SOURCE[0]}"; while [ -h "$CURRENT_FILE_PATH" ]; do CURRENT_DIRECTORY_PATH="$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; CURRENT_FILE_PATH="$(readlink "$CURRENT_FILE_PATH")"; [[ $CURRENT_FILE_PATH != /* ]] && CURRENT_FILE_PATH="$CURRENT_DIRECTORY_PATH/$CURRENT_FILE_PATH"; done; printf "%s" "$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; }; loadLibrary() { [[ ! -x "${1}" ]] && logErrorMsg "Error! Failed to load ${1}!" && logErrorMsgAndExit1 "The script either does not exist, or is not executable."; . ${1} ${2}; }; loadLibrary "$(determineDirectoryPath)/config.sh";
########################################## Please place all dsh calls after this line ####################################

dsh -n GlobalResponse "${app_name}" GlobalStyles 2

dsh -n GlobalResponse "${app_name}" GlobalScripts 3

dsh -n Response "${app_name}" ARStyles 3

dsh -n Response "${app_name}" ARScripts 3

dsh -n GlobalResponse "${app_name}" Banner 5

dsh -n Response "${app_name}" Homepage 6

dsh -n Response "${app_name}" ARDemo 6

dsh -n GlobalResponse "${app_name}" Footer 99999