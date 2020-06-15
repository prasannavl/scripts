#!/bin/bash

# Nvidia optimus

# __GL_SYNC_TO_VBLANK=0 for vsync off

__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia "$@"
