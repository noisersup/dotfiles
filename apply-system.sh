#!/bin/sh
pushd ~/.dotfiles/
sudo nixos-rebuild switch --flake .#
#nixos-rebuild switch --use-remote-sudo --flake .#
popd
