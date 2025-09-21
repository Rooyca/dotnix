{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    settings = {
      copy_command = "xclip -selection clipboard";
      theme = "dracula";
      themes.dracula = {
        fg = "#f8f8f2";
        bg = "#282a36";
        black = "#000000";
        red = "#ff5555";
        green = "#50fa7b";
        yellow = "#f1fa8c";
        blue = "#6272a4";
        magenta = "#ff79c6";
        cyan = "#8be9fd";
        white = "#ffffff";
        orange = "#ffb86c";
      };
    };
  };
}