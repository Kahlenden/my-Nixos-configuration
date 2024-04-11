{ pkgs
, stdenv
, lib
, fetchFromGitHub
, fetchpatch2
, wrapQtAppsHook
, cmake
, qtbase
, qtsvg
, qttools
#, libcaesium
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "caesium-image-compressor";
  version = "2.6.0";

  src = fetchFromGitHub {
    owner = "Lymphatus";
    repo = "caesium-image-compressor";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TbhcGGS22wfN47R78Ns2Nct8w7haMCNDatG8NXRXeK4=";#sha256-TJnDHk2FhjNPM7Z1WXMlFSxZjdZO+gcX9SyaYDsj/NE=";
  };

  patches = [
    # Remove Windows-specific build code Linux
    # https://github.com/Lymphatus/caesium-image-compressor/pull/199
    (fetchpatch2 {
      url = "https://github.com/Lymphatus/caesium-image-compressor/commit/4293296340e0bd497d26d9420d00f39c30b0e9e6.patch";
      hash = "sha256-n0KnHMtrlF1K1G4MfX/3+yaY7emkR4MmEX5aVx4/JPQ=";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];

  buildInputs = [
    (pkgs.callPackage ./libcaesium.nix{})
    qtbase
    qtsvg
    qttools
  ];

  meta = with lib; {
    description = "Reduce file size while preserving the overall quality of the image";
    homepage = "https://github.com/Lymphatus/caesium-image-compressor";
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ jtojnar ];
  };
})
