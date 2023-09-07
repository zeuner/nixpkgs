{ lib
, stdenv
, fetchFromGitHub
, static ? stdenv.hostPlatform.isStatic
, cxxStandard ? null
, config
, cudaSupport ? config.cudaSupport
, cmake
, assimp
, boost
, ceres-solver
, clp
, coin-utils
, eigen
, expat
, geogram
, onnxruntime
, openexr
, openimageio
}:

stdenv.mkDerivation (finalAttrs: {
  variant = lib.optionalString cudaSupport "-gpu";
  pname = "AliceVision${finalAttrs.variant}";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "alicevision";
    repo = "${finalAttrs.pname}";
    rev = "refs/tags/v${finalAttrs.version}";
    fetchSubmodules = true;
    hash = "sha256-fPIkT9pEBZpqEE/2d52b9UMEb8yv9PvBJPcmXigwJp8=";
  };

    patches = [
      # AliceVision wants custom Coins libraries with CMake exports.
      # So we can either adapt those, or add CMake scripts here
      # (https://github.com/alicevision/AliceVision/pull/1500)
      ./cmake-fixes.patch
    ];

  cmakeFlags = [
    "-DALICEVISION_USE_CUDA=${if cudaSupport then "ON" else "OFF"}"
    "-DBUILD_SHARED_LIBS=${if static then "OFF" else "ON"}"
  ];

  strictDeps = true;

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    assimp
    boost
    ceres-solver
    clp
    coin-utils
    eigen
    expat
    geogram
    onnxruntime
    openexr
    openimageio
  ];

  meta = with lib; {
    description = "Photogrammetric Computer Vision Framework ";
    homepage = "https://alicevision.org/";
    license = lib.licenses.mpl20;
    platforms = platforms.all;
  };
})
