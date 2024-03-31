{inputs, ...} :{
 imports = [
  inputs.nixos-hardware.nixosModules.apple-t2
 ]; 

 hardware.apple-t2.enableAppleSetOsLoader = true;
}