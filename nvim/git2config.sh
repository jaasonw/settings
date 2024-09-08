#!/bin/bash

echo "You are about to apply the contents of the current directory to your nvim config. Continue? [y/N]"
echo "WARNING: This overwrites your current nvim config."
echo "Current directory: $(pwd)"
read answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
echo "Operation canceled."
exit 1
fi

echo "Running rsync..."
rsync -rtv . ~/.config/nvim
