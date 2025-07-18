{ config, pkgs, lib, ... }: let
  cfg = config.walker;
  colors = config.theme.colors;
  layout = config.theme.layout;
in {
  options.walker = {
    enable = lib.mkEnableOption "walker";
    style = lib.mkOption {
      type = lib.types.str;
      default = "default";
      description = "The style of Walker";
    };
    service = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Wheter to run Walker as a service";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.walker = {
      enable = true;
      runAsService = cfg.service;
    } // {
      default = let
        foreground = colors.foreground.base;
        background = colors.background.base;
        accent = colors.accent;
        highlight = colors.foreground.dark;
      in {
        config = {
          app_launch_prefix = "uwsm app -- ";

          keys = {
            next = ["ctrl j"];
            prev = ["ctrl k"];
            close = ["esc"];
            activation_modifiers = {
              keep_open = "shift";
              alternate = "alt";
            };
          };

          list = {
            show_initial_entries = true;
              #max_entries = 10;
            visibility_threshold = 10;
            placeholder = "";
          };

          activation_mode = {
            disabled = true;
          };

          builtins = {
            applications = {
              placeholder = "";
              prioritize_new = false;
              history = false;
              actions = {
                enabled = false;
              };
            };
          };

          plugins = [
            {
              name = "themes";
              src_once = "list-themes | sed 's/-/ /g' | sed 's/\\b./\\u&/g'";
              cmd = "switch-theme $(echo %RESULT% | sed 's/ /-/g' | sed 's/\\b./\\l&/g')";
            }
            {
              name = "wallpapers";
              src_once = "walker-list-wallpapers";
              switcher_only = true;
              parser = "kv";
            }
          ];
        };

        theme = {
          layout = {
            ui = {
              anchors = {
                bottom = true;
                left = true;
                right = true;
                top = true;
              };

              window = {
                h_align = "fill";
                v_align = "fill";
              };

              window = {
                box = {
                  h_align = "center";
                  width = 450;
                  margins = {
                    top = 200;
                  };


                  bar = {
                    orientation = "horizontal";
                    position = "end";
                    entry = {
                      h_align = "fill";
                      h_expand = true;
                      icon = {
                        h_align = "center";
                        h_expand = true;
                        pixel_size = 24;
                        theme = "";
                      };
                    };
                  };

                  scroll = {
                    h_scrollbar_policy = "external";
                    v_scrollbar_policy = "never";
                    list = {
                      marker_color = accent;
                      always_show = false;
                      min_height = 0;
                      max_height = 400;
                      max_width = 0;
                      min_width = 0;
                      margins = {
                        top = layout.gap.size;
                      };

                      item = {
                        icon = {
                          pixel_size = 26;
                          theme = "";
                          margins = {
                            end = 10;
                          };
                        };
                        text = {
                          sub = {
                            hide = true;
                          };
                        };
                      };
                    };
                  };

                  search = {
                    input = {
                      h_align = "fill";
                      h_expand = true;
                    };
                    prompt = {
                      hide = true;
                    };
                    clear = {
                      hide = true;
                    };
                    spinner = {
                      hide = true;
                    };
                  };
                };
              };
            };
          };
          style = ''
            #window,
            #box,
            #search,
            #input,
            #typeahead,
            #list,
            child,
            #item,
            #text,
            #label,
            #bar {
              all: unset;
            }

            #window {
              color: ${foreground};
            }

            #box {
              border-radius: ${layout.border.radius.size}px;
              background: ${background}${layout.background.opacity_hex};
              padding: ${layout.gap.size}px;
              border: ${layout.border.width}px solid ${accent};
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
            }

            #search {
              padding: ${layout.gap.inner}px;
              border-radius: ${layout.border.radius.inner}px;
              border: ${layout.border.width}px solid ${accent};
              box-shadow: none;
            }

            child {
              padding: ${layout.gap.inner}px;
              border-radius: ${layout.border.radius.inner}px;
            }
            child:selected,
            child:hover {
              background: ${highlight}${layout.background.opacity_hex};
            }
          '';
        };
      };
    }.${cfg.style};
  };
}
