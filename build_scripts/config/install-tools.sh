#!/bin/bash

DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${DIR}" ]]; then DIR="${PWD}"; fi

ROOT_DIR="${DIR}/../.."

OPTION_GIT_HOOKS="--git-hooks"

function installGitHooks {
    copy ${DIR}/prepare-commit-msg ${ROOT_DIR}/.git/hooks/prepare-commit-msg "Git Hooks"
}

function copy {
    local originalFile=$1
    local targetFile=$2
    local message=$3
    local need_replace=true

    echo
    echo "------------------------------------------------------"
    echo "${message}"
    echo "------------------------------------------------------"

    if [[ -f ${targetFile} ]]; then
        echo
        echo "File '${targetFile}' has already existed. "
        echo "Would you like to replace it? (y/n)"
        read -p "Your answer (default=yes): " answer
        echo
        case ${answer} in
            y|yes|"")
                need_replace=true
                ;;
            n|no)
                need_replace=false
                ;;
            *)
                need_replace=false
                echo "Unknown answer, skip replacing of file"
                ;;
        esac
    fi

    if [[ ${need_replace} == "true" ]]; then
        echo -n "Copy: "
        cp -rv ${originalFile} ${targetFile}
        echo
        echo "${message} successfully installed!"
    fi
}

if [[ "$#" -ne 1 ]]; then
  howTo
  exit 1
fi

case ${1} in
    ${OPTION_GIT_HOOKS})
        installGitHooks
        ;;
    *)
        howTo
        exit 1
        ;;
esac
