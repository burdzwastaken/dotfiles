{ winboat-flake, fetchurl }:

winboat-flake.packages.x86_64-linux.winboat.overrideAttrs (old: {
  src = fetchurl {
    url = "https://github.com/TibixDev/winboat/releases/download/v${old.version}/winboat-${old.version}-x64.tar.gz";
    sha256 = "sha256-4NV9nyFLYJt9tz3ikDTb1oSpJGAKr1I49D0VHqpty3I=";
  };
})
