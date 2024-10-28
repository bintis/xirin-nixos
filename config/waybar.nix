{
  pkgs,
  lib,
  host,
  config,
  ...
}:

let
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
  inherit (import ../hosts/${host}/variables.nix) clock24h;
in
with lib;
{
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [
      {
        layer = "top";
        position = "top";
        modules-center = [ "hyprland/workspaces" ];
        modules-left = [
          "custom/startmenu"
          "hyprland/window"
          "pulseaudio"
          "cpu"
          "memory"
          "idle_inhibitor"
        ];
        modules-right = [
          "custom/hyprbindings"
          "custom/notification"
          "custom/exit"
          "battery"
          "tray"
          "clock"
        ];

        "hyprland/workspaces" = {
          format = "{name}";
          format-icons = {
            default = " ";
            active = " ";
            urgent = " ";
          };
          on-scroll-up = "hyprctl dispatch workspace e+1";
          on-scroll-down = "hyprctl dispatch workspace e-1";
        };
        "clock" = {
          format = if clock24h == true then '' {:L%H:%M}'' else '' {:L%I:%M %p}'';
          tooltip = true;
          tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
        };
        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
          rewrite = {
            "" = " 🙈 No Windows? ";
          };
        };
        "memory" = {
          interval = 5;
          format = " {}%";
          tooltip = true;
        };
        "cpu" = {
          interval = 5;
          format = " {usage:2}%";
          tooltip = true;
        };
        "disk" = {
          format = " {free}";
          tooltip = true;
        };
        "network" = {
          format-icons = [
            "󰤯"
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
          format-ethernet = " {bandwidthDownOctets}";
          format-wifi = "{icon} {signalStrength}%";
          format-disconnected = "󰤮";
          tooltip = false;
        };
        "tray" = {
          spacing = 12;
        };
        "pulseaudio" = {
          format = "{icon} {volume}% {format_source}";
          format-bluetooth = "{volume}% {icon} {format_source}";
          format-bluetooth-muted = " {icon} {format_source}";
          format-muted = " {format_source}";
          format-source = " {volume}%";
          format-source-muted = "";
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
              ""
            ];
          };
          on-click = "sleep 0.1 && pavucontrol";
        };
        "custom/exit" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && wlogout";
        };
        "custom/startmenu" = {
          tooltip = false;
          format = "";
          on-click = "sleep 0.1 && rofi-launcher";
        };
        "custom/hyprbindings" = {
          tooltip = false;
          format = "󱕴";
          on-click = "sleep 0.1 && list-hypr-bindings";
        };
        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "";
            deactivated = "";
          };
          tooltip = "true";
        };
        "custom/notification" = {
          tooltip = false;
          format = "{icon} {}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "sleep 0.1 && task-waybar";
          escape = true;
        };
        "battery" = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = "󰂄 {capacity}%";
          format-plugged = "󱘖 {capacity}%";
          format-icons = [
            "󰁺"
            "󰁻"
            "󰁼"
            "󰁽"
            "󰁾"
            "󰁿"
            "󰂀"
            "󰂁"
            "󰂂"
            "󰁹"
          ];
          on-click = "";
          tooltip = false;
        };
      }
    ];
    style = concatStrings [
      ''
        * {
          font-family: "JetBrainsMono Nerd Font Mono", monospace;
          font-size: 14px;
          border-radius: 5px;  /* Reduced border-radius for a more subtle effect */
          border: none;
          min-height: 0px;
          background: #${config.stylix.base16Scheme.base02};  /* Taskbar matches button background for consistency */
          color: #ffffff;
        }
        window#waybar {
          background: #${config.stylix.base16Scheme.base02};  /* Matches the left button background color */
        }
        #workspaces {
          color: #${config.stylix.base16Scheme.base07};  /* Light color for text */
          background: #${config.stylix.base16Scheme.base02};  /* Unified color with the rest of the taskbar */
          margin: 4px 4px;
          padding: 4px 8px;
          border-radius: 5px;  /* Reduced rounded shape */
          box-shadow: none;  /* Removed shadow to make it less visually overwhelming */
        }
        #workspaces button {
          font-weight: bold;
          padding: 4px 8px;
          margin: 0px 4px;
          border-radius: 5px;  /* Reduced rounded rectangle for workspace buttons */
          color: #${config.stylix.base16Scheme.base00};
          background: #${config.stylix.base16Scheme.base03};  /* More consistent background */
          transition: ${betterTransition};
          box-shadow: none;  /* Removed shadow */
        }
        #workspaces button.active {
          font-weight: bold;
          color: #ffffff;
          background: #${config.stylix.base16Scheme.base08};  /* Highlight active workspace */
          border-radius: 5px;
          transition: ${betterTransition};
        }
        #window, #pulseaudio, #cpu, #memory, #idle_inhibitor, #custom-startmenu,
        #custom-hyprbindings, #network, #battery, #custom-notification, #tray, #custom-exit, #clock {
          font-weight: bold;
          margin: 4px 2px;
          padding: 6px 12px;
          background: #${config.stylix.base16Scheme.base02};  /* Matches the overall background for cohesion */
          color: #${config.stylix.base16Scheme.base07};
          border-radius: 5px;  /* Reduced rounded shape for all items */
          box-shadow: none;  /* Removed shadow */
        }
        tooltip {
          background: rgba(40, 40, 40, 0.9);  /* Darker background for tooltip */
          border: 1px solid #${config.stylix.base16Scheme.base08};
          border-radius: 5px;  /* Reduced rounded shape for tooltips */
          padding: 6px;
        }
        tooltip label {
          color: #${config.stylix.base16Scheme.base08};
        }
      ''
    ];
  };
}

