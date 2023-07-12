{ 
  fetchzip, 
  jre8, 
  lib, 
  makeWrapper, 
  stdenv 
}:

stdenv.mkDerivation rec {
  version = "1.0-beta181";
  pname = "yaac";

  src = fetchzip {
    url = "https://www.ka2ddo.org/ka2ddo/YAAC.zip";
    hash = "sha256-15oH+I/ACbcHQ6bMohKoO1+GKDu8ThkjKTKN0JIHty8=";
    stripRoot = false;
  };

  nativeBuildInputs = [ makeWrapper ];

  # TODO: Make Desktop Icon

  installPhase = ''
    runHook preInstall

    mkdir -p $out
    mkdir -p $out/bin

    cp -r $src/* $out

    makeWrapper ${jre8}/bin/java $out/bin/yaac \
      --add-flags "-jar $out/YAAC.jar" \
      --set _JAVA_OPTIONS '-Dawt.useSystemAAFontSettings=on' \
      --set _JAVA_AWT_WM_NONREPARENTING 1

    runHook postInstall
  '';

  meta = with lib; {
    description = "Yet Another APRS Client";
    homepage = "https://www.ka2ddo.org/ka2ddo/YAAC.html";
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
    maintainers = [ maintainers.dotemup ];
  };

}