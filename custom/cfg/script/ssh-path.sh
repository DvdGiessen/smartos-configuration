#!/bin/bash

# This sets the PATH used by remote commands over SSH to be the same as the one for interactive sessions
grep '^PATH=' /root/.profile | head -n1 >> /root/.ssh/environment
