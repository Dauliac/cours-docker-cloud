#!/bin/bash
# Fork        : github.com/TonyChG
# Date        : Fri 28 Sep 2018 11:35:49 AM CEST
# Version     : 0.0.1
# Description :


INSTALL_DOCKER=false
REVERT_MODE=false
DOCKER_USER="vagrant"

function log {
    format="$1"
    shift
    arguments="$@"
    printf "$(date +%T\ %F) $format\n" "$arguments"
}


function logError {
    >&2 log "ERROR $@"
}


function header {
    echo -e "\
###############################################################################
#                             Service INSTALLER                               #
###############################################################################
"
}


function show_help {
    >&2 echo -e "$(header)

    Usage : $0 [OPTIONS]

            --revert    Uninstall the service specify in parameters
            --docker    Install/Uninstall Docker-ce
"
    exit 1
}


function docker {
    DOCKER_REPO="https://download.docker.com/linux/centos/docker-ce.repo"
    DOCKER_REPO_TARGET="/etc/yum.repos.d/docker-ce.repo"

    if ! [[ -x "/bin/yum" ]]; then
        logError "yum is not installed"
        exit 1
    fi
    if $REVERT_MODE; then
        log "Uninstall docker"
        if [[ -f "$DOCKER_REPO_TARGET" ]]; then
            rm -f "$DOCKER_REPO_TARGET"
            log "Update packages ..."
            >/dev/null 2>&1 /bin/yum update -q -y
        fi
    else
        log "Update packages ..."
        >/dev/null 2>&1 /bin/yum update -q -y

        >/dev/null 2>&1 /bin/yum install -q -y epel-release
        log "Install epel-release"
        if ! [[ -f "/usr/bin/wget" ]]; then
            >/dev/null 2>&1 /bin/yum install -q -y wget
            log "Install wget"
        fi
        /usr/sbin/setenforce 0
        sed -i "s/SELINUX=enforcing/SELINUX=disabled/" /etc/sysconfig/selinux
        /usr/bin/wget -qO "$DOCKER_REPO_TARGET" "$DOCKER_REPO"
        log "Adding docker repo"
        >/dev/null 2>&1 /bin/yum update -q -y
        log "Update packages ..."
        >/dev/null 2>&1 /bin/yum install -q -y device-mapper-persistent-data lvm2 libseccomp
        log "Install docker dependencies"
        >/dev/null 2>&1 /bin/yum install -q -y docker-ce
        log "Install docker"
        systemctl enable docker
        log "Enable docker"
        systemctl start docker
        log "Start docker"
        gpasswd -a $DOCKER_USER docker
    fi
}

function exec_cmdline {
    if $INSTALL_DOCKER; then docker; fi
}


if [[ $# -ne 0 ]]; then
    while ! [[ -z $1 ]]; do
        LABEL=$(echo $1 | awk -F= '{print $1}')
        VALUE=$(echo $1 | awk -F= '{print $2}')
        case $LABEL in
            --docker)
                INSTALL_DOCKER=true
                ;;
            --revert|-r)
                REVERT_MODE=true
                ;;
            *)
                logError "Unknow options: %s" $LABEL
                show_help
                ;;
        esac
        shift
    done
    exec_cmdline
else
    show_help
fi
