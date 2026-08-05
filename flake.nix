{
  description = "A reproducible Neovim configuration environment that satisfies :checkhealth";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs { inherit system; };

        # System dependencies required for Neovim's checkhealth and plugin runtimes
        runtimeDeps = with pkgs; [
          # Core utilities & compilers
          git
          gnumake
          unzip
          wget
          curl
          tree-sitter
          gcc

          # Telescope requirements
          ripgrep
          fd

          # Language runtimes and providers
          nodejs_20
          go
          (python3.withPackages (ps: with ps; [ pynvim ]))

          # Clipboard integration
          xclip
          wl-clipboard
        ];

        # A wrapped Neovim binary with dependencies prepended to its PATH
        wrappedNeovim = pkgs.symlinkJoin {
          name = "neovim-wrapped";
          paths = [ pkgs.neovim ];
          buildInputs = [ pkgs.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/nvim \
              --prefix PATH : ${pkgs.lib.makeBinPath runtimeDeps}
          '';
        };
      in
      {
        packages.default = wrappedNeovim;
        
        apps.default = {
          type = "app";
          program = "${wrappedNeovim}/bin/nvim";
        };

        # Development shell providing the exact same environment
        devShells.default = pkgs.mkShell {
          buildInputs = [ wrappedNeovim ] ++ runtimeDeps;
        };
      }
    );
}
