#!/bin/bash
# draftMakeApp.sh [APP_NAME] [PATH_TO_APP_PACKAGE_PARENT_DIRECTORY]

set -o posix

devCleanUp() {
    # dev only
    killall php
    # dev only
    [[ -d "${1}/.dcmsJsonData" ]] && rm -R "${1}/.dcmsJsonData" && printf "\nRemoved .dcmsJsonData\n"
}


# @todo dsh --locate-ddms-directory : Return path to DDMS installation dsh is acting on
path_to_ddms="${HOME}/DarlingDataManagementSystem"

# @todo dsh --get-app-package-setting [PATH_TO_APP_PACKAGE] [SETTING_NAME] : Return value of specified setting defined in specified [PATH_TO_APP_PACKAGE]'s config.sh
app_name="$(cat "${path_to_app_package}/config.sh" | grep 'app_name' | sed 's/^.*=//g' | sed 's/"//g')"

# Mimic [PATH_TO_APP_PACKAGE] parameter
path_to_app_package="${1}"

# Mimic [START_DEVELOPMENT_SERVER] parameter
start_development_server="${2:-0}"

# dev only
clear

####### Draft dsh --make-app [PATH_TO_APP_PACKAGE] [START_DEVELOPMENT_SERVER] logic #######
#######     Use the following as a guide to define appropriate tests for dsh -m     #######

[[ -z "${1}" ]] && printf "\n\e[103m\e[0mPlease specify a name for the App as the first parameter.\e[0m\n" && exit 1

if [[ -d "${path_to_ddms}/Apps/${1}" ]]; then
    read -p "An App named ${1} already exists, would you like to replace it? (y or n) : " replaceApp
    [[ "${replaceApp}" != 'y' ]] && printf "\n\e[0m\e[105m\e[30mThe ${1} App Package will not be made.\e[0m\n" && exit 1
    devCleanUp "${path_to_ddms}"
    rm -R "${path_to_ddms}/Apps/${1}" && printf "\e[0m\e[102m\e[30mRemoved original App from ${path_to_ddms}/Apps/${1}"
fi

dsh -n App "${1}"

[[ -x "${path_to_app_package}/Responses.sh" ]] && . "${path_to_app_package}/Responses.sh"

[[ -x "${path_to_app_package}/Requests.sh" ]] && . "${path_to_app_package}/Requests.sh"

[[ -x "${path_to_app_package}/OutputComponents.sh" ]] && . "${path_to_app_package}/OutputComponents.sh"

# cp base files...

dsh -b "${1}"

[[ "${start_development_server}" == '1' ]] && dsh -s


