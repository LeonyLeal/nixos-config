{pkgs}:
pkgs.testers.runNixOSTest {
  name = "copland-boot";
  enableOCR = true;
  nodes.machine = {
    pkgs,
    lib,
    ...
  }: {
    imports = [../modules/boot/copland];
    virtualisation = {
      memorySize = 1024;
      graphics = true;
      qemu.options = ["-vga std"];
    };
    boot = {
      initrd = {
        systemd.enable = true;
        kernelModules = ["bochs"];
      };
      consoleLogLevel = lib.mkForce 3;
      kernelParams = ["plymouth.graphical" "plymouth.debug=stream:/run/copland-plymouth-debug.log"];
    };
    # Keep only the VM splash visible long enough to exercise messages/prompts.
    systemd.services.copland-preview-hold = {
      wantedBy = ["multi-user.target"];
      before = ["plymouth-quit.service" "plymouth-quit-wait.service"];
      serviceConfig = {
        Type = "oneshot";
        ExecStart = "${pkgs.coreutils}/bin/sleep 120";
      };
    };
  };
  testScript = ''
    start_all()
    machine.wait_for_unit("copland-boot-status.service")
    machine.succeed("plymouth --ping")
    machine.succeed("systemctl is-active copland-boot-status.service")
    machine.succeed("plymouth display-message --text='Starting test.service...'")
    machine.sleep(4)
    machine.screenshot("copland-startup")
    machine.copy_from_vm("/run/copland-plymouth-debug.log")
    machine.wait_for_text("Copland OS", timeout=30)
    machine.succeed("systemd-cat --priority=err echo COPLAND_PROBE_FAILURE")
    machine.succeed("journalctl -b --no-pager | grep COPLAND_PROBE_FAILURE")
    machine.sleep(2)
    machine.screenshot("copland-journal-error")
    machine.succeed("systemctl stop copland-boot-status.service")
    machine.succeed("plymouth display-message --text='Tenho um texto explicativo'")
    machine.wait_for_text("Tenho um texto explicativo", timeout=30)
    machine.screenshot("copland-text-with-t")
    machine.succeed("plymouth display-message --text='Texto com r e R: Copland Navi'")
    machine.wait_for_text("Texto com r e R: Copland Navi", timeout=30)
    machine.screenshot("copland-text-with-r")
    machine.succeed("grep -qw 'rd.systemd.show_status=false' /proc/cmdline")
    machine.succeed("grep -qw 'systemd.show_status=false' /proc/cmdline")
    machine.succeed("plymouth display-message --text='[ERRO] Falha de teste: registro preservado'")
    machine.sleep(1)
    machine.screenshot("copland-error")
    machine.succeed("plymouth display-message --text='Started test.service.'")
    machine.sleep(1)
    machine.screenshot("copland-replaced-status")
    machine.succeed("systemctl start copland-boot-status.service")
    machine.succeed("systemctl stop copland-preview-hold.service")
    machine.wait_for_unit("multi-user.target")
    machine.wait_until_fails("systemctl is-active --quiet copland-boot-status.service")
    machine.succeed("journalctl -b --no-pager | grep 'Copland single-line boot status'")
    machine.fail("journalctl -b --no-pager | grep -i 'ordering cycle'")
    machine.succeed("journalctl -b --no-pager | grep COPLAND_PROBE_FAILURE")
    machine.succeed("systemctl start plymouth-reboot.service copland-shutdown-status.service")
    machine.succeed("plymouth --ping")
    machine.succeed("systemd-cat --priority=err echo COPLAND_SHUTDOWN_PROBE")
    machine.succeed("journalctl -b --no-pager | grep COPLAND_SHUTDOWN_PROBE")
    machine.sleep(2)
    machine.screenshot("copland-shutdown")
    machine.succeed("systemctl stop copland-shutdown-status.service; plymouth quit")
  '';
}
