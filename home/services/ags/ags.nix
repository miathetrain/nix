{
  stdenv,
  inputs,
  writeShellScript,
  system,
  esbuild,
  dart-sass,
  ...
}: let
  name = "ags-wrap";

  ags = inputs.ags.packages.${system}.default;

  dependencies = [
    dart-sass
    pinfo
  ];

  addBins = list: builtins.concatStringsSep ":" (builtins.map (p: "${p}/bin") list);

  desktop = writeShellScript name ''
    export PATH=$PATH:${addBins dependencies}
    ${ags}/bin/ags -c ${config}/config.js $@
  '';

  config = stdenv.mkDerivation {
    inherit name;
    src = ./config;

    buildPhase = ''
      ${esbuild}/bin/esbuild \
        --bundle ./main.ts \
        --outfile=main.js \
        --format=esm \
        --external:resource://\* \
        --external:gi://\* \
    '';

    installPhase = ''
      mkdir -p $out
      cp -r assets $out
      cp -r css $out
      cp -f main.js $out/config.js
    '';
  };

  pinfo = pkgs.writeShellScriptBin "pinfo" ''
    if [ $1 == "cpu" ]; then
      read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

      # compute active and total utilizations
      cpu_active_prev=$((user+system+nice+softirq+steal))
      cpu_total_prev=$((user+system+nice+softirq+steal+idle+iowait))

      ${pkgs.toybox}/bin/usleep 50000

      # Read /proc/stat file (for second datapoint)
      read cpu user nice system idle iowait irq softirq steal guest< /proc/stat

      # compute active and total utilizations
      cpu_active_cur=$((user+system+nice+softirq+steal))
      cpu_total_cur=$((user+system+nice+softirq+steal+idle+iowait))

      # compute CPU utilization (%)
      cpu_util=$((100*( cpu_active_cur-cpu_active_prev ) / (cpu_total_cur-cpu_total_prev) ))

      printf "%s" "$cpu_util"

    elif [ $1 == "memory" ]; then
      mem_total=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
      mem_ava=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
      mem_util=$(echo "$mem_total $mem_ava" | awk '{print ($1 - $2) / $1}')

      printf "%s" "$mem_util"

    elif [ $1 == "freememory" ]; then
      mem_total=$(awk '/MemTotal/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
      mem_ava=$(awk '/MemAvailable/ { printf "%.3f \n", $2/1024/1024 }' /proc/meminfo)
      mem_util=$(echo "$mem_total $mem_ava" | awk '{print ($1 - $2)}')

      printf "%s" "$mem_util"

    elif [ $1 == "gpu" ]; then
      s=$(${pkgs.amdgpu_top}/bin/amdgpu_top -n 1 --json | jq -c -r '(.devices[] | .gpu_activity | .GFX | .value )')
      echo $s

    elif [ $1 == "gpumemory" ]; then
      s=$(${pkgs.amdgpu_top}/bin/amdgpu_top -n 1 --json | jq -c -r '(.devices[] | .gpu_activity | .Memory | .value )')
      echo $s

    fi
  '';
in
  stdenv.mkDerivation {
    inherit name;
    src = config;

    installPhase = ''
      mkdir -p $out/bin
      cp -r . $out
      cp ${desktop} $out/bin/${name}
    '';
  }
