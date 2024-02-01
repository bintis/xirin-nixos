{ pkgs, config, lib, waybarStyle, ... }:

lib.mkIf ("${waybarStyle}" == "style3") {
  # Configure & Theme Waybar
  programs.waybar = {
    enable = true;
    package = pkgs.waybar;
    settings = [{
      layer = "top";
      position = "top";

      modules-center = [ "hyprland/window" ];
      modules-left = ["custom/startmenu" "hyprland/workspaces"   "cpu"  "memory" "network"  ];
      modules-right = [ "idle_inhibitor" "custom/themeselector" "custom/notification" "pulseaudio" "clock"  "tray" ];
      "hyprland/workspaces" = {
      	format = "{icon}";
      	format-icons = {
          default = " ";
          active = " ";
          urgent = " ";
      	};
      	on-scroll-up = "hyprctl dispatch workspace e+1";
      	on-scroll-down = "hyprctl dispatch workspace e-1";
      };
      "clock" = {
        format = "{: %I:%M %p}";
      	tooltip = false;
      };
      "hyprland/window" = {
      	max-length = 25;
      	separate-outputs = false;
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
        format = "  {free}";
        tooltip = true;
      };
      "network" = {
        format-icons = ["󰤯" "󰤟" "󰤢" "󰤥" "󰤨"];
        format-ethernet = ": {bandwidthDownOctets}";
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
          default = ["" "" ""];
        };
        on-click = "pavucontrol";
      };
      "custom/themeselector" = {
        tooltip = false;
        format = "";
        # exec = "theme-selector";
        on-click = "theme-selector";
      };
      "custom/startmenu" = {
        tooltip = false;
        format = " ";
        # exec = "rofi -show drun";
        on-click = "rofi -show drun";
      };
      "idle_inhibitor" = {
        format = "{icon}";
        format-icons = {
            activated = " ";
            deactivated = " ";
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
        on-click = "task-waybar";
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
        format-icons = ["󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
        on-click = "";
        tooltip = false;
      };
    }];
    style = ''
	* {
		font-size: 16px;
		font-family: JetBrainsMono Nerd Font, Font Awesome, sans-serif;
    		font-weight: bold;
	}
	window#waybar {
		background: transparent;
    		border-bottom: 1px solid #${config.colorScheme.colors.base00};
    		border-radius: 0px;
		    color: #${config.colorScheme.colors.base0F};
	}
	#workspaces {
		    background: #${config.colorScheme.colors.base00};
    		margin: 4px;
                background: transparent;    	
	        padding: 0px 1px;
    		border-radius: 10px;
    		border: 0px;
    		font-style: normal;
    		color: #${config.colorScheme.colors.base00};
	}
	#workspaces button {
    		padding: 0px 5px;
    		margin: 4px 3px;
                background: transparent;    	
         	border-radius: 10px;
    		border: 0px;
    		color: #${config.colorScheme.colors.base00};
		    background: linear-gradient(45deg, #${config.colorScheme.colors.base05}, #${config.colorScheme.colors.base0E});
    		opacity: 0.5;
    		transition: all 0.3s ease-in-out;
	}
	#workspaces button.active {
    		color: #${config.colorScheme.colors.base00};
		    background: linear-gradient(45deg, #${config.colorScheme.colors.base05}, #${config.colorScheme.colors.base0E});
    		border-radius: 10px;
    		min-width: 40px;
    		transition: all 0.3s ease-in-out;
    		opacity: 1.0;
	}
	#workspaces button:hover {
    		color: #${config.colorScheme.colors.base00};
		    background: linear-gradient(45deg, #${config.colorScheme.colors.base05}, #${config.colorScheme.colors.base0E});
    		border-radius: 10px;
    		opacity: 0.8;
	}
	tooltip {
  		background: #${config.colorScheme.colors.base00};
  		border: 1px solid #${config.colorScheme.colors.base00};
  		border-radius: 10px;
	}
	tooltip label {
  		color: #${config.colorScheme.colors.base07};
	}
	#window {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
    		padding: 0px;
	}
	#memory {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#clock {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#idle_inhibitor {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#cpu {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#disk {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#battery {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#network {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#tray {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#pulseaudio {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#custom-notification {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
    #custom-themeselector {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
    }
	#custom-startmenu {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
	#idle_inhibitor {
    		color: #${config.colorScheme.colors.base05};
                background: transparent;   
    		border-radius: 10px;
    		margin: 4px;
                padding: 0px;
	}
    '';
  };
}

