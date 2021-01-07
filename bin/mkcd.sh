#!/bin/bash

# No set +e since this file is meant to be sourced
# not executed, since we need the change to propagate to the 
# previous shell. 

mkdir -p "$@" && cd "$@"