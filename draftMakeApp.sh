#!/bin/bash
# draftMakeApp.sh [APP_NAME] [PATH_TO_APP_PACKAGE_PARENT_DIRECTORY]

set -o posix

[[ -z "${1}" ]] && printf "\n\e[103m\e[0mPlease specify the path to the AppPackage as the first parameter.\e[0m\n" && exit 1
[[ ! -d "${1}" ]] && printf "\n\e[103m\e[30mAn AppPackage does not exist at %s" "${1}" && exit 1

devCleanUp() {
    # dev only
    killall php
    # dev only
    [[ -d "${1}/.dcmsJsonData" ]] && rm -R "${1}/.dcmsJsonData" && printf "\nRemoved .dcmsJsonData\n"
}

# Mimic [PATH_TO_APP_PACKAGE] parameter
path_to_app_package="${1}"

# Mimic [START_DEVELOPMENT_SERVER] parameter
start_development_server="${2:-0}"


# @todo dsh --locate-ddms-directory : Return path to DDMS installation dsh is acting on
path_to_ddms="${HOME}/DarlingDataManagementSystem"

# @todo dsh --get-app-package-setting [PATH_TO_APP_PACKAGE] [SETTING_NAME] : Return value of specified setting defined in specified [PATH_TO_APP_PACKAGE]'s config.sh
app_name="$(cat "${path_to_app_package}/config.sh" | grep 'app_name' | sed 's/^.*=//g' | sed 's/"//g')"

[[ -z "${app_name}" ]] && printf "\n\e[103m\e[30mThe app_name could not be determined. app_name is: %s" "${app_name}" && exit 1

# dev only
clear

####### Draft dsh --make-app [PATH_TO_APP_PACKAGE] [START_DEVELOPMENT_SERVER] logic #######
#######     Use the following as a guide to define appropriate tests for dsh -m     #######

if [[ -d "${path_to_ddms}/Apps/${app_name}" ]]; then
    read -p "An App named ${app_name} already exists, would you like to replace it? (y or n) : " replaceApp
    [[ "${replaceApp}" != 'y' ]] && printf "\n\e[0m\e[105m\e[30mThe ${app_name} App Package will not be made.\e[0m\n" && exit 1
    devCleanUp "${path_to_ddms}"
    rm -R "${path_to_ddms}/Apps/${app_name}" && printf "\e[0m\e[102m\e[30mRemoved original App from ${path_to_ddms}/Apps/${app_name}"
fi

dsh -n App "${app_name}"

[[ -x "${path_to_app_package}/Responses.sh" ]] && . "${path_to_app_package}/Responses.sh"

[[ -x "${path_to_app_package}/Requests.sh" ]] && . "${path_to_app_package}/Requests.sh"

[[ -x "${path_to_app_package}/OutputComponents.sh" ]] && . "${path_to_app_package}/OutputComponents.sh"

# cp base files...

dsh -b "${app_name}"

[[ "${start_development_server}" == '1' ]] && dsh -s


