{
  description = "My devshells";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    fenix.url = "github:nix-community/fenix";
    devshell.url = "github:numtide/devshell";
  };

  outputs = { self, nixpkgs, fenix, devshell }:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs { inherit system; };
    fenixPkgs = fenix.packages.${system}.latest;
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
