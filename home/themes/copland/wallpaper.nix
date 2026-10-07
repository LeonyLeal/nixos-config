{
  config,
  lib,
  pkgs,
  ...
}: let
  videoPath = "${config.home.homeDirectory}/.local/share/Steam/steamapps/workshop/content/431960/2737408638/4K Serial Experiments Lain Copland OS Live Wallpaper Background Visual [CoplandOS] - oDownloader.com.mp4";
  launcher = pkgs.writeShellScript "copland-wallpaper" ''
    exec ${pkgs.bash}/bin/bash ${./wallpaper.sh} \
      ${lib.escapeShellArg videoPath} \
      ${../lain/wallpaper.png} \
      ${lib.getExe pkgs.mpvpaper} \
      -o 'no-config no-audio loop-file=inf image-display-duration=inf vf=fps=30 cache=no demuxer-max-bytes=64MiB demuxer-max-back-bytes=16MiB hwdec=auto-safe'
  '';
in {
  home.packages = [pkgs.mpvpaper];

  # Só o fundo do desktop é externo; login/bloqueio mantêm a imagem do DMS.
  desktop.dms.preset.settings.screenPreferences.wallpaper = [];

  systemd.user.services.copland-wallpaper = {
    Unit = {
      Description = "CoplandOS animated wallpaper on all monitors";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target" "dms.service"];
      Requisite = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${launcher}";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
