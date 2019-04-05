#!/bin/bash

sudo sed -i -E '/^GRUB_TIMEOUT=/s/10/3/' /etc/default/grub
update-grub
