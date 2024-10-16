{ lib, stdenv, fetchurl }:

# Note: this package is used for bootstrapping fetchurl, and thus
# cannot use fetchpatch! All mutable patches (generated by GitHub or
# cgit) that are needed here should be included directly in Nixpkgs as
# files.

let
  rev = "d4e37b5868ef910e3e52744c34408084bb13051c";

  # Don't use fetchgit as this is needed during Aarch64 bootstrapping
  configGuess = fetchurl {
    name = "config.guess-${builtins.substring 0 7 rev}";
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.guess?id=${rev}";
    sha256 = "191czpnbc1nxrygg8fd3839y1f4m9x43rp57vgrsas6p07zzh3c1";
  };
  configSub = fetchurl {
    name = "config.sub-${builtins.substring 0 7 rev}";
    url = "https://git.savannah.gnu.org/cgit/config.git/plain/config.sub?id=${rev}";
    sha256 = "0148p54gw10p6sk2rn3gi9vvqm89rk8kcvl9335ckayhanx31381";
  };
in stdenv.mkDerivation {
  pname = "gnu-config";
  version = "2023-07-31";

  buildCommand = ''
    install -Dm755 ${configGuess} $out/config.guess
    install -Dm755 ${configSub} $out/config.sub
  '';

  meta = with lib; {
    description = "Attempt to guess a canonical system name";
    homepage = "https://savannah.gnu.org/projects/config";
    license = licenses.gpl3;
    # In addition to GPLv3:
    #   As a special exception to the GNU General Public License, if you
    #   distribute this file as part of a program that contains a
    #   configuration script generated by Autoconf, you may include it under
    #   the same distribution terms that you use for the rest of that
    #   program.
    maintainers = with maintainers; [ dezgeg emilytrau ];
    platforms = platforms.all;
  };
}
