#!/bin/bash

set -Eeuo pipefail

sudo swapoff /swapfile || true
sudo swapon -a
