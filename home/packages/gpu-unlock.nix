{ lib, stdenv, fetchFromGitHub, fetchurl, python3, zstd, kernel, kernelModuleMakeFlags }:

let
  version = "1.0.0";
  src = fetchFromGitHub {
    owner = "Zagitta";
    repo = "gpu-unlock";
    rev = "af28cbbfd3d922a659227ecfb7369adfd924cf03";
    hash = "sha256-6FaDuPojB707ds7gkQY/g/+m4Tnz1xHZ95UjNfFxBJc=";
  };

  nvidiaSource = fetchurl {
    url = "https://download.nvidia.com/XFree86/NVIDIA-kernel-module-source/NVIDIA-kernel-module-source-610.43.03.tar.xz";
    sha256 = "7e118923c7a23edc36114d63273a46e3e04e9af98695a42203e7ac2dfe9fc1dc";
  };
  nvidiaUtils = fetchurl {
    url = "https://archive.cachyos.org/archive/cachyos-v3/nvidia-utils-610.43.03-1-x86_64_v3.pkg.tar.zst";
    sha256 = "e17e7c92eeffa178b0fe1f40eb17a47095f8fc3ce4a77bf115cf5bd5a4df86e9";
  };

  firmware = stdenv.mkDerivation {
    pname = "gpu-unlock-firmware";
    inherit version src;
    nativeBuildInputs = [ python3 zstd ];
    dontFixup = true;

    buildPhase = ''
      runHook preBuild
      mkdir inputs
      ln -s ${nvidiaSource} inputs/NVIDIA-kernel-module-source-610.43.03.tar.xz
      ln -s ${nvidiaUtils} inputs/nvidia-utils-610.43.03-1-x86_64_v3.pkg.tar.zst
      make firmware INPUTS="$PWD/inputs" ASSETS="$PWD/assets"
      runHook postBuild
    '';

    doCheck = true;
    checkPhase = ''
      runHook preCheck
      GPU_UNLOCK_ASSETS="$PWD/assets" python3 -m unittest discover -s tests -v
      runHook postCheck
    '';

    installPhase = ''
      runHook preInstall
      make install-firmware ASSETS="$PWD/assets" \
        FWDIR="$out/lib/firmware/gpu-unlock/610.43.03" \
        LICENSEDIR="$out/share/licenses"
      runHook postInstall
    '';

    meta = {
      description = "Firmware payloads for the Ampere GPU unlock module";
      homepage = "https://github.com/Zagitta/gpu-unlock";
      license = lib.licenses.unfree;
      platforms = [ "x86_64-linux" ];
    };
  };
in
stdenv.mkDerivation {
  pname = "gpu-unlock";
  version = "${version}-${kernel.modDirVersion}";
  inherit src;
  sourceRoot = "source/kernel/gpu_unlock";
  nativeBuildInputs = kernel.moduleBuildDependencies;
  hardeningDisable = [ "pic" "format" ];
  makeFlags = kernelModuleMakeFlags ++ [
    "KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
  ];

  installPhase = ''
    runHook preInstall
    install -Dm644 gpu_unlock.ko "$out/lib/modules/${kernel.modDirVersion}/extra/gpu_unlock.ko"
    runHook postInstall
  '';

  passthru = { inherit firmware; };
  meta = {
    description = "Pre-driver FP16/BF16 throughput unlock for supported Ampere GPUs";
    homepage = "https://github.com/Zagitta/gpu-unlock";
    license = lib.licenses.gpl2Only;
    platforms = [ "x86_64-linux" ];
  };
}
