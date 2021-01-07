#!/bin/sh

# curl ipecho.net/plain -s | xargs echo
dig +short myip.opendns.com @resolver1.opendns.com
