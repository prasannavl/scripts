#!/bin/bash

set -Eeuo pipefail

sudo swapoff -a || true
sudo swapon -a
