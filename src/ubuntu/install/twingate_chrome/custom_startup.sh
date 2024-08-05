#!/usr/bin/env bash
set -ex
START_COMMAND="google-chrome"
PGREP="chrome"
MAXIMIZE="true"
DEFAULT_ARGS=""

if [[ $MAXIMIZE == 'true' ]] ; then
    DEFAULT_ARGS+=" --start-maximized"
fi
ARGS=${APP_ARGS:-$DEFAULT_ARGS}

options=$(getopt -o gau: -l go,assign,url: -n "$0" -- "$@") || exit
eval set -- "$options"

while [[ $1 != -- ]]; do
    case $1 in
        -g|--go) GO='true'; shift 1;;
        -a|--assign) ASSIGN='true'; shift 1;;
        -u|--url) OPT_URL=$2; shift 2;;
        *) echo "bad option: $1" >&2; exit 1;;
    esac
done
shift

# Process non-option arguments.
for arg; do
    echo "arg! $arg"
done

FORCE=$2

kasm_exec() {
    if [ -n "$OPT_URL" ] ; then
        URL=$OPT_URL
    elif [ -n "$1" ] ; then
        URL=$1
    fi

    # Since we are execing into a container that already has the browser running from startup,
    #  when we don't have a URL to open we want to do nothing. Otherwise a second browser instance would open.
    if [ -n "$URL" ] ; then
        /usr/bin/filter_ready
        /usr/bin/desktop_ready
        $START_COMMAND $ARGS $OPT_URL
    else
        echo "No URL specified for exec command. Doing nothing."
    fi
}

kasm_startup() {

    if [ -n "$KASM_URL" ] ; then
        URL=$KASM_URL
    elif [ -z "$URL" ] ; then
        URL=$LAUNCH_URL
    fi


    # update the ca certificate, so agent mounted cert are used
    sudo update-ca-certificates

    # setup agent custom startup script
    if [ -f /agentless_custom_script/twingate_chrome_startup.sh ]; then
        sudo cp /agentless_custom_script/twingate_chrome_startup.sh /dockerstartup/
        sudo bash /dockerstartup/twingate_chrome_startup.sh
    fi

    if [ -z "$DISABLE_CUSTOM_STARTUP" ] ||  [ -n "$FORCE" ] ; then

        echo "Entering process startup loop"
        set +x
        while true
        do
            if ! pgrep -x $PGREP > /dev/null
            then
                /usr/bin/filter_ready
                /usr/bin/desktop_ready
                systemctl --user start twingate-desktop-notifier

                sleep 5s
#                URL=`twingate status | grep "https*"`
#                echo "Twingate URL Set to $URL"
                set +e
                $START_COMMAND $ARGS $URL &
                set -e
                sleep 3s
                sudo -E /dockerstartup/twingate_init.sh
            fi
            sleep 1
        done
        set -x

    fi

} 

if [ -n "$GO" ] || [ -n "$ASSIGN" ] ; then
    kasm_exec
else
    kasm_startup
fi
