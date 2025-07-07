{ config, pkgs, ... }: {
  home.groups = [ "wheel" "input" ];
  home.fonts = with pkgs; [
    maple-nerd-font-mono
    maple-nerd-font-propo
  ];

  theme = {
    color = {
      name = "nordic";
      themes = "all";
    };
    layout = {
      border = {
        width = "2";
        radius = {
          size = "10";
          inner = "7";
        };
      };
      font = {
        name = "MapleMono Nerd Font Propo";
        mono = "MapleMono Nerd Font Mono";
        sub = "10";
        size = "12";
        title = "18";
      };
      background = {
        opacity = 0.5;
        opacity_hex = "80";
      };
      gap = {
        size = "20";
        inner = "10";
      };
      blur = {
        size = "3";
        passes = "4";
      };
    };
  };

  hyprland = {
    enable = true;
    persistentWorkspaces = 5;
    vertical = true;
  };
  hyprlock = {
    enable = true;
    dm = true;
  };
  hypridle.enable = true;
  hyprpaper = {
    enable = true;
    wallpaper = "/home/ilzayn/wallpapers/moonlight.png";
  };
  waybar = {
    enable = true;
    gpu_hwmon = 5;
    style = "vertical";
  };
  kitty.enable = true;
  starship.enable = true;
  fish.enable = true;
  git = {
    enable = true;
    name = "jonas-elhs";
    email = "jonas.elhs@outlook.com";
  };
  fastfetch.enable = true;
  walker.enable = true;
  neovim.enable = true;
  mako.enable = true;
  zen.enable = true;
}
