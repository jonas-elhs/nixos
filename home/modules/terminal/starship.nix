{ config, pkgs, lib, ... }: {
  options = {
    starship.enable = lib.mkEnableOption "Enables Starship";
    starship.style = lib.mkOption {
      type = lib.types.str; 
      default = "round-split";
      description = "The style of Starship";
    };
  };

  config = lib.mkIf config.starship.enable {
    programs.starship = {
      enable = true;
      enableFishIntegration = true;
     } // {
      round-split = {
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
            black = "#191D24";
            bright-black = "#242933";
            grey = "#3B4252";
            bright-grey = "#4C566A";
            white = "#D8DEE9";
            bright-white = "#E5E9F0";
            blue = "#81A1C1";
            bright-blue = "#88C0D0";
            cyan = "#8FBCBB";
            bright-cyan = "#93CCDC";
            red = "#BF616A";
            bright-red = "#D06F79";
            orange = "#D08770";
            bright-orange = "#D79784";
            yellow = "#EBCB8B";
            bright-yellow = "#F0D399";
            green = "#A3BE8C";
            bright-green = "#B1D196";
            purple = "#B48EAD";
            bright-purple = "#C895BF";
          };

          hostname = {
            format = lib.concatStrings [
              "[](fg:bright-orange)[](fg:bright-black bg:bright-orange)[](fg:bright-orange bg:grey)"
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
    }.${config.starship.style};
  };
}
