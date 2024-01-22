{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.evertras.home.shell.coding;
  languages = [ "go" "python" "rust" "nodejs" ];
in {
  options.evertras.home.shell.coding = let
    langOpt = n: {
      name = n;
      value = { enable = mkEnableOption n; };
    };
  in (builtins.listToAttrs (map langOpt languages));

  config = with pkgs; {
    home.packages = let
      pkgList = with lists;
        flatten [
          (optional cfg.python.enable python3)
          (optional cfg.rust.enable [ cargo rustc ])
          (optional cfg.nodejs.enable nodejs_21)
        ];
    in pkgList;

    programs.go = mkIf cfg.go.enable {
      enable = true;
      goPath = ".evertras/go";
      goBin = ".evertras/go/bin";
    };
  };
}
