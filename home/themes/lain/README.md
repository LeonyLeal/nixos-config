# Lain // Wired

Tema para Hyprland, Dank Material Shell, GTK 3/4 e Kitty. Qt mantém a base
Adwaita escura de `home/desktop/appearance.nix`.

`palette.nix` é a fonte única das cores. Os módulos `gtk.nix`, `kitty.nix`,
`dms.nix`, `shell.nix` e `hyprland.nix` aplicam a paleta aos aplicativos.
O JSON `~/.config/DankMaterialShell/themes/lain-wired.json` é gerado pelo Nix.
O wallpaper fica em `wallpaper.png` e a preparação das preferências em
`home/desktop/apply-theme.py`.

## Aplicar

```sh
sudo nixos-rebuild switch --flake path:/etc/nixos#nixos
```

O prefixo `path:` inclui os arquivos novos mesmo antes de adicioná-los ao Git.
Ao versionar o tema, inclua também o script Python, o wallpaper e os testes.

O serviço de usuário `dms.service` inicia `desktop-shell`, que aplica o preset
antes de executar o DMS. Entre novamente na sessão ao migrar da inicialização
direta pelo Hyprland. Nas atualizações seguintes, após o rebuild:

```sh
systemctl --user restart dms.service
```

Isso reinicia apenas a shell do desktop. Reabra os aplicativos GTK e o Kitty
para carregar suas configurações novas. Também é possível sair e entrar na sessão.

As preferências do DMS continuam editáveis. A aparência e o wallpaper do preset
são reaplicados em cada inicialização por `desktop-shell`; widgets e preferências
não relacionadas são preservados. O script recusa arquivos JSON inválidos ou
gerenciados por symlink. Os arquivos originais recebem um backup único:

- `~/.config/DankMaterialShell/settings.json.pre-lain`
- `~/.local/state/DankMaterialShell/session.json.pre-lain`

Para restaurar essas preferências, execute `systemctl --user stop dms.service`,
restaure os backups e inicie
`dms run` diretamente. Para manter a restauração nas próximas sessões, desative
o preset com `desktop.dms.preset = lib.mkForce null;` em um módulo do Home Manager.
Para remover também os estilos declarativos, remova o import do tema em `home.nix`.

## Verificar

```sh
python3 -B -m unittest discover -s tests -v
nix flake check path:/etc/nixos --no-update-lock-file
```

Os testes exercitam a aplicação real em diretórios temporários: preservação
de widgets/preferências, backup, idempotência, primeira inicialização e recusa
de JSON inválido ou symlinks.

## Wallpaper

Gerado com a ferramenta integrada `image_gen`, sem imagens de referência,
e salvo em `home/themes/lain/wallpaper.png` (1672 × 941). Prompt utilizado:

> Create a finished desktop wallpaper for a Linux Hyprland desktop themed around Serial Experiments Lain and the Wired. Wide 16:9 landscape, preferably 2560x1440. Atmospheric late-1990s psychological anime background art: silhouetted Japanese utility poles, transformers and intricate overhead telephone wires framing left and right edges, a dim distant urban skyline near the bottom, faint ominous crimson glow through blue-black night haze. Restrained dark palette: almost black #07080A, charcoal #171A20, muted slate #718DA8, small wine-red #C3263E accents, a few ivory highlights. Subtle analog grain and delicate CRT texture, beautifully drawn cinematic composition, melancholic and quiet. Keep middle 60 percent spacious dark negative space for windows; top edge dark for panel readability. No text, no typography, no logos, no UI, no watermark. Full bleed wallpaper, not a mockup.
