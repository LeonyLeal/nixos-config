{pkgs, ...}: let
  # .NET
  dotnetCombined = with pkgs.dotnetCorePackages;
    combinePackages [
      sdk_6_0
      sdk_7_0
      sdk_8_0
      sdk_9_0
      sdk_10_0
    ];

  pythonDev =
    pkgs.python314.withPackages
    (pythonPackages:
      with pythonPackages; [
        pip
        virtualenv
        setuptools
        wheel
      ]);
in {
  nixpkgs.config = {
    allowUnfree =
      true;

    # .NET 6 / 7 EOL

    permittedInsecurePackages = [
      "dotnet-sdk-6.0.428"
      "dotnet-sdk-wrapped-6.0.428"

      "dotnet-runtime-6.0.36"
      "dotnet-runtime-wrapped-6.0.36"

      "aspnetcore-runtime-6.0.36"
      "aspnetcore-runtime-wrapped-6.0.36"

      "dotnet-sdk-7.0.410"
      "dotnet-sdk-wrapped-7.0.410"

      "dotnet-runtime-7.0.20"
      "dotnet-runtime-wrapped-7.0.20"

      "aspnetcore-runtime-7.0.20"
      "aspnetcore-runtime-wrapped-7.0.20"
    ];
  };

  programs.nix-ld.enable =
    true;

  # .NET ENVIRONMENT

  environment.sessionVariables = {
    DOTNET_CLI_TELEMETRY_OPTOUT = "1";

    DOTNET_NOLOGO = "1";
  };

  virtualisation.docker.enable =
    true;

  # Required for Snapcraft CLI, which is distributed as a classic snap.
  services.snap.enable =
    true;

  environment.systemPackages = with pkgs; [
    vscode

    git

    vim

    wget

    curl

    jq

    tree

    ripgrep

    fd

    file

    which

    just

    gcc

    gnumake

    cmake

    pkg-config

    autoconf

    automake

    libtool

    openssl

    zlib

    patchelf

    zip

    unzip

    gnutar

    gzip

    xz

    # .NET

    dotnetCombined

    pythonDev

    jdk17

    maven

    gradle

    swi-prolog

    postgresql

    pgcli

    dbeaver-bin

    xh

    httpie

    grpcurl

    websocat
  ];
}
