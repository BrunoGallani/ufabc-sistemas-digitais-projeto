# Projeto: Somador de Ponto Flutuante em VHDL

Este projeto contém a implementação em VHDL de um somador de ponto flutuante, incluindo a lógica de decodificação para exibição em displays de 7 segmentos multiplexados.

## Estrutura dos Arquivos

Os seguintes arquivos compõem o design do projeto:

* **`fp_adder.vhd`**: Implementação principal do somador de ponto flutuante.
* **`hex_to_sseg.vhd`**: Decodificador de valores hexadecimais para o display de 7 segmentos.
* **`disp_mux.vhd`**: Multiplexador para controle da exibição em múltiplos displays de 7 segmentos.
* **`fp_adder_test.vhd`**: Entidade de nível superior (*top-level*) que integra o somador e os módulos de display para teste e simulação.
* **`compile.sh`**: Script bash de automação para compilação, simulação e visualização.

## Pré-requisitos

Para compilar, simular e visualizar este projeto, você precisará das seguintes ferramentas instaladas e adicionadas às variáveis de ambiente (`PATH`):

1. **[GHDL](https://ghdl.github.io/ghdl/)**: Ferramenta open-source para compilar e executar simulações de código VHDL.
2. **[GTKWave](https://gtkwave.sourceforge.net/)**: Visualizador de formas de onda para analisar os resultados da simulação.
3. **Terminal compatível com Bash**: Se estiver no Windows, recomenda-se o uso do **Git Bash** ou WSL. Em distribuições Linux e macOS, o terminal padrão já é compatível.

## Como Executar e Simular

1. Salve todos os arquivos (`.vhd` e `.sh`) no mesmo diretório.
2. Abra o seu terminal (Git Bash no Windows, ou o terminal padrão no Linux/macOS) e navegue até a pasta do projeto.
3. Conceda permissão de execução ao script de compilação (necessário apenas na primeira vez):
   ```bash
   chmod +x compile.sh
   ```
4. Execute o script:
   ```bash
   ./compile.sh
   ```
O script fará a análise sintática, compilará as entidades, executará a simulação gerando o arquivo `wave.vcd` e, por fim, abrirá o GTKWave automaticamente.

## Analisando as Formas de Onda no GTKWave

Após a execução do script, a interface do **GTKWave** será aberta carregando o arquivo `wave.vcd`. Para visualizar o comportamento do circuito:

1. No painel superior esquerdo (**SST**), expanda a árvore de instâncias do projeto.
2. Clique em `fp_adder_test` (ou nos módulos internos como `fp_add_unit`).
3. Selecione os sinais que deseja inspecionar na lista de sinais logo abaixo (por exemplo: `sw`, `btn`, `sign_out`, `exp_out`, `frac_out`).
4. Clique em **"Append"** ou arraste os sinais para o painel principal à direita para visualizar as mudanças de estado (formas de onda) ao longo da simulação.