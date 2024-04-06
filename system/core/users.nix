{pkgs, ...}: {
  users.users.mia = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "corectrl"
      "adbusers"
      "i2c"
    ];
  };
}
