{
  lib,
  pkgs,
  buildFHSEnv,
  fetchurl,
  jetbrains,
  makeDesktopItem,
  unzip,
}: let
  version = "2026.3.1";

  productName = "pro";
  productDesktop = "BurpSuite Professional";
  burpHash = "sha256-jRVRvqFRsRO+vbEoV35bX4vi9XEYl737L0umt61ACtk=";

  burpSrc = fetchurl {
    name = "burpsuite.jar";
    urls = [
      "https://portswigger.net/burp/releases/download?product=${productName}&version=${version}&type=Jar"
      "https://web.archive.org/web/https://portswigger.net/burp/releases/download?product=${productName}&version=${version}&type=Jar"
    ];
    hash = burpHash;
  };

  loaderSrc = ./.;

  pname = "burpsuitepro";

  description = "An integrated platform for performing security testing of web applications";
  desktopItem = makeDesktopItem {
    name = "burpsuitepro";
    exec = pname;
    icon = pname;
    desktopName = productDesktop;
    comment = description;
    categories = [
      "Development"
      "Security"
      "System"
    ];
  };
in
  buildFHSEnv {
    inherit pname version;

    runScript = "${jetbrains.jdk-no-jcef}/bin/java -Dawt.toolkit.name=WLToolkit -Dsund.java2d.vulkan=True -Dos.name=linux -Duser.name=user --add-opens=java.desktop/javax.swing=ALL-UNNAMED --add-opens=java.base/java.lang=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.tree=ALL-UNNAMED --add-opens=java.base/jdk.internal.org.objectweb.asm.Opcodes=ALL-UNNAMED -javaagent:${loaderSrc}/loader.jar -noverify -jar ${burpSrc}";

    targetPkgs = pkgs:
      with pkgs; [
        alsa-lib
        at-spi2-core
        cairo
        cups
        dbus
        expat
        glib
        gtk3
        jython
        libcanberra-gtk3
        libdrm
        udev
        libxkbcommon
        libgbm
        libglvnd
        nspr
        nss
        pango
      ];

    extraInstallCommands = ''
      mkdir -p $out/share/pixmaps
      mkdir -p $out/share

      ${lib.getBin unzip}/bin/unzip -p ${burpSrc} resources/Media/icon64${productName}.png > $out/share/pixmaps/burpsuitepro.png

      cp ${burpSrc} $out/share/burpsuite_pro_v${version}.jar
      cp ${loaderSrc}/loader.jar $out/share/loader.jar

      # Create loader executable
      mkdir -p $out/bin
      echo "#!${pkgs.bash}/bin/bash" > $out/bin/loader
      echo "\"${jetbrains.jdk-no-jcef}/bin/java\" -jar \"$out/share/loader.jar\" \"\$@\"" >> $out/bin/loader
      chmod +x $out/bin/loader

      cp -r ${desktopItem}/share/applications $out/share
    '';

    meta = with lib; {
      inherit description;
      longDescription = ''
        Burp Suite is an integrated platform for performing security testing of web applications.
        Its various tools work seamlessly together to support the entire testing process, from
        initial mapping and analysis of an application's attack surface, through to finding and
        exploiting security vulnerabilities.
      '';
      homepage = "https://github.com/sammhansen/Burpsuite-Professional.git";
      changelog =
        "https://portswigger.net/burp/releases/professional-community-"
        + replaceStrings ["."] ["-"] version;
      sourceProvenance = with sourceTypes; [binaryBytecode];
      license = licenses.unfree;
      platforms = jetbrains.jdk-no-jcef.meta.platforms;
      hydraPlatforms = [];
      maintainers = with maintainers; [
        bennofs
        fab
      ];
      mainProgram = "burpsuite";
    };
  }
