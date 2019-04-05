#!/bin/sh

{
    cat <<END
# enable all users in wheel group
%wheel  ALL=(ALL)       ALL
END
} | sudo tee /etc/sudoers.d/10-wheel
