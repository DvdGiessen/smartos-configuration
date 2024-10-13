#!/bin/bash

# This sets the PATH for cronjobs to the same path as used by the root user
grep '^PATH=' /root/.profile | head -n1 >> /etc/default/cron
grep '^PATH=' /root/.profile | head -n1 | sed 's/^PATH=/SUPATH=/' >> /etc/default/cron

# We need to restart the cron service to apply the changes
svcadm restart cron
