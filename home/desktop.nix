{...}: let
  # ============================================================
  # DEFAULT APPLICATIONS
  # ============================================================
  browser = "firefox.desktop";

  fileManager = "thunar.desktop";

  imageViewer = "org.gnome.Loupe.desktop";

  pdfViewer = "org.gnome.Papers.desktop";

  mediaPlayer = "vlc.desktop";

  textEditor = "code.desktop";

  torrentClient = "org.qbittorrent.qBittorrent.desktop";

  archiveManager = "org.gnome.FileRoller.desktop";
in {
  # ============================================================
  # UDISKIE
  # ============================================================
  #
  # Automount de:
  #
  # - pendrives
  # - HDs externos
  # - SSDs externos
  # - cartões
  #
  # O backend system-wide é o UDisks2.
  #

  services.udiskie = {
    enable = true;

    automount = true;

    notify = true;

    # Não precisamos de um segundo ícone permanente na tray.
    #
    # O dispositivo continua aparecendo normalmente no Thunar.
    tray = "never";
  };

  # ============================================================
  # XDG MIME APPLICATIONS
  # ============================================================

  xdg.mimeApps = {
    enable = true;

    defaultApplications = {
      # ========================================================
      # FILE MANAGER
      # ========================================================

      "inode/directory" =
        fileManager;

      # ========================================================
      # WEB
      # ========================================================

      "text/html" =
        browser;

      "application/xhtml+xml" =
        browser;

      "x-scheme-handler/http" =
        browser;

      "x-scheme-handler/https" =
        browser;

      "x-scheme-handler/about" =
        browser;

      "x-scheme-handler/unknown" =
        browser;

      # ========================================================
      # IMAGES
      # ========================================================

      "image/*" =
        imageViewer;

      # ========================================================
      # PDF
      # ========================================================

      "application/pdf" =
        pdfViewer;

      # ========================================================
      # VIDEO
      # ========================================================

      "video/*" =
        mediaPlayer;

      # ========================================================
      # AUDIO
      # ========================================================

      "audio/*" =
        mediaPlayer;

      # ========================================================
      # TEXT
      # ========================================================

      "text/plain" =
        textEditor;

      "text/markdown" =
        textEditor;

      "application/json" =
        textEditor;

      "application/xml" =
        textEditor;

      # ========================================================
      # ARCHIVES
      # ========================================================

      "application/zip" =
        archiveManager;

      "application/x-7z-compressed" =
        archiveManager;

      "application/x-rar" =
        archiveManager;

      "application/vnd.rar" =
        archiveManager;

      "application/x-tar" =
        archiveManager;

      "application/gzip" =
        archiveManager;

      # ========================================================
      # TORRENTS
      # ========================================================

      "application/x-bittorrent" =
        torrentClient;

      "x-scheme-handler/magnet" =
        torrentClient;
    };
  };
}
