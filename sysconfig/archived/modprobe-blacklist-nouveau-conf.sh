#!/bin/bash

{
    cat <<END
blacklist nouveau
options nouveau modeset=0
END
} | sudo tee /etc/modprobe.d/blacklist-nouveau.conf
