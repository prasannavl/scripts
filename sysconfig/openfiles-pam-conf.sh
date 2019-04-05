#!/bin/bash

cat <<END | sudo tee /etc/security/limits.d/40-open-files.conf
*     -  nofile 1048576
root  -  nofile 1048576
END
