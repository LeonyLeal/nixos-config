{...}: {
  # ============================================================
  # ZRAM
  # ============================================================
  #
  # Swap comprimido armazenado na RAM.
  #
  # Em vez de enviar imediatamente páginas pouco utilizadas
  # para o SSD, o kernel pode comprimi-las e armazená-las em RAM.
  #
  # Útil principalmente durante:
  #
  # - builds .NET
  # - Docker
  # - PostgreSQL
  # - VS Code
  # - browsers com muitas abas
  # - builds Node / Next.js
  # - jogos + aplicações abertas simultaneamente
  #

  zramSwap = {
    enable = true;

    # Capacidade lógica máxima da ZRAM.
    #
    # Com 16 GB:
    #
    # 50% = aproximadamente 8 GB de capacidade ZRAM.
    #
    # IMPORTANTE:
    # isso NÃO reserva 8 GB físicos.
    # A RAM é usada somente conforme dados são enviados à ZRAM.
    memoryPercent = 50;

    # Bom equilíbrio entre compressão e velocidade.
    algorithm = "zstd";

    # Faz a ZRAM ter preferência sobre eventual swap em SSD.
    priority = 100;

    # Um único dispositivo é suficiente.
    swapDevices = 1;
  };
}
