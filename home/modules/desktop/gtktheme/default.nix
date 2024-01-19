{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.evertras.home.desktop.gtktheme;
  theme = config.evertras.themes.selected;
  cursorTheme = {
    name = if cfg.cursor.name == null then
      theme.cursorTheme.name
    else
      cfg.cursor.name;
    package = if cfg.cursor.package == null then
      theme.cursorTheme.package
    else
      cfg.cursor.package;
    size = cfg.cursor.size;
  };
  font = {
    # TODO: Cleaner null check, but 'or' doesn't work...
    name =
      if cfg.font.name == null then theme.fonts.desktop.name else cfg.font.name;
    package = cfg.font.package;
    size = cfg.font.size;
  };
in {
  options.evertras.home.desktop.gtktheme = {
    enable = mkEnableOption "gtktheme";

    cursor = {
      name = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      package = mkOption {
        type = with types; nullOr package;
        default = null;
      };

      size = mkOption {
        type = types.int;
        default = 32;
      };
    };

    iconTheme = {
      name = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      package = mkOption {
        type = with types; nullOr package;
        default = null;
      };
    };

    font = {
      name = mkOption {
        description = ''
          Override the selected Evertras theme font.
        '';
        type = with types; nullOr str;
        default = null;
      };

      package = mkOption {
        type = types.package;
        default = pkgs.nerdfonts;
      };

      size = mkOption {
        type = types.int;
        default = 12;
      };
    };

    overall = {
      name = mkOption {
        type = with types; nullOr str;
        default = null;
      };

      package = mkOption {
        type = with types; nullOr package;
        default = null;
      };
    };
  };

  config = mkIf cfg.enable {
    home.pointerCursor = cursorTheme // { x11.enable = true; };

    gtk = {
      enable = true;

      iconTheme = {
        name = if cfg.iconTheme.name == null then
          theme.iconTheme.name
        else
          cfg.iconTheme.name;
        package = if cfg.iconTheme.package == null then
          theme.iconTheme.package
        else
          cfg.iconTheme.package;
      };

      theme = {
        name = if cfg.overall.name == null then
          theme.gtkTheme.name
        else
          cfg.overall.name;
        package = if cfg.overall.package == null then
          theme.gtkTheme.package
        else
          cfg.overall.package;
      };

      inherit cursorTheme;

      inherit font;

      gtk3.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };

      gtk4.extraConfig = {
        Settings = ''
          gtk-application-prefer-dark-theme=1
        '';
      };
    };
  };
}
