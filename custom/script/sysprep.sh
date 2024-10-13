#!/bin/bash
# SmartOS autostart setup script

# Include some variables with common values we'll use (for example exit status codes)
. /lib/svc/share/smf_include.sh

# Set up the path (since in a SMF service, this isn't necessarely set up)
PATH=/usr/sbin:/usr/bin:/opt/local/sbin:/opt/local/bin:$PATH; export PATH

# Return empty string for globs encountering an empty directory
shopt -s nullglob

# Depending on our operation
case "$1" in
    # Code run at boot
    'start')
        # Ensure correct default permissions on copied /root and /root/.ssh to prevent issues
        [[ -d "/opt/custom/cfg/root/root" ]] && chown root:root "/opt/custom/cfg/root/root" && chmod 755 "/opt/custom/cfg/root/root"
        [[ -d "/opt/custom/cfg/root/root/.ssh" ]] && chown root:root "/opt/custom/cfg/root/root/.ssh" && chmod 700 "/opt/custom/cfg/root/root/.ssh"

        # Copy files to the root filesystem
        if [[ -d "/opt/custom/cfg/root" ]] && [[ -n "$(echo "/opt/custom/cfg/root/"*)" ]] ; then
            cp -RpP "/opt/custom/cfg/root/"* /
        fi

        # Run custom scripts
        if [[ -d "/opt/custom/cfg/script" ]] && [[ -n "$(echo "/opt/custom/cfg/script/"*)" ]] ; then
            for FILE in "/opt/custom/cfg/script/"* ; do
                [[ -f "$FILE" ]] && [[ -x "$FILE" ]] && "$FILE"
            done
        fi

        # Add crontab items
        if [[ -d "/opt/custom/cfg/crontab" ]] && [[ -n "$(echo "/opt/custom/cfg/crontab/"*)" ]] ; then
            cat "/opt/custom/cfg/crontab/"* | crontab
        fi
        ;;

    # Code run at shutdown
    'stop')
        # Nothing here right now
        ;;

    # Default case
    *)
        # Show usage
        echo "Usage: $0 { start | stop }"

        # Exit with error status
        exit $SMF_EXIT_ERR_FATAL
        ;;
esac

# Exit with OK status
exit $SMF_EXIT_OK
