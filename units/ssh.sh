#!/bin/sh

if eval "$(ssh-agent -s)"; then
    echo "Adding SSH keys to agent..."
    ssh-add
fi 
