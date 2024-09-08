#!/bin/bash

echo "You are about to copy the contents of ~/.config/nvim to this directory. Continue? [y/N]"
echo "Current directory: $(pwd)"
read answer
if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
echo "Operation canceled."
exit 1
fi

echo "Running rsync..."
rsync -rtv ~/.config/nvim .
