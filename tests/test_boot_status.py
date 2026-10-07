"""The splash must retain real failures and never invent completion events."""

import importlib.util
import json
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest


SCRIPT = Path(__file__).resolve().parents[1] / "modules/boot/copland/status.py"
PLYMOUTH_SCRIPT = Path(__file__).resolve().parents[1] / "modules/boot/copland/copland.script"


class BootStatusTests(unittest.TestCase):
    def setUp(self):
        self.assertTrue(SCRIPT.exists(), "The boot status relay is not implemented")
        spec = importlib.util.spec_from_file_location("boot_status", SCRIPT)
        self.module = importlib.util.module_from_spec(spec)
        spec.loader.exec_module(self.module)

    def test_service_messages_keep_their_actual_state(self):
        self.assertEqual(self.module.format_entry({"_PID": "1", "PRIORITY": "6",
            "MESSAGE": "Starting Network Manager..."}), "Starting Network Manager...")
        self.assertEqual(self.module.format_entry({"_PID": "1", "PRIORITY": "6",
            "MESSAGE": "Started Network Manager."}), "Started Network Manager.")

    def test_failure_is_identifiable_even_from_another_process(self):
        self.assertEqual(self.module.format_entry({"_PID": "42", "PRIORITY": "3",
            "MESSAGE": "Unable to mount disk"}), "[ERRO] Unable to mount disk")
        self.assertIsNone(self.module.format_entry({"_PID": "42", "PRIORITY": "6",
            "MESSAGE": "Unrelated application chatter"}))

    def test_status_is_one_plain_bounded_line(self):
        text = self.module.format_entry({"_PID": "1", "PRIORITY": "4",
            "MESSAGE": "\x1b[31mWarning\x1b[0m\n\t" + "a" * 300})
        self.assertTrue(text.startswith("[AVISO] Warning "))
        self.assertNotIn("\x1b", text)
        self.assertNotIn("\n", text)
        self.assertLessEqual(len(text), 160)

    def test_crlf_status_keeps_r_and_becomes_one_line(self):
        text = self.module.format_entry({"_PID": "1", "PRIORITY": "4",
            "MESSAGE": "Erro ao reiniciar\r\nretomando servico"})
        self.assertEqual(text, "[AVISO] Erro ao reiniciar retomando servico")
        self.assertNotIn("\r", text)
        self.assertNotIn("\n", text)

    def test_status_text_is_ascii_safe_for_plymouth(self):
        text = self.module.format_entry({"_PID": "1", "PRIORITY": "6",
            "MESSAGE": "Ação concluída — aguardando o próximo serviço…"})
        self.assertTrue(text.isascii())
        self.assertEqual(text, "Acao concluida - aguardando o proximo servico...")

    def test_fast_status_updates_coalesce_and_remain_visible_for_a_beat(self):
        coalescer = self.module.StatusCoalescer(interval=1.2)
        self.assertEqual(coalescer.push("Iniciando rede", now=10.0), "Iniciando rede")
        self.assertIsNone(coalescer.push("Aguardando DNS", now=10.2))
        self.assertIsNone(coalescer.push("Rede pronta", now=10.8))
        self.assertIsNone(coalescer.flush(now=11.19))
        self.assertEqual(coalescer.flush(now=11.2), "Rede pronta")

    def test_native_plymouth_updates_use_the_same_minimum_display_interval(self):
        script = PLYMOUTH_SCRIPT.read_text()
        self.assertIn("STATUS_UPDATE_TICKS = 60", script)
        self.assertIn("ticks - last_status_tick >= STATUS_UPDATE_TICKS", script)
        clean_line = script.split("fun clean_line(text)", 1)[1].split("fun render_status", 1)[0]
        self.assertNotIn('|| c == "\\r"', clean_line)

    def test_malformed_entries_do_not_break_the_splash(self):
        for entry in (None, [], {}, {"MESSAGE": [255]}, {"MESSAGE": "", "_PID": "1"}):
            self.assertIsNone(self.module.format_entry(entry))

    def test_relay_passes_each_status_as_one_literal_argument(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            capture = root / "messages.jsonl"
            player = root / "plymouth"
            player.write_text("#!" + sys.executable + "\nimport json,sys\n"
                + "with open(" + repr(str(capture)) + ", 'a') as f: f.write(json.dumps(sys.argv[1:])+'\\n')\n")
            player.chmod(0o755)
            entries = [{"_PID": "1", "PRIORITY": "6", "MESSAGE": text}
                       for text in ("Starting test.service...", "Started test.service; $(false).")]
            result = subprocess.run([sys.executable, str(SCRIPT), str(player)],
                input="invalid json\n" + "\n".join(map(json.dumps, entries)),
                text=True, capture_output=True)
            self.assertEqual(result.returncode, 0, result.stderr)
            messages = [json.loads(line) for line in capture.read_text().splitlines()]
            self.assertEqual(messages, [
                ["display-message", "--text=Starting test.service..."],
                ["display-message", "--text=Started test.service; $(false)."],
            ])
