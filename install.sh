#! /bin/bash
set -eu -o pipefail # fail on error and report it, debug all lines

sudo -n true
test $? -eq 0 || exit 1 "you should have sudo privilege to run this script"


function check (
if [ ! -f "/etc/fail2ban/fail2ban.conf" ]; then
    echo 'F2b is not installed.'
    install_f2b
    exit 1;
    else
    echo "F2B is installed"
    check_runstate

    fi

)


function install_f2b (
    echo "Install f2b";
    echo -e "\n";
    echo "Updating apt repositorys and";
    echo "installing the Fail2ban package";
    echo "you have 5 seconds to proceed ...";
    echo "or";
    echo "hit Ctrl+C to quit";
    echo -e "\n";
    sleep 6
    # Updating and installing fail2ban
    apt-get update
    apt-get upgrade -y
    apt-get install -y fail2ban
    configure_f2b
)

function check_runstate (
    service=fail2ban
    if [ $(ps aux | grep -v grep | grep $service | wc -l) -gt 0 ]
    then
        echo "$service is running!!!"
    else
        echo "$service is not running!!!"
        configure_f2b
    fi
)

function configure_f2b (
    #echo "Not completed!"
    cp /etc/fail2ban/fail2ban.conf /etc/fail2ban/fail2ban.local
    cp /etc/fail2ban/jail.conf /etc/fail2ban/jail.local
    systemctl start fail2ban
    systemctl enable fail2ban
    echo "Done, Installing and configure F2b with default settings.";
)
check

