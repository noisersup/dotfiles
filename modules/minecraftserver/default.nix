{ config, pkgs, ... }:
{
  services.minecraft-server = {
    enable = true;
    jvmOpts = "-Xmx1024M -Xms1024M";
    eula = true;
    serverProperties = {
      server-port = 43000;
      difficulty = 3;
      gamemode = 1;
      max-players = 5;
      motd = "NixOS Minecraft server!";
      white-list = false;
      enable-rcon = true;
      "rcon.password" = "hunter2";
    };
    declarative = true;
    openFirewall = true;
  };
}
