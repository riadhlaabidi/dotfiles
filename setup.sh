#!/bin/sh

set -e

# sudo dnf install python3-libdnf5

sudo dnf install ansible

ansible-playbook main.yml -i inventory --ask-become-pass --connection=local -v

exit 0
