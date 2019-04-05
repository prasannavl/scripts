#!/bin/bash

cat <<END | sudo tee /etc/sysctl.d/40-inotify.conf && sudo sysctl --system
fs.inotify.max_queued_events=16384
fs.inotify.max_user_instances=4096
fs.inotify.max_user_watches=1048576
END
