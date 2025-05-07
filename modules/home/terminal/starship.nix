{ config, pkgs, lib, ... }: let
  cfg = config.starship;
in {
  options.starship = {
    enable = lib.mkEnableOption "Starship Prompt";
    style = lib.mkOption {
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
            hostname = config.theme.colors.starship."0";
            username = config.theme.colors.starship."1";
            directory = config.theme.colors.starship."2";
            git_branch = config.theme.colors.starship."3";
            git_status = config.theme.colors.starship."4";

            icon = config.theme.colors.background;
            background = config.theme.colors.light_background;
            foreground = config.theme.colors.foreground;
            cmd_duration = config.theme.colors.dark_foreground;
          };

          hostname = {
            format = lib.concatStrings [
              "[](fg:hostname)[](fg:icon bg:hostname)[](fg:hostname bg:background)"
              "[ $hostname ]($style)[](fg:background)"
            ];
            style = "fg:foreground bg:background";
          };

          username = {
            format = lib.concatStrings [
              "[](fg:username)[](fg:icon bg:username)[](fg:username bg:background)"
              "[ $user ]($style)[](fg:background)"
            ];
            style_root = "fg:foreground bg:background";
            style_user = "fg:foreground bg:background";
            show_always = true;
          };

          custom.folder_symbol = {
            command = ''git rev-parse --is-inside-work-tree &>/dev/null && echo "󰊢" || echo ""'';
            format = "[](fg:directory)[$output]($style)[](fg:directory bg:background)";
            style = "fg:icon bg:directory";
            when = true;
          };

          directory = {
            format = "[ $path ($read_only )]($style)[](fg:background)";
            style = "fg:foreground bg:background";
            read_only = "󰌾";
            truncation_symbol = "…/";
          };

          fill = {
            symbol = " ";
          };

          git_branch = {
            format = lib.concatStrings [
              "([](fg:git_branch)[](fg:icon bg:git_branch)[](fg:git_branch bg:background)"
              "[ $branch(:$remote_branch) ]($style)[](fg:background))"
            ];
            style = "fg:foreground bg:background";
          };

          git_status = {
            format = lib.concatStrings [
              "([](fg:git_status)[](fg:icon bg:git_status)[](fg:git_status bg:background)"
              "[( $staged)( $untracked)( $deleted)( $modified)( $renamed)( $stashed)"
              "( $conflicted)( $diverged)( $ahead)( $behind) ]($style)[](fg:background))"
            ];
            style = "fg:foreground bg:background";
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
            style = "fg:cmd-duration";
          };

          character = {
            success_symbol = "[➜](fg:foreground)";
            error_symbol = "[➜](fg:foreground)";
            vimcmd_symbol = "[➜](fg:foreground)";
            vimcmd_replace_symbol = "[➜](fg:foreground)";
            vimcmd_replace_one_symbol = "[➜](fg:foreground)";
            vimcmd_visual_symbol = "[➜](fg:foreground)";
          };
        };
      };
    }.${cfg.style};
  };
}
