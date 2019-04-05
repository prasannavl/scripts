#!/bin/bash

cat <<END | sudo tee /etc/sudoers.d/10-timeout
# timeout minutes for asking password again
Defaults    timestamp_timeout=720
END
