{
  stdenv,
  fetchgit,

  stow,
  rsync,
  lm_sensors,
 }:

stdenv.mkDerivation {
  pname = "unix";
  version = "0.0.1";
  src = fetchgit {
    url = "https://gitlab.com/artnoi/unix";
    sha256 = "065gzl30965idk8kvlspvyiryj85xblhjs8cpna5pnbcylqrnllm";
  };

  buildInputs = [
    # Note: 'yes' is provided by coreutils
    rsync
    stow
  ];
  runtimeInputs = [
    lm_sensors    
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out;
    cp *.sh  $out/;
    runHook postInstall
  '';
}
