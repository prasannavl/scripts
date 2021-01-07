#!/bin/bash

# Nvidia optimus
# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/primerenderoffload.html
# https://download.nvidia.com/XFree86/Linux-x86_64/440.82/README/dynamicpowermanagement.html

# __GL_SYNC_TO_VBLANK=0 for vsync off 

__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
