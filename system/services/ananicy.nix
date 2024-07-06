{pkgs, ...}: {
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-rules-cachyos;
  };

  # systemd.services."user@".serviceConfig.Delegate = "memory pids cpu cpuset";
}
