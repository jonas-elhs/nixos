{ config, pkgs, lib, ... }: let
  cfg = config.starship;
in {
  options = {
    starship.enable = lib.mkEnableOption "Starship Prompt";
    starship.style = lib.mkOption {
      type = lib.types.str; 
      default = "default";
      description = "The style of Starship Prompt";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
     } // {
      default = {
        settings = {
          palette = "nordic";
          format = lib.concatStrings [
            "($hostname  )$username  \${custom.folder_symbol}$directory"
            "$fill"
            "$git_branch $git_status"
            "$line_break $character"
          ];
          right_format = "$cmd_duration";
          continuation_prompt = "[┃]()";

          palettes.nordic = {
            black = config.theme.base00;
            bright-black = config.theme.base08;
               grey = "#3B4252";
##             bright-grey = "#4C566A";
            red = config.theme.base01;
            bright-red = config.theme.base09;
            green = config.theme.base02;
            bright-green = config.theme.base0A;
            yellow = config.theme.base03;
            bright-yellow = config.theme.base0B;
            blue = config.theme.base04;
            bright-blue = config.theme.base0C;
            purple = config.theme.base05;
            bright-purple = config.theme.base0D;
            cyan = config.theme.base06;
            bright-cyan = config.theme.base0E;
            white = config.theme.base07;
            bright-white = config.theme.base0F;
          };

          hostname = {
            format = lib.concatStrings [
              "[](fg:bright-red)[](fg:bright-black bg:bright-red)[](fg:bright-red bg:grey)"
              "[ $hostname ]($style)[](fg:grey)"
            ];
            style = "fg:white bg:grey";
          };

          username = {
            format = lib.concatStrings [
              "[](fg:yellow)[](fg:bright-black bg:yellow)[](fg:yellow bg:grey)"
              "[ $user ]($style)[](fg:grey)"
            ];
            style_root = "fg:white bg:grey";
            style_user = "fg:white bg:grey";
            show_always = true;
          };

          custom.folder_symbol = {
            command = ''git rev-parse --is-inside-work-tree &>/dev/null && echo "󰊢" || echo ""'';
            format = "[](fg:green)[$output]($style)[](fg:green bg:grey)";
            style = "fg:bright-black bg:green";
            when = true;
          };

          directory = {
            format = "[ $path ($read_only )]($style)[](fg:grey)";
            style = "fg:white bg:grey";
            read_only = "󰌾";
            truncation_symbol = "…/";
          };

          fill = {
            symbol = " ";
          };

          git_branch = {
            format = lib.concatStrings [
              "([](fg:blue)[](fg:bright-black bg:blue)[](fg:blue bg:grey)"
              "[ $branch(:$remote_branch) ]($style)[](fg:grey))"
            ];
            style = "fg:white bg:grey";
          };

          git_status = {
            format = lib.concatStrings [
              "([](fg:purple)[](fg:bright-black bg:purple)[](fg:purple bg:grey)"
              "[( $staged)( $untracked)( $deleted)( $modified)( $renamed)( $stashed)"
              "( $conflicted)( $diverged)( $ahead)( $behind) ]($style)[](fg:grey))"
            ];
            style = "fg:white bg:grey";
            staged = "";
            untracked = "";
            deleted = "";
            modified = "";
            renamed = "";
            stashed = "";
            conflicted = "";
            diverged = "⇕";
            ahead = "⇡";
            behind = "⇣";
          };

          cmd_duration = {
            format = "[$duration]($style)";
            style = "fg:bright-grey";
          };

          character = {
            success_symbol = "[➜](fg:white)";
            error_symbol = "[➜](fg:white)";
            vimcmd_symbol = "[➜](fg:blue)";
            vimcmd_replace_symbol = "[➜](fg:orange)";
            vimcmd_replace_one_symbol = "[➜](fg:red)";
            vimcmd_visual_symbol = "[➜](fg:green)";
          };
        };
      };
    }.${cfg.style};
  };
}
