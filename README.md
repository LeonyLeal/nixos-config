# NixOS — Z30N

Configuração de uma estação com Hyprland, Dank Material Shell e Home Manager.
O sistema entra por `configuration.nix`; a configuração do usuário, por `home.nix`.
`flake.nix` conecta os inputs e disponibiliza `nixosConfigurations.nixos`.

## Onde alterar

| Responsabilidade | Arquivo ou diretório |
| --- | --- |
| Inputs e integração NixOS/Home Manager | `flake.nix` e `flake.lock` |
| Discos, montagem e detecção da máquina | `hardware-configuration.nix` |
| Driver NVIDIA e ZRAM | `modules/hardware/` |
| Áudio, fontes, Thunar e serviços do desktop | `modules/desktop/default.nix` |
| Habilitação do compositor | `modules/desktop/hyprland.nix` |
| Pacote DMS e tela de login | `modules/desktop/dms.nix` |
| Aplicativos pessoais do desktop | `home/desktop/applications.nix` |
| Aplicativos padrão e montagem de mídia | `home/desktop/default.nix` |
| GTK/Qt, cursor e ícones base | `home/desktop/appearance.nix` |
| Inicialização, preset opcional e geração da ajuda do DMS | `home/desktop/dms.nix` |
| Plugins do DMS e suas opções declarativas | `home/desktop/plugins.nix` |
| Bash, Zsh, aliases e integrações | `home/shell/default.nix` |
| Prompt Starship | `home/shell/starship.nix` |
| Ferramentas de linha de comando | `home/tools.nix` |
| Pacote e comportamento do Kitty | `home/terminal/kitty.nix` |
| Layout, efeitos e regras de janelas do Hyprland | `home/hyprland/hyprland.lua` |
| Atalhos compartilhados pelo Hyprland e pela ajuda do DMS | `home/hyprland/keybindings.nix` |
| Cores compartilhadas e tema Lain | `home/themes/lain/` |

Os diretórios com `default.nix` são importados por seus pontos de entrada.
Serviços e drivers ficam no NixOS; aplicativos pessoais e preferências ficam
no Home Manager. As ferramentas globais de desenvolvimento permanecem em
`modules/development.nix`.

## Tema e Hyprland

Edite as cores em `home/themes/lain/palette.nix`. DMS, GTK, Kitty, Starship,
Zsh e Hyprland consomem essa paleta. O JSON do DMS é gerado, sem uma segunda
cópia de cores para editar.

`home/hyprland/keybindings.nix` é a única lista de atalhos: cada entrada contém
tecla, descrição, grupo, ação Lua e flags opcionais. Ela gera os comandos do
Hyprland e a ajuda do DMS, incluindo mídia, brilho, mouse e workspaces.
O antigo índice `hypr/dms/binds.conf` foi removido; a ajuda usa o provider `z30n`.

O módulo base combina `hyprland.lua` com os atalhos gerados. O tema acrescenta
as cores, e o módulo do DMS acrescenta a inicialização. O resultado é instalado
por `xdg.configFile` em `~/.config/hypr/hyprland.lua`.

O Hyprland inicia `desktop-shell` pelo caminho do Nix store. O launcher prepara
as preferências antes de executar o pacote DMS definido no sistema. O preset
fica no tema; a lógica de aplicação fica em `home/desktop/apply-theme.py`.
Remover `./home/themes/lain` dos imports de `home.nix` mantém os módulos base
funcionais, sem referências à paleta ou ao shader Lain.

Consulte [o guia do tema](home/themes/lain/README.md) para aplicação e backups.

## Plugins do DMS

`home/desktop/plugins.nix` instala e habilita Docker Manager e VSCode Launcher.
Seus fontes são inputs sem flake, com revisões fixadas em `flake.lock`.

- Docker Manager: containers, Compose, logs e terminal pelo Kitty. O widget é
  acrescentado à direita da primeira barra ativa, caso ainda não esteja em
  nenhuma seção. Uma posição existente é preservada.
- VSCode Launcher: abra o launcher com `Super + Space` e pesquise com `vs`,
  por exemplo `vs nixos`. Usa o VS Code estável e seu histórico de projetos.

O launcher `desktop-shell` prepara `plugin_settings.json` depois do tema e
antes de abrir o DMS. Mescla apenas as opções declaradas, preservando outros
plugins e preferências; backups originais recebem o sufixo `.pre-plugins`.
As opções declaradas são reaplicadas a cada inicialização. Na ausência de
`barConfigs`, o layout padrão do DMS é preservado; o widget pode ser adicionado
pela interface ou na próxima inicialização após o DMS salvar suas barras.

Os diretórios desses dois plugins são gerenciados pelo Home Manager. Para
atualizá-los, use o Nix, mantendo as versões registradas no repositório:

```sh
nix flake update dms-docker-manager dms-vscode-launcher --flake path:/etc/nixos
```

Após o rebuild, entre novamente na sessão ou execute `dms kill` seguido de
`hyprctl dispatch exec desktop-shell`. Isso reinicia a shell e aplica as opções.

## Validar e aplicar

```sh
nix flake check path:/etc/nixos --no-update-lock-file
sudo nixos-rebuild switch --flake path:/etc/nixos#nixos
```

O check constrói o sistema, executa os testes do tema, dos plugins e dos atalhos, verifica
formatação/lint e constrói o Home Manager sem o tema Lain. Ele não ativa a
configuração na sessão atual.

Após incluir os arquivos novos no Git, `nix fmt` formata os fontes com Alejandra.
Antes disso, use `nix run path:/etc/nixos#formatter.x86_64-linux -- .`.
Os testes Python também podem ser executados isoladamente com
`python3 -B -m unittest discover -s tests -v`.

`path:` inclui os arquivos novos antes de adicioná-los ao Git. Ao versionar
uma reorganização, inclua tanto os novos caminhos quanto a remoção dos antigos.
Depois disso, `nh os build` e `nh os switch` continuam usando `/etc/nixos`.

Os caminhos dos arquivos instalados em `~/.config` permanecem estáveis,
independentemente da organização dos fontes neste repositório.
