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

    printf "%s" "$cpu_util"

    exit 0
  '';

  memory-usage = pkgs.writeShellScriptBin "memory-usage" ''
    mem_total=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
    mem_ava=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
    mem_util=$(echo "$mem_total $mem_ava" | awk '{print ($1 - $2) / $1}')

    printf "%s" "$mem_util"

    exit 0
  '';

  memory-free = pkgs.writeShellScriptBin "memory-free" ''
    mem_total=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
    mem_ava=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
    mem_util=$(echo "$mem_total $mem_ava" | awk '{print ($1 - $2)}')

    printf "%s" "$mem_util"

    exit 0
  '';

  gpu-usage = pkgs.writeShellScriptBin "gpu-usage" ''
    usage=$(amdgpu_top -n 1 --json | jq -c -r "(.devices[] | .gpu_activity | .GFX | .value )")

    printf "%s" "$usage"

    exit 0
  '';

  gpu-memory = pkgs.writeShellScriptBin "gpu-memory" ''
    usage=$(amdgpu_top -n 1 --json | jq -c -r "(.devices[] | .gpu_activity | .Memory | .value )")

    printf "%s" "$usage"

    exit 0
  '';
in {
  imports = [
    inputs.ags.homeManagerModules.default
  ];

  home.packages = with pkgs; [
    toybox
    busybox ##usleep
    ags-wrap
    cpu-usage
    memory-usage
    memory-free
    gpu-usage
    gpu-memory
    amdgpu_top
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
        ExecStart = ''${pkgs.ags-wrap}/bin/ags-wrap'';
      };
    };
  };
}
