{
  fileSystems."/games/storage/nvme (1tb)" = {
    device = "/dev/disk/by-uuid/45814757-825b-4581-8786-ab3df2c4ffcb";
    fsType = "ext4";
    options = ["defaults" "nofail"];
  };

  fileSystems."/games/storage/ssd (1tb)" = {
    device = "/dev/disk/by-uuid/e6cc8647-cbe4-48e6-bdce-10b09d7b4bc5";
    fsType = "ext4";
    options = ["defaults" "nofail"];
  };

  #fileSystems."/games/storage/hhd (2tb)" = {
  #  device = "/dev/disk/by-uuid/677200ef-a0af-47a3-bee6-9ffe5706d227";
  #  fsType = "ext4";
  #};
}
