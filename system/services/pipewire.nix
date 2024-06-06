{
  lib,
  pkgs,
  ...
}: {
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    #alsa.support32Bit = true;
    # jack.enable = true;
    pulse.enable = true;
  };

  # services.pipewire = {
  #   wireplumber.configPackages = [
  #     (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
  #       bluez_monitor.properties = {
  #       	["bluez5.enable-sbc-xq"] = true,
  #       	["bluez5.enable-msbc"] = true,
  #       	["bluez5.enable-hw-volume"] = true,
  #       	["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
  #       }
  #     '')
  #   ];

  #   extraConfig = {
  #     pipewire."92-low-latency" = {
  #       context.properties = {
  #         default.clock.rate = 48000;
  #         default.clock.quantum = 32;
  #         default.clock.min-quantum = 32;
  #         default.clock.max-quantum = 32;
  #       };
  #     };

  #     pipewire-pulse."92-low-latency" = {
  #       context.modules = [
  #         {
  #           name = "libpipewire-module-protocol-pulse";
  #           args = {
  #             pulse.min.req = "32/48000";
  #             pulse.default.req = "32/48000";
  #             pulse.max.req = "32/48000";
  #             pulse.min.quantum = "32/48000";
  #             pulse.max.quantum = "32/48000";
  #           };
  #         }
  #       ];
  #       stream.properties = {
  #         node.latency = "32/48000";
  #         resample.quality = 1;
  #       };
  #     };

  #     pipewire-pulse."20-switch-on-connect" = {
  #       context.exec = [
  #         {
  #           path = "pactl";
  #           args = "load-module module-switch-on-connect";
  #         }
  #       ];
  #     };
  #   };
  # };

  # hardware.pulseaudio.enable = lib.mkForce false;
}
