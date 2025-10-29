{ config, lib, pkgs, ... }:

{
  services.dunst = {
    enable = true;
    settings = {
      global = {
        width = 250;
        height = 250;
        origin = "bottom-right";
        transparency = 10;
        font = "Monospace 8";
        corner_radius = 7;
        progress_bar = true;
        icon_position = "left";
        max_icon_size = 58;
        frame_width = 1;
      };
      
      urgency_low = {
        background = "#37474f";
        foreground = "#eceff1";
        timeout = 5;
      };
      
      urgency_normal = {
        background = "#14121c";
        foreground = "#ffffff";
        timeout = 10;
      };
      
      urgency_critical = {
        background = "#b71c1c";
        foreground = "#eceff1";
        timeout = 0;
      };
    };
  };
}
