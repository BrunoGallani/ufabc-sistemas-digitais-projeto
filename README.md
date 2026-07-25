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
**template-somadorpf-vhdl**

# Tutorial: Implementação de Somador Ponto Flutuante na DE10-Lite

**Autores:** [Nome do Aluno 1], [Nome do Aluno 2], , [Nome do Aluno 3]

**Disciplina:** Sistemas Digitais Q2.20026

**Data:** [Data da entrega]

---
*Etapa 1*
## 1. Objetivo do Projeto
Este projeto adapta o somador de ponto flutuante simplificado (13 bits) do livro-texto para a placa Terasic DE10-Lite (MAX 10). O objetivo é demonstrar a síntese lógica e a simulação de hardware usando VHDL.

## 2. Descrição gráfica do funcionamento do sistema
Usar os elementos necessários para descrever o fucnionamento, isto é, tabelas verdade, diagramas de estados, etc.
Usar as variáveis de entrada e saída especificadas no VHDL.

*Etapa 2*
## 3. Adaptações de Hardware (DE10-Lite)
Indicar o que a arquitetura original usava e quais mudanças foram feitas para a implementação na placa

**O que mudamos no VHDL original:**
* Removemos...
* Roteamos ...
* Reorganizamos ...

**Descrição gráfica do sistema**
* Caso mudar a descrição gráfica feita no item 2, atualizar aqui.
* Usar as variáveis de entrada e saída especificadas no VHDL.

## 4. Evidências de Validação

### Simulação 
Abaixo, a imagem do funcionamento do 4º estágio (normalização). Considerar os 4 casos detalhados.

![Print das Telas do Simulador com as Formas de Onda](link-da-imagem-aqui.jpg)

### Código VHDL Final 
```vhdl
-- Insira aqui o VHDL final e faça ênfase nos trechos de código mais importantes da sua adaptação, isto é, eles devem estar claramente identificados.
```
*Etapa 3*

### Funcionamento na Placa
Abaixo, imagens do funcionamento na Placa para 4 casos.

*Etapa 4 (considerando qeu a Etapa 4 considera toda a documentação em si)*
## 5. Diário de Bordo de IA 
Utilizamos o [ChatGPT/Claude/Gemini] para auxiliar na geração do Testbench e na refatoração do código. Abaixo está a análise crítica do uso da ferramenta.

**Prompts Utilizados:**
> "Insira aqui o prompt exato que você usou..."

**O Erro da IA (Alucinação):**
> Descreva aqui o que a IA errou (ex: tentou usar pinos inexistentes, criou clock em testbench de circuito combinacional, etc).

**A Correção Humana:**
> Como você corrigiu o código gerado para que ele funcionasse na nossa placa e na simulação.

## 6. Contribuição dos participantes
Utilize a taxonomia CRediT, seguem exemplos:
 * [Nome do Aluno 1], Administração do Projeto, Desenvolvimento, implementação e teste de software, Análise Formal
 * [Nome do Aluno 2], Validação de dados e experimentos
 * [Nome do Aluno 3], Redação do manuscrito original, Validação de dados e experimentos
