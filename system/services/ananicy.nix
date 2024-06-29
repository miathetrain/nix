{pkgs, ...}: {
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
    rulesProvider = pkgs.ananicy-cpp-rules;
  };

  # systemd.services."user@".serviceConfig.Delegate = "memory pids cpu cpuset";
}
