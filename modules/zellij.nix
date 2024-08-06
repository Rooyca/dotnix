{ pkgs, ... }: {
  programs.zellij = {
    enable = true;
    settings = {
      copy_command = "xclip -selection clipboard";
    };
  };
}