inputs: {
  additions = final: prev: {
    zig-overlay = import ./zig-overlay {pkgs = final;};
    hyprland-dev = inputs.hyprland.packages.${final.system}.hyprland;
  };

  modifications = final: prev: {
    mpv = prev.mpv.override {
      scripts = [ final.mpvScripts.mpris ];
    };

    discord = prev.discord.override {
      withOpenASAR = true;
      withVencord = true;
    };

    vivaldi-ffmpeg-codecs = prev.vivaldi-ffmpeg-codecs.overrideAttrs rec {
      version = "111306";
      src = final.fetchurl {
        url = "https://api.snapcraft.io/api/v1/snaps/download/XXzVIXswXKHqlUATPqGCj2w2l7BxosS8_34.snap";
        sha256 = "sha256-Dna9yFgP7JeQLAeZWvSZ+eSMX2yQbX2/+mX0QC22lYY=";
      };

      buildInputs = with final; [squashfsTools];

      unpackPhase = ''
        unsquashfs -dest . $src
      '';

      installPhase = ''
        install -vD chromium-ffmpeg-${version}/chromium-ffmpeg/libffmpeg.so $out/lib/libffmpeg.so
      '';
    };
  };
}
