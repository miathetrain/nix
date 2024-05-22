{pkgs, ...}: {
  users.users.mia = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
  };

  users.users.wyntor = {
    isNormalUser = true;
    shell = pkgs.fish;
    extraGroups = [
      "wheel"
      "video"
      "input"
    ];
  };
}
