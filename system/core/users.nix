{pkgs, ...}: {
  users.users.mia = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "input"
      "i2c"
    ];
  };
}
