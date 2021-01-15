#!/bin/bash
# Responses.sh

########################## DO NOT MODIFY THE FOLLOWING LINE UNLESS YOU KNOW WHAT YOU ARE DOING! ##########################
set -o posix; logErrorMsg() { printf "\n\e[43m\e[30m%s\n\e[0m" "${1}" >> /dev/stderr; }; logErrorMsgAndExit1() { logErrorMsg "${1}"; exit 1; }; determineDirectoryPath() { local CURRENT_FILE_PATH CURRENT_DIRECTORY_PATH; CURRENT_FILE_PATH="${BASH_SOURCE[0]}"; while [ -h "$CURRENT_FILE_PATH" ]; do CURRENT_DIRECTORY_PATH="$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; CURRENT_FILE_PATH="$(readlink "$CURRENT_FILE_PATH")"; [[ $CURRENT_FILE_PATH != /* ]] && CURRENT_FILE_PATH="$CURRENT_DIRECTORY_PATH/$CURRENT_FILE_PATH"; done; printf "%s" "$(cd -P "$(dirname "$CURRENT_FILE_PATH")" >/dev/null 2>&1 && pwd)"; }; loadLibrary() { [[ ! -x "${1}" ]] && logErrorMsg "Error! Failed to load ${1}!" && logErrorMsgAndExit1 "The script either does not exist, or is not executable."; . ${1} ${2}; }; loadLibrary "$(determineDirectoryPath)/config.sh";

########################################## Please place all dsh calls after this line ####################################

# dsh -n GlobalResponse "${app_name}" GlobalResponseName 0
# dsh -n Response "${app_name}" ResponseName 0


# Apps relying on this App for the Html structure of their output MUST not define
# any Responses or GlobalResponses at position 0, it is reserved for the Doctype,
# opening <html> tag, opening <head> tag, and <title>...</title> tags.
dsh -n GlobalResponse "${app_name}" DoctypeOpenHtmlOpenHeadTitle 0

# Apps relying on this App for the Html structure of their output can either assign
# OutputComponents or DynamicOutputComponents that define <meta> tags to the Meta
# GlobalResponse, or if OutputComponents or DynmaicOutputComponents are defined
# for <meta> tags that are intended to be shown in response to a specific request
# they can be assigned to appropriate Responses whose position is 1.
dsh -n GlobalResponse "${app_name}" Meta 1

# Apps relying on this App for the Html structure of their output can either
# assign OutputComponents or DynamicOutputComponents that define <style> or
# <link> tags to the Meta GlobalResponse, or if OutputComponents or
# DynmaicOutputComponents are defined for <style> or <link> tags that are
# intended to be shown in response to a specific request they can be assigned
# to appropriate Responses whose position is 2.
dsh -n GlobalResponse "${app_name}" Styles 2

# Apps relying on this App for the Html structure of their output can either assign
# OutputComponents or DynamicOutputComponents that define <script> tags to the Meta
# GlobalResponse, or if OutputComponents or DynmaicOutputComponents are defined
# for <script> tags that are intended to be shown in response to a specific request
# they can be assigned to appropriate Responses whose position is 3.
dsh -n GlobalResponse "${app_name}" Scripts 3

# Apps relying on this App for the Html structure of their output MUST not define
# any Responses or GlobalResponses at position 4, it is reserved for the closing,
# <head> tag, and opening <body> tag.
dsh -n GlobalResponse "${app_name}" CloseHeadOpenBody 4

# All output that is intened to exist within the <body>...</body> tags can be assigned
# either to the Content GlobalResponse, or a Response whose position is 5.
dsh -n GlobalResponse "${app_name}" Content 5

# The position of the CloseBodyCloseHtml GlobalResponse is set high on purpose to
# attempt to avoid output shwoing up after the closing <body> and closing html
# <tags>.
dsh -n GlobalResponse "${app_name}" CloseBodyCloseHtml 9999999999999999

