with import <nixpkgs> {};
  writeShellScriptBin "pinfo" ''
    if [ $1 == "cpu" ]; then
       echo "CPU"
       fi
  ''
