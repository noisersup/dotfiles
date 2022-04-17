{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ minikube kubernetes-helm jq ];
}
