{ stdenv, fetchFromGitHub, lib, pipewire, autoreconfHook, pkg-config, nixosTests
, gitUpdater, }:

stdenv.mkDerivation rec {
  pname = "pipewire-module-xrdp";
  version = "0.1";

  src = fetchFromGitHub {
    owner = "neutrinolabs";
    repo = pname;
    rev = "748f562d616590c678d5b06722f3fe5ae9707465";
    hash = "sha256-7UspJxpxFy/W15Hz4mtLCIxx42t+vpnRxNJk67BmWJk=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/pipewire/modules $out/libexec/pipewire-xrdp-module $out/etc/xdg/autostart
    install -m 755 src/.libs/*${stdenv.hostPlatform.extensions.sharedLibrary} $out/lib/pipewire/modules

    install -m 755 instfiles/load_pw_modules.sh $out/libexec/pipewire-xrdp-module/pipewire_xrdp_init
    substituteInPlace $out/libexec/pipewire-xrdp-module/pipewire_xrdp_init \
      --replace "(pipewire" "(${pipewire}/bin/pipewire" \
      --replace pw-cli ${pipewire}/bin/pw-cli \
      --replace pw-metadata ${pipewire}/bin/pw-metadata \

    runHook postInstall
  '';

  nativeBuildInputs = [ autoreconfHook pkg-config pipewire.dev ];

  passthru = { updateScript = gitUpdater { rev-prefix = "v"; }; };

  meta = with lib; {
    description = "xrdp sink/source pipewire modules";
    homepage = "https://github.com/neutrinolabs/pipewire-module-xrdp";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ lucasew ];
    platforms = platforms.linux;
    sourceProvenance = [ sourceTypes.fromSource ];
  };
}
