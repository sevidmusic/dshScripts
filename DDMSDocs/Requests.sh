#!/bin/bash
# Requests.sh

########################## DO NOT MODIFY THE FOLLOWING LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ##########################
set -o posix; logErrorMsg() { printf "\n\e[43m\e[30m%s\n\e[0m" "${1}" >> /dev/stderr; }; logErrorMsgAndExit1() { logErrorMsg "${1}"; exit 1; }; determineDirectoryPath() { local CURRENT_FILE_PATH CURRENT_DIRECTORY_PATH; CURRENT_FILE_PATH="${BASH_SOURCE[0]}"; while [ -h "$CURRENT_FILE_PATH" ]; do CURRENT_DIRECTORY_PATH="$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; CURRENT_FILE_PATH="$(readlink "$CURRENT_FILE_PATH")"; [[ $CURRENT_FILE_PATH != /* ]] && CURRENT_FILE_PATH="$CURRENT_DIRECTORY_PATH/$CURRENT_FILE_PATH"; done; printf "%s" "$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; }; loadLibrary() { [[ ! -x "${1}" ]] && logErrorMsg "Error! Failed to load ${1}!" && logErrorMsgAndExit1 "The script either does not exist, or is not executable."; . ${1} ${2}; }; loadLibrary "$(determineDirectoryPath)/config.sh";
########################################## Please place all dsh calls after this line ####################################

dsh -n Request "${app_name}" HomepageRoot HomepageRequests "\/"
dsh -a "${app_name}" Homepage HomepageRoot HomepageRequests Request

dsh -n Request "${app_name}" HomepageIndex HomepageRequests "index.php"
dsh -a "${app_name}" Homepage HomepageIndex HomepageRequests Request

dsh -n Request "${app_name}" HomepageHome HomepageRequests "index.php?home"
dsh -a "${app_name}" Homepage HomepageHome HomepageRequests Request

dsh -n Request "${app_name}" HomepageHomepage HomepageRequests "index.php?homepage"
dsh -a "${app_name}" Homepage HomepageHomepage HomepageRequests Request

dsh -n Request "${app_name}" ResponseOverview ResponseOverviewRequests "index.php?responseOverview"
dsh -a "${app_name}" ResponseOverview ResponseOverview ResponseOverviewRequests Request

dsh -n Request "${app_name}" OutputComponentOverview OutputComponentOverviewRequests "index.php?outputComponentOverview"
dsh -a "${app_name}" OutputComponentOverview OutputComponentOverview OutputComponentOverviewRequests Request

