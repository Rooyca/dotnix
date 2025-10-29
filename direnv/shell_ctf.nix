# ~/Documents/learning/ctf/shell.nix
{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "ctf-env";
  
  buildInputs = with pkgs; [
    # Disassemblers / Reverse Engineering
    radare2
    
    # Python + Exploit Dev
    python3Packages.pwntools
    frida-tools
    #python3Packages.pycryptodome
    #python3Packages.ropgadget
    
    # Binary Analysis
    strace
    ltrace
    
    # Network tools
    netcat
    socat
    nmap
    zmap
    dirb

    # Others
    sqlmap
    thc-hydra
    nuclei
    gobuster
  ];
  
  shellHook = ''
    echo "🚩 CTF Environment loaded"
  '';
}
