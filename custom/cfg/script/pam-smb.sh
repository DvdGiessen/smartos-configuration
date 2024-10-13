#!/bin/bash

# PAM module that automatically updates SMB password when Unix password is set
echo -e 'other\tpassword required\tpam_smb_passwd.so.1\tnowarn' >> /etc/pam.conf
