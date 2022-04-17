{ config, pkgs, ... }:
let
  picom = pkgs.stdenv.mkDerivation rec {
    name = "picom";

    withDebug = false;

    src = pkgs.fetchFromGitHub {
      owner = "yshui";
      repo = "picom";
      rev = "e3c19cd7d1108d114552267f302548c113278d45";
      sha256 = "4voCAYd0fzJHQjJo4x3RoWz5l3JJbRvgIXn1Kg6nz6Y=";
      fetchSubmodules = true;
    };

    nativeBuildInputs = [
      pkgs.asciidoc
      pkgs.docbook_xml_dtd_45
      pkgs.docbook_xsl
      pkgs.makeWrapper
      pkgs.meson
      pkgs.ninja
      pkgs.pkg-config
      pkgs.uthash
    ];

    buildInputs = with pkgs;[
      dbus
      libconfig
      libdrm
      libev
      libGL
      xorg.libX11
      xorg.libxcb
      libxdg_basedir
      xorg.libXext
      xorg.libXinerama
      libxml2
      libxslt
      pcre
      pixman
      xorg.xcbutilimage
      xorg.xcbutilrenderutil
      xorg.xorgproto
    ];

    # Use "debugoptimized" instead of "debug" so perhaps picom works better in
    # normal usage too, not just temporary debugging.
    mesonBuildType = if withDebug then "debugoptimized" else "release";
    dontStrip = withDebug;

    mesonFlags = [
      "-Dwith_docs=true"
    ];

    installFlags = [ "PREFIX=$(out)" ];

    # In debug mode, also copy src directory to store. If you then run `gdb picom`
    # in the bin directory of picom store path, gdb finds the source files.
    postInstall = ''
      wrapProgram $out/bin/picom-trans \
        --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.xorg.xwininfo ]}
    '' + pkgs.lib.optionalString withDebug ''
      cp -r ../src $out/
    '';

    meta = with pkgs.lib; {
      description = "A fork of XCompMgr, a sample compositing manager for X servers";
      longDescription = ''
        A fork of XCompMgr, which is a sample compositing manager for X
        servers supporting the XFIXES, DAMAGE, RENDER, and COMPOSITE
        extensions. It enables basic eye-candy effects. This fork adds
        additional features, such as additional effects, and a fork at a
        well-defined and proper place.
        The package can be installed in debug mode as:
          picom.override { withDebug = true; }
        For gdb to find the source files, you need to run gdb in the bin directory
        of picom package in the nix store.
      '';
      license = licenses.mit;
      homepage = "https://github.com/yshui/picom";
      maintainers = with maintainers; [ ertes twey thiagokokada ];
      platforms = platforms.linux;
    };
  };
in
{
  environment.systemPackages = [ picom ];
}
