#!/bin/sh

pushd ~/.dotfiles
nix build .#homeManagerConfigurations.user.activationPackage 
./result/activate
#home-manager switch -f ./users/user/home.nix
popd
