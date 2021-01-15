#!/bin/bash
# OutputComponents.sh

########################## DO NOT MODIFY THE FOLLOWING LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ##########################
set -o posix; logErrorMsg() { printf "\n\e[43m\e[30m%s\n\e[0m" "${1}" >> /dev/stderr; }; logErrorMsgAndExit1() { logErrorMsg "${1}"; exit 1; }; determineDirectoryPath() { local CURRENT_FILE_PATH CURRENT_DIRECTORY_PATH; CURRENT_FILE_PATH="${BASH_SOURCE[0]}"; while [ -h "$CURRENT_FILE_PATH" ]; do CURRENT_DIRECTORY_PATH="$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; CURRENT_FILE_PATH="$(readlink "$CURRENT_FILE_PATH")"; [[ $CURRENT_FILE_PATH != /* ]] && CURRENT_FILE_PATH="$CURRENT_DIRECTORY_PATH/$CURRENT_FILE_PATH"; done; printf "%s" "$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; }; loadLibrary() { [[ ! -x "${1}" ]] && logErrorMsg "Error! Failed to load ${1}!" && logErrorMsgAndExit1 "The script either does not exist, or is not executable."; . ${1} ${2}; }; loadLibrary "$(determineDirectoryPath)/config.sh";

########################################## Please place all dsh calls after this line ####################################

dsh -n OutputComponent "${app_name}" Doctype OpeningHtml 0 "<!DOCTYPE html>"
dsh -a "${app_name}" DoctypeOpenHtmlOpenHeadTitle Doctype OpeningHtml OutputComponent

dsh -n OutputComponent "${app_name}" OpeningHtmlTag OpeningHtml 0.01 '<html lang="en">'
dsh -a "${app_name}" DoctypeOpenHtmlOpenHeadTitle OpeningHtmlTag OpeningHtml OutputComponent

dsh -n OutputComponent "${app_name}" OpeningHeadTag OpeningHtml 0.02 "<head>"
dsh -a "${app_name}" DoctypeOpenHtmlOpenHeadTitle OpeningHeadTag OpeningHtml OutputComponent

dsh -n DynamicOutputComponent "${app_name}" Title title 0.03 "Title.php"
dsh -a "${app_name}" DoctypeOpenHtmlOpenHeadTitle Title title DynamicOutputComponent

dsh -n OutputComponent "${app_name}" MetaComment meta 0 '<!-- meta data -->'
dsh -a "${app_name}" Meta MetaComment meta OutputComponent

dsh -n OutputComponent "${app_name}" StylesComment css 0 '<!-- css -->'
dsh -a "${app_name}" Styles StylesComment css OutputComponent

dsh -n OutputComponent "${app_name}" ScriptsComment javascript 0 '<!-- javascript  -->'
dsh -a "${app_name}" Scripts ScriptsComment javascript OutputComponent

