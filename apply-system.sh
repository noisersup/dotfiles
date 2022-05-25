#!/bin/sh
pushd ~/.dotfiles/
nixos-rebuild switch --use-remote-sudo --flake .#
popd
