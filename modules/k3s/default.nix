{config,pkgs,...}:
{
  services.k3s.enable = true;
  services.k3s.role = "server";
  environment.systemPackages = [pkgs.k3s];

  # ZFS support:
  virtualisation.containerd.enable = true;
  services.k3s.extraFlags = toString [
    "--container-runtime-endpoint unix:///run/containerd/containerd.sock"
  ];
}
