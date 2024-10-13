#!/bin/bash

# This is a workaround for https://smartos.org/bugview/OS-6312,
# which impacts various Linux programs running in an LX zone.
#
# To summarize, the X/Open standard requires that calls to setsockopts() fail if the
# socket cannot be written to anymore. However, in Linux this is valid. So to prevent
# setsockopts() from returning an error, which Linux software usually doesn't handle
# well, instead we disable these X/Open checks by toggling an illumos kernel flag.
echo "xnet_skip_checks/W1" | mdb -kw
