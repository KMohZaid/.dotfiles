#!/usr/bin/env bash

SCRIPT_DIR=$(dirname "$(realpath "${BASH_SOURCE[0]}")")
sudo nixos-rebuild switch --flake $SCRIPT_DIR
