#!/bin/bash
# OutputComponents.sh

########################## DO NOT MODIFY THE FOLLOWING LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ##########################
set -o posix; logErrorMsg() { printf "\n\e[43m\e[30m%s\n\e[0m" "${1}" >> /dev/stderr; }; logErrorMsgAndExit1() { logErrorMsg "${1}"; exit 1; }; determineDirectoryPath() { local CURRENT_FILE_PATH CURRENT_DIRECTORY_PATH; CURRENT_FILE_PATH="${BASH_SOURCE[0]}"; while [ -h "$CURRENT_FILE_PATH" ]; do CURRENT_DIRECTORY_PATH="$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; CURRENT_FILE_PATH="$(readlink "$CURRENT_FILE_PATH")"; [[ $CURRENT_FILE_PATH != /* ]] && CURRENT_FILE_PATH="$CURRENT_DIRECTORY_PATH/$CURRENT_FILE_PATH"; done; printf "%s" "$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; }; loadLibrary() { [[ ! -x "${1}" ]] && logErrorMsg "Error! Failed to load ${1}!" && logErrorMsgAndExit1 "The script either does not exist, or is not executable."; . ${1} ${2}; }; loadLibrary "$(determineDirectoryPath)/config.sh";
########################################## Please place all dsh calls after this line ####################################

dsh -n OutputComponent "${app_name}" MainMenu Menus 0 '<div class="ddms-docs-main-menu-container"><ul class="ddms-docs-main-menu"><li><a href="./">Home</a><a href="./index.php?responseOverview">Response Overview</a><a href="./index.php?outputComponentOverview">Output Component Overview</a></li></ul></div>'
dsh -a "${app_name}" MainMenu MainMenu Menus OutputComponent

dsh -n DynamicOutputComponent "${app_name}" ResponseOverview ResponseOverviewContent 0 'ResponseOverview.php'
dsh -a "${app_name}" ResponseOverview ResponseOverview ResponseOverviewContent DynamicOutputComponent

dsh -n DynamicOutputComponent "${app_name}" OutputComponentOverview OutputComponentsOverviewContent 0 'OutputComponentOverview.php'
dsh -a "${app_name}" OutputComponentOverview OutputComponentOverview OutputComponentsOverviewContent DynamicOutputComponent

