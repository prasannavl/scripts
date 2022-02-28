#!/bin/bash

# Tweaked for 32GB RAM
cat <<END | sudo tee /etc/sysctl.d/90-swappiness.conf && sudo sysctl --system
vm.swappiness=5
END
