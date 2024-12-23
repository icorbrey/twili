# Connects other running services to Tailscale.
#
# See: https://tailscale.com/kb/1236/kubernetes-operator
{ kubenix, ... }: {
  helm.chart = kubenix.lib.helm.fetch {
    repo = "https://pkgs.tailscale.com/helmcharts";
    chart = "tailscale-operator";
    version = "1.78.3";
    sha256 = "bf5fe6d7991de59e2a9ed30fb605e73af2d7057ba7f616938dd9bb83bb98f5b0";
  };
}
