{
  description = "My devshells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    nixvim.url = "github:nix-community/nixvim";
  };

  outputs = { self, nixpkgs, fenix, nixvim }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    fenixPkgs = fenix.packages.${system}.latest;
    nixvimConfig = nixvim.legacyPackages.${system}.makeNixvim ./devenv/nixvim;
    zshDevShell = { packages }: pkgs.mkShell {
      inherit packages;
      shellHook = ''
        export SHELL=${pkgs.zsh}/bin/zsh
        exec ${pkgs.zsh}/bin/zsh
      '';
    };
  in
  {
    devShells.${system} = {
      rust = zshDevShell {
        packages = [
          nixvimConfig
          fenixPkgs.rustc
          fenixPkgs.cargo
          fenixPkgs.rustfmt
          fenixPkgs.clippy
          fenixPkgs.rust-analyzer
        ];
      };
    };
  };
}
