{
  # Nix stuff
  inputs.haumea.url = "github:nix-community/haumea";
  inputs.haumea.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs";

  # Kubernetes configuration
  inputs.kubenix.url = "github:hall/kubenix";

  outputs = { haumea, kubenix, nixpkgs, ... }: let
    system = "x86_64-linux";
  in {
    nixosConfigurations.twili = nixpkgs.lib.nixosSystem {
      inherit system;

      modules = [
        ./hardware-configuration.nix
        {
          services.k3s.enable = true;
          services.k3s.role = "server";
      
          # Define pods to be automatically deployed to K3s within ./charts. These
          # definitions will be coalated into /etc/kubenix.yaml, which gets
          # symlinked to /var/lib/rancher/k3s/server/manifests/kubenix.yaml.
          #
          # See:
          # - https://docs.k3s.io/installation/packaged-components#auto-deploying-manifests-addons
          # - https://kubenix.org/tips-n-tricks/k3s/
          environment.etc."kubenix.yaml".source =
            (kubenix.evalModules.${builtins.currentSystem} {
              module = { kubenix, ... } @ moduleInputs: let
                services = haumea.lib.load {
                  inputs = moduleInputs;
                  src = ./services;
                };

                selectAttr = attr: builtins.mapAttrs (name: value: value.${attr});
              in {
                imports = with kubenix.modules; [ helm k8s ];
      
                kubenix.project = "twili";
                kubernetes.namespace = "twili";
                kubernetes.namespaces.${"twili"} = {};
  
                kubernetes.helm.releases = selectAttr "helm" services;            
                kubernetes.resources.pods = selectAttr "pod" services;
              };
            }).config.kubernetes.resultYAML;

          system.activationScripts.kubenix.text = ''
            ln -sf /etc/kubenix.yaml /var/lib/rancher/k3s/server/manifests/kubenix.yaml
          '';
        }
      ];
    };
  };
}
