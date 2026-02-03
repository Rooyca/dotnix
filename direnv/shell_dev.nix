{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "dev-env";
  
  buildInputs = with pkgs; [
    # Rust
    cargo

    # Nodejs
    nodejs_20
    # nodePackages.npm
    # nodePackages.typescript
    # nodePackages.typescript-language-server
    
    # C 
    gcc
    clang
    cmake
    gnumake
    gdb
    #valgrind
    
    # Python
    python3
    python3Packages.pip
    python3Packages.requests
    python3Packages.web3
    python3Packages.flask
    python3Packages.flask-cors
    python3Packages.pysocks
    #python312Packages.pdfplumber
    #python3Packages.python-lsp-server  

    # Others
    sqlitebrowser
    foundry
    hugo
  ];
  
  shellHook = ''
    echo "=== 💻 Development Environment loaded ==="
    echo "Node: $(node --version)"
    echo "Python: $(python --version)"
    echo "GCC: $(gcc --version | head -n1)"
    echo "========================================="
    
    # Optional: maybe i find some usecase in the future
    #if [ -f "package.json" ]; then
    #  echo "📦 Found package.json - run 'npm install' if needed"
    #fi
  '';
}
