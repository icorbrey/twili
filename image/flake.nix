{
  description = "Custom installation media for Twili";

  # Nix stuff
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";

  # Hardware configuration tools
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";

  outputs = { disko, nixpkgs, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";

      modules = [
        disko.nixosModules.disko
        {
          imports = [
            <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-graphical-gnome.nix>
            <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
          ];

          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAII+dxJbJs2LiS7QAFFtJsFPsntqru8c/7V/3S+DP8H+m icorbrey@gmail.com"
          ];
        }
      ];
    };
  };
}
