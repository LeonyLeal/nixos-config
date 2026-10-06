# Transições de boot e sessão do Copland OS

## Contexto

O desktop Copland usa Plymouth para o splash de boot/desligamento e Quickshell
para as transições de login/logout. O GRUB ainda usa o tema e a imagem padrão
do NixOS. Depois de selecionar a primeira entrada do GRUB, o menu some e uma
tela sem conteúdo útil — seguida pela imagem com a marca NixOS — permanece
visível antes da animação Plymouth. No login, o usuário relata cerca de quatro
segundos de tela preta com mensagens antes da animação.

O teste OCR do Plymouth confirmou que o status `Texto com r e R: Copland Navi`
é renderizado como `Texto com e R: Copland Navi`. A comparação com `"\r"` em
`copland.script` coincide com a remoção do `r` minúsculo. O script de login
também aguarda o Hyprland anunciar um monitor, e o QML adia o aparecimento do
emblema em 2,2 segundos.

## Objetivo

Apresentar uma transição visual Copland coerente desde a seleção da geração no
GRUB até o desktop, corrigir a perda de `r/R`, evitar mensagens cruas tomando
a tela e iniciar login/logout visualmente sem espera artificial. Manter os
registros completos disponíveis no journal para diagnóstico.

## Abordagens consideradas

1. **Tema Copland no GRUB e imagem de passagem coordenada com Plymouth
   (escolhida):** personalizar menu e fundo persistente do GRUB com a arte e as
   cores Copland; manter o menu de gerações e o início antecipado do Plymouth.
   A imagem estática permanece durante a carga do kernel e dá lugar ao splash
   animado assim que o initrd assume o framebuffer.
2. **Ajustar somente Plymouth e Quickshell:** corrige os atrasos e o texto, mas
   deixa a identidade NixOS visível entre GRUB e Plymouth.
3. **Ocultar o menu do GRUB:** não atende ao uso descrito, pois o menu e a
   seleção de gerações precisam continuar disponíveis; esta alternativa foi
   descartada.

O GRUB permite personalizar imagens, cores, fontes, menu e indicador de tempo,
mas não executar a mesma animação contínua do Plymouth. Portanto, o objetivo é
uma passagem visual consistente, não uma animação única que atravesse o
carregamento do kernel.

## Desenho

### GRUB e boot

- Criar um tema GRUB Copland a partir dos ativos e da paleta existentes. Gerar
  os PNGs necessários no build com as ferramentas já usadas pelo tema; não
  adicionar pacotes.
- Definir o novo tema e uma imagem de splash estática Copland em
  `modules/boot.nix`. Coordenar a imagem do tema, a imagem de `splashImage` e o
  primeiro quadro do Plymouth para evitar a tela de marca NixOS durante a
  transferência.
- Preservar o menu, o tempo de seleção, a primeira entrada para a geração
  atual, o submenu de gerações anteriores e as opções de recuperação. Não
  alterar `gfxpayload=keep` sem evidência de que uma mudança melhora a
  transferência de vídeo; manter a resolução gráfica entre GRUB e kernel.
- Manter Plymouth como splash animado assim que o initrd puder desenhar. Fazer
  o emblema surgir desde o começo da animação, removendo o atraso deliberado,
  mas preservando os 16 segundos mínimos já definidos.
- Evitar texto cru do console sobre a tela gráfica. Qualquer supressão de
  status do systemd deve afetar apenas a saída no console; journal e serviço
  que encaminha status ao Plymouth continuam ativos. Erros continuam
  identificados na linha do splash.

O hardware atual inicia `simpledrm` antes da NVIDIA e troca para o framebuffer
NVIDIA alguns segundos depois. O splash pode sofrer uma breve interrupção nessa
troca; o teste em VM não representa essa GPU. A configuração deve evitar a
imagem NixOS e manter a aparência Copland durante a passagem, sem prometer que
o primeiro quadro animado seja exibido antes de o kernel assumir o vídeo.

### Texto e diagnóstico do Plymouth

- Remover do script Plymouth as comparações com escapes que possam ser
  interpretados como letras comuns. Normalizar retorno de carro, quebras de
  linha e caracteres não imprimíveis no relay Python antes de enviar o texto
  ao Plymouth.
- Preservar a substituição de status em uma linha e a priorização de erros e
  avisos. O journal persistente continua sendo a fonte do registro completo.
- Expandir o teste OCR para incluir `r` e `R`, além de uma mensagem com quebra
  de linha/retorno de carro; confirmar que o texto aparece íntegro em uma linha.

### Login e logout

- Iniciar o Quickshell assim que o evento de início do Hyprland da sessão
  principal ocorrer, sem o loop de espera por `hyprctl monitors`. A janela
  continua usando o modelo reativo de telas para aparecer nos monitores
  disponíveis.
- Mostrar fundo Copland e emblema imediatamente; manter textos legíveis,
  animação fluida e duração mínima de 16 segundos.
- Preservar a ordem do logout: mostrar a transição, aguardar seu fim e então
  terminar a sessão. Não deixar uma falha ao abrir o Quickshell impedir a saída
  da sessão.
- Manter os logs de falha de Quickshell e do encerramento no journal da sessão
  para diagnóstico.

## Limites

O menu do GRUB permanece interativo e as gerações anteriores continuam
acessíveis. Antes de o kernel e o initrd assumirem o controle do vídeo, GRUB só
pode exibir sua imagem estática. Mudanças no modo de vídeo ou no driver NVIDIA
serão consideradas somente se a medição após a primeira implementação mostrar
uma interrupção evitável; não serão feitas às cegas.

Não fazem parte desta mudança: alterar pacotes instalados, trocar o greeter,
mudar o tema de aplicativos, ou redesenhar Dock e áreas de trabalho.

## Validação e critérios de aceite

- `nix flake check` avalia a configuração, constrói o tema GRUB/Plymouth e
  executa os testes existentes de boot, login e logout.
- O teste Plymouth OCR reconhece texto contendo `r` minúsculo e `R` maiúsculo,
  sem espaços inseridos, e a linha continua sendo atualizada sem perder o
  histórico do journal.
- A avaliação do GRUB confirma menu e submenu de gerações ativos, timeout
  preservado e tema/imagem Copland apontados para ativos existentes.
- Os testes de sessão confirmam que o login não espera pelo loop antigo de
  monitores, que a animação se fecha ao final e que logout efetivamente termina
  a sessão. A revisão visual deve cobrir os dois monitores disponíveis.
- Após instalar a geração de teste e reiniciar o computador real, verificar a
  passagem GRUB → Plymouth e consultar `journalctl -b` se houver pausa, falha
  ou mensagem indevida no console. A VM não pode validar o tempo da troca de
  framebuffer da NVIDIA.
