{ config, pkgs, lib, ... }: let
  cfg = config.neovim;
  colors = config.theme.colors;
  layout = config.layout;
in {
  options.neovim = {
    enable = lib.mkEnableOption "Neovim";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Neovim";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nvf = {
      enable = true;
    } // {
      default = {
        settings = {
          vim = {
            lineNumberMode = "relative";
            searchCase = "smart";

            options = {
              tabstop = 2;
              shiftwidth = 0;
              softtabstop = 2;
              wrap = false;
              linebreak = false;
              scrolloff = 999;
              sidescrolloff = 8;
              hlsearch = false;
              incsearch = true;
              clipboard = "unnamedplus";
              virtualedit = "block";
              laststatus = 3;
              shortmess = "WltToOCF";
              updatetime = 100;
#              fillchars.eob = " ";
            };

            globals = {};

            # Language Support
            languages = {
              enableTreesitter = true;

              nix.enable = true;
            };
            lsp = {
              enable = true;
            };

            # Plugins
            telescope = {
              enable = true;
              mappings = {
                findFiles = "<leader>sf";
                liveGrep = "<leader>ss";
#               gitFiles = "<leader>sg";
#                grepString = "<leader>sc";
                buffers = "<leader>sb";
                resume = "<leader>sr";
              };
              setupOpts = {
                defaults = {
                  path_display = [ "smart" ];
                };
              };
            };
#            leap = {};
            utility.oil-nvim = {
              enable = true;
              setupOpts = {
                default_file_explorer = true;
                skip_confirm_for_simple_edits = true;
                view_options = {
                  show_hidden = true;
                  natural_order = true;
                };
                win_options = {
                  wrap = true;
                  winblend = 0;
                };
                keymaps = {
                  "<C-c>" = false;
                  "q" = "actions.close";
                };
              };
            };

            # Keymaps
            keymaps = [
              {
                key = " ";
                action = "<NOP>";
                mode = "n";
                silent = true;
              }
              {
                key = " ";
                action = "<NOP>";
                mode = "v";
                silent = true;
              }
              {
                key = "x";
                action = "\"_x";
                mode = "n";
                silent = true;
              }
              {
                key = "p";
                action = "\"_dp";
                mode = "v";
                silent = true;
              }
              {
                key = "U";
                action = "<C-r>";
                mode = "n";
                silent = true;
              }

              # Splits
              {
                key = "<leader>sh";
                action = "<CMD>wincmd v | wincmd h<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>sj";
                action = "<CMD>wincmd s<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>sk";
                action = "<CMD>wincmd s | wincmd h<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>sl";
                action = "<CMD>wincmd v<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>sx";
                action = "<CMD>close<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<C-h>";
                action = "<CMD>wincmd h<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<C-j>";
                action = "<CMD>wincmd j<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<C-k>";
                action = "<CMD>wincmd k<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<C-l>";
                action = "<CMD>wincmd l<CR>";
                mode = "n";
                silent = true;
              }
              # Buffers
              {
                key = "<leader>bn";
                action = "<CMD>bnext<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>bp";
                action = "<CMD>bprevious<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>bx";
                action = "<CMD>bdelete<CR>";
                mode = "n";
                silent = true;
              }
              {
                key = "<leader>bX";
                action = "<CMD>bnext<CR>";
                mode = "n";
                silent = true;
              }
            ];
          };
        };
      };
    }.${cfg.style};
  };
}
