# Stream your media to any device.
# 
# See: https://github.com/jellyfin/jellyfin-helm/blob/8744e4c892dac20e611427da27c7dc82568d6e4c/charts/jellyfin/README.md
{ kubenix, ... }: {
  helm.chart = kubenix.lib.helm.fetch {
    repo = "https://jellyfin.github.io/jellyfin-helm/index.yaml";
    chart = "jellyfin";
    version = "10.10.1";
    sha256 = "1211a2e0f0a36d7c98ef0e26ebc741cbdf8fcc5461cf30352662759662b0230a";
  };
}
