#!/bin/bash

cat <<END | sudo tee /etc/default/grub.d/90-timeout.cfg
GRUB_TIMEOUT=3
END
