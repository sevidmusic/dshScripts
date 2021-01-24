#!/bin/bash
# draftMakeApp.sh [APP_NAME] [PATH_TO_APP_PACKAGE_PARENT_DIRECTORY]

set -o posix

# @todo dsh --get-app-package-config-setting [PATH_TO_APP_PACKAGE] [SETTING_NAME] : Return value of specified setting defined in specified [PATH_TO_APP_PACKAGE]'s config.sh
getConfigValue() {
    local path_to_app_package setting_name
    path_to_app_package="${1}"
    setting_name="${2}"
    printf "%s" "$(cat "${path_to_app_package}/config.sh" | grep "${setting_name}" | sed 's/^.*=//g' | sed 's/"//g')"
}

copyDirectoryContents() {
    local path_to_app_package source_directory_name app_name path_to_ddms target_directory
    path_to_app_package="${1}"
    source_directory_name="${2}"
    app_name="$(getConfigValue "${path_to_app_package}" 'app_name')"
    source_directory="${path_to_app_package}/${source_directory_name}"
    path_to_ddms="$(locateDDMSDirectory)"
    target_directory="${path_to_ddms}/Apps/${app_name}/"
    [[ ! -d "${source_directory}" ]] && printf "\nCannot copy files in \e[0m\e[102m\e[30m%s\e[0m to \e[0m\e[104m\e[30m%s\e[0m because \e[0m\e[102m\e[30m%s\e[0m does not exist\n" "${source_directory}" "${target_directory}" "${source_directory}" && exit 1
    printf "\nCopying files in \e[0m\e[102m\e[30m%s\e[0m to \e[0m\e[104m\e[30m%s\e[0m\n" "${source_directory}" "${target_directory}"
    cp -R "${source_directory}" "${target_directory}"
}

# @todo dsh --locate-ddms-directory : Return path to DDMS installation dsh is acting on
locateDDMSDirectory() {
    dsh -l
}

replaceApp() {
    local path_to_app_package path_to_ddms app_name doReplace
    path_to_app_package="${1}"
    path_to_ddms="$(locateDDMSDirectory)"
    app_name="$(getConfigValue "${path_to_app_package}" 'app_name')"
    if [[ -d "${path_to_ddms}/Apps/${app_name}" ]]; then
        read -p "An App named ${app_name} already exists, would you like to replace it? (y or n) : " doReplace
        [[ "${doReplace}" != 'y' ]] && printf "\n\e[0m\e[105m\e[30mThe ${app_name} App Package will not be made.\e[0m\n" && exit 1
        [[ "${app_name}" != 'Apps' ]] && rm -R "${path_to_ddms}/Apps/${app_name}" && printf "\e[0m\e[102m\e[30mRemoved original App from ${path_to_ddms}/Apps/${app_name}"
    fi
}

copyBaseFiles() {
    local path_to_app_package
    path_to_app_package="${1}"
    # cp base files...
    [[ -d "${path_to_app_package}/css" ]] && copyDirectoryContents "${path_to_app_package}" css
    [[ -d "${path_to_app_package}/js" ]] && copyDirectoryContents "${path_to_app_package}" js
    [[ -d "${path_to_app_package}/DynamicOutput" ]] && copyDirectoryContents "${path_to_app_package}" DynamicOutput
    # Media is an optional directory, it is not created by dsh -n AppPackage, so the documentation will need to address it, the Media directory will be where the App's images, audio files, etc. are placed.
    # @todo Perhaps dsh -n AppPackage should create the Media directory...
    [[ -d "${path_to_app_package}/Media" ]] && copyDirectoryContents "${path_to_app_package}" Media
}

runDshScripts() {
    local path_to_app_package
    path_to_app_package="${1}"
    # Run dsh scripts
    [[ ! -x "${path_to_app_package}/Responses.sh" ]] && printf "Responses.sh is either does not exist or is not executable." && exit 1
    . "${path_to_app_package}/Responses.sh"
    [[ ! -x "${path_to_app_package}/Requests.sh" ]] && printf "Requests.sh is either does not exist or is not executable." && exit 1
    . "${path_to_app_package}/Requests.sh"
    [[ ! -x "${path_to_app_package}/OutputComponents.sh" ]] && printf "OutputComponents.sh is either does not exist or is not executable." && exit 1
    . "${path_to_app_package}/OutputComponents.sh"
}

makeApp() {
    local path_to_app_package app_name
    path_to_app_package="${1}"
    app_name="$(getConfigValue "${path_to_app_package}" 'app_name')"
    [[ -z "${app_name}" ]] && printf "\n\e[103m\e[30mThe app_name could not be determined. app_name is: %s" "${app_name}" && exit 1
    replaceApp "${app_name}"
    dsh -n App "${app_name}" "$(getConfigValue "${path_to_app_package}"  'domain')"
    copyBaseFiles "${path_to_app_package}"
    runDshScripts "${path_to_app_package}"
}

[[ -z "${1}" ]] && printf "\n\e[103m\e[0mPlease specify the path to the AppPackage as the first parameter.\e[0m\n" && exit 1
[[ ! -d "${1}" ]] && printf "\n\e[103m\e[30mAn AppPackage does not exist at %s" "${1}" && exit 1
makeApp "${1}"

