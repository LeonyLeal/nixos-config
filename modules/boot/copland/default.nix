{
  config,
  lib,
  pkgs,
  ...
}: let
  plymouth = lib.getExe' config.boot.plymouth.package "plymouth";
  relay = pkgs.writeShellScript "copland-boot-status" ''
    ${lib.getExe' config.systemd.package "journalctl"} \
      --boot --follow --lines=1 --output=json --no-pager --quiet |
      ${pkgs.python3}/bin/python3 ${./status.py} ${plymouth}
  '';
  markSplashStart = pkgs.writeShellScript "copland-mark-splash-start" ''
    ${pkgs.python3}/bin/python3 -c 'import time; from pathlib import Path; Path("/run/copland-splash-start").write_text(str(time.monotonic()))'
  '';
  markShutdownStart = pkgs.writeShellScript "copland-mark-shutdown-start" ''
    ${pkgs.python3}/bin/python3 -c 'import time; from pathlib import Path; Path("/run/copland-shutdown-start").write_text(str(time.monotonic()))'
  '';
  waitForMinimumSplash = pkgs.writeShellScript "copland-minimum-splash-duration" ''
    if ${pkgs.gnugrep}/bin/grep -qw 'plymouth.enable=0' /proc/cmdline; then
      exit 0
    fi
    ${pkgs.python3}/bin/python3 ${./duration.py} /run/copland-splash-start 16
  '';
  waitForMinimumShutdown = pkgs.writeShellScript "copland-minimum-shutdown-duration" ''
    if ${pkgs.gnugrep}/bin/grep -qw 'plymouth.enable=0' /proc/cmdline; then
      exit 0
    fi
    ${pkgs.python3}/bin/python3 ${./duration.py} /run/copland-shutdown-start 3
  '';
  shutdownTargets = ["poweroff.target" "reboot.target" "halt.target" "kexec.target"];
  statusService = {
    unitConfig = {
      DefaultDependencies = false;
      ConditionKernelCommandLine = "!plymouth.enable=0";
    };
    serviceConfig = {
      Type = "simple";
      ExecStart = relay;
      TimeoutStopSec = "2s";
      StandardOutput = "null";
      StandardError = "journal";
    };
    restartIfChanged = false;
  };
in {
  boot = {
    plymouth = {
      enable = true;
      theme = "copland";
      themePackages = [(import ./theme.nix {inherit pkgs;})];
    };
    # Quiet console only: these settings do not disable journald collection.
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "udev.log_level=3"
      "rd.systemd.show_status=false"
      "systemd.show_status=false"
    ];
    initrd = {
      verbose = false;
      # The journal shows simpledrm coming up at 1.05s, Plymouth at 1.12s,
      # then NVIDIA KMS replacing it between 4.60s and 6.57s. Load KMS early
      # so that handoff happens before the splash becomes visible.
      kernelModules = lib.optionals config.hardware.nvidia.enabled ["nvidia" "nvidia_modeset" "nvidia_drm"];
    };
  };

  services.journald.storage = "persistent";

  systemd.services = {
    copland-boot-status = lib.recursiveUpdate statusService {
      description = "Copland single-line boot status from the system journal";
      wantedBy = ["sysinit.target"];
      wants = ["systemd-journald.service"];
      after = ["plymouth-start.service" "systemd-journald.service"];
      before = ["plymouth-quit.service" "plymouth-quit-wait.service" "shutdown.target"];
      conflicts = ["shutdown.target"];
      serviceConfig.ExecStartPre = [markSplashStart];
    };

    # Avoid a Conflicts=plymouth-quit edge: both units belong to the initial boot
    # transaction, which could otherwise discard the status service at startup.
    plymouth-quit.serviceConfig = {
      ExecStartPre = [waitForMinimumSplash];
      ExecStartPost = [
        "-${lib.getExe' config.systemd.package "systemctl"} --no-block stop copland-boot-status.service"
      ];
    };

    copland-shutdown-status = lib.recursiveUpdate statusService {
      description = "Copland single-line shutdown status from the system journal";
      wantedBy = shutdownTargets;
      after = ["plymouth-poweroff.service" "plymouth-reboot.service" "plymouth-halt.service" "plymouth-kexec.service"];
      before = ["copland-shutdown-minimum.service"];
      serviceConfig.ExecStartPre = [markShutdownStart];
    };

    copland-shutdown-minimum = {
      description = "Keep the Copland shutdown animation visible for at least three seconds";
      unitConfig = {
        DefaultDependencies = false;
        ConditionKernelCommandLine = "!plymouth.enable=0";
      };
      wantedBy = shutdownTargets;
      after = ["copland-shutdown-status.service"];
      before = ["systemd-poweroff.service" "systemd-reboot.service" "systemd-halt.service" "systemd-kexec.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = waitForMinimumShutdown;
      };
    };
  };
}
