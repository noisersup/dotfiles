{ pkgs, ... }:
#with import <nixpkgs> { };

let
  arrowpkgs = import (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/2cdd608fab0af07647da29634627a42852a8c97f.tar.gz";
      sha256 = "1szv364xr25yqlljrlclv8z2lm2n1qva56ad9vd02zcmn2pimdih";
  }) {};

in with pkgs;
  python3Packages.buildPythonApplication rec {
    pname = "mail-deduplicate";
    version = "6.2.0";

    src = python3Packages.fetchPypi {
      inherit pname version;
      sha256 = "eVP+4nDgSbc4InOO2ayEN9C+YOnyP+EN/SUAZQ3CgNQ=";
    };

    propagatedBuildInputs = with arrowpkgs.python3Packages; [
      click-help-colors
      tabulate
      arrow
      click-log
      boltons
      tomlkit
      pytest
    ];
  }
