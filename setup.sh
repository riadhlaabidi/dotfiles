#!/bin/sh

sudo dnf install ansible
ansible-playbook main.yml -i inventory --ask-become-pass --connection=local
