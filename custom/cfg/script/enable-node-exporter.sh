#!/bin/bash

# The node_exporter service installed via pkgsrc is not enabled by default,
# so we detect if it is installed and then enable it automatically at boot
if svcs pkgsrc/node_exporter &>/dev/null ; then
    svcadm enable node_exporter
fi
