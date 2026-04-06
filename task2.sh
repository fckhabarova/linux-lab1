#!/bin/bash

DOC_DIR="/usr/share/doc/khabarova"

sudo install -m 754 myapp /usr/bin/myapp

sudo install -m 644 mylib.lib /usr/lib/mylib.lib

sudo mkdir -p "$DOC_DIR"
sudo install -m 644 mydoc.doc "$DOC_DIR/mydoc.doc"

echo "Installation completed"
