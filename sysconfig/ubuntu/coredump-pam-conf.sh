#!/bin/bash

cat <<END | sudo tee /etc/security/limits.d/40-coredump.conf
# core dump limits
# (limits in KB or unlimited)

*     -  core unlimited
root  -  core unlimited

END
