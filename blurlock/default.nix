{pkgs, ...}:
pkgs.writeShellScriptBin "blurlock" ''
  #!/usr/bin/env bash
  TMPBG=/tmp/screen.png
  LOCK=${./lock.png}
  RES=$( ${pkgs.xorg.xdpyinfo}/bin/xdpyinfo | grep -oP 'dimensions:\s+\K\S+')
   
  ${pkgs.ffmpeg}/bin/ffmpeg -hide_banner -loglevel error -f x11grab -video_size $RES -y -i $DISPLAY -i $LOCK -filter_complex "boxblur=5:1,overlay=(main_w-overlay_w)/2:(main_h-overlay_h)/2" -vframes 1 $TMPBG
  ${pkgs.i3lock}/bin/i3lock -eui $TMPBG
''
