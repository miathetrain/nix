{
  inputs,
  pkgs,
  ...
}: let
  cpu-usage = pkgs.writeShellScriptBin "cpu-usage" ''
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

    # compute active and total utilizations
    cpu_active_prev=$((user+system+nice+softirq+steal))
    cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))

    usleep 50000

    # Read /proc/stat file (for second datapoint)
    read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

    # compute active and total utilizations
    cpu_active_cur=$((user+system+nice+softirq+steal))
    cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))

    # compute CPU utilization (%)
    cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))

    printf " Current CPU Utilization : %s\n" "$cpu_util"

    exit 0
  '';
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    toybox ##usleep
    inputs.self.packages.${pkgs.system}.ags-wrap
    cpu-usage
  ];

  programs.ags = {
    enable = true;
  };

  services.xembed-sni-proxy.enable = true;

  systemd.user.services = {
    ags = {
      Unit = {
        Description = "ags service";
      };

      Install.WantedBy = ["hyprland-session.target"];

      Service = {
        ExecStart = ''${inputs.self.packages.${pkgs.system}.ags-wrap}/bin/ags-wrap'';
      };
    };
  };
}
