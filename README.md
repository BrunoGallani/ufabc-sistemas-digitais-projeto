**template-somadorpf-vhdl**

# Tutorial: Implementação de Somador Ponto Flutuante na DE10-Lite

**Autores:** Bruno Augusto Soares Gallani, Rafael de Souza Coelho, Thiago Alexandre Paiares e Silva

**Disciplina:** Sistemas Digitais Q2.2026

**Data:** 09/08/2026

---
*Etapa 1*
## 1. Objetivo do Projeto
Este projeto adapta o somador de ponto flutuante simplificado (13 bits) do livro-texto FPGA Prototyping by VHDL Examples, de Pong Chu, elaborado originalmente para Xilinx Spartan-3, para a placa Terasic DE10-Lite (MAX 10). O objetivo é demonstrar a síntese lógica e a simulação de hardware usando VHDL, bem como o funcionamento prático da placa.

## 2. Descrição gráfica do funcionamento do sistema
Usar os elementos necessários para descrever o fucnionamento, isto é, tabelas verdade, diagramas de estados, etc.
Usar as variáveis de entrada e saída especificadas no VHDL.

O sistema funciona como um somador de dois valores na representação de ponto flutuante, com a simplificação adotada pelo livro-texto. Os valores são constituídos por um bit de sinal (1 para negativo e 0 para positivo), oito bits que representam a parte fracionária (0.f) e quatro bits de expoente (X), na forma S 0.FFFFFFFFEXXXX, em que E representa uma potência de base 2. Por exemplo, o valor 0 0.11000110E1000 é a representação de 0,77343 × 28 = 198.
Ao receber os dois valores, a função matemática principal fp_adder realiza a ordenação (sort) decrescente (maior para menor; big number e small number), o alinhamento (align) de expoentes, de forma que o expoente do small number deve se igualar ao expoente do big number. Nessa etapa, os bits da parte fracionária do small number são deslocados à direita o tanto quanto for necessário para que os expoentes se igualem. Em seguida, ocorre a soma/subtração (add/sub) de fato, com a operação sendo realizada na parte fracionária, já que os expoentes são iguais. O último passo é a normalização (normalize) do resultado, para que fique na forma normalizada. Pode ser necessário deslocar bits à direita no caso de a soma gerar carry-out, deslocar bits à esquerda caso o resultado tenha zeros à esquerda na parte fracionária ou, ainda, converter o resultado para zero quando o valor é pequeno demais para ser representado.

Como parte da 


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
O vídeo explicativo do funcionamento da placa com um exemplo está disponível no endereço: [link do YouTube ou Drive]


*Etapa 4*
## 5. Diário de Bordo de IA

Foram utilizadas as ferramentas de IA “Claude” e “Gemini” para auxiliar nas seguintes etapas do projeto: extração inicial do código-fonte do livro-texto; geração do testbench; geração de scripts para conversão numérica; validação de resultados obtidos referentes a cálculos numéricos para verificar possíveis erros. Abaixo está a análise crítica do uso das ferramentas em cada etapa:

---

### 5.1. Extração inicial do código-fonte

A IA Claude foi usada para tratamento e transcrição de textos, com o objetivo de acelerar a captura do código: os blocos de código do livro foram capturados, em seguida enviados para uma IA para transcrever, e tratar o texto. O seguinte prompt foi utilizado:

```
“A partir do pdf anexo, preciso desses dois códigos no formato VHD. O primeiro (3.19) deve ser nomeado fp_adder.vhd e o segundo (3.20) como fp_adder_test.vhd. Extraia exatamente como está no documento, com a indentação adequada.”
```

O resultado obtido foi muito satisfatório, sem alucinações nem erros.

---

### 5.2. Geração do *testbench*

A ferramenta Claude foi utilizada para geração de alguns vetores do *testbench* no estágio inicial do projeto. Posteriormente, foram inseridos outros casos de teste no arquivo. O prompt a seguir foi utilizado:

```
“Com base no código `fp_adder.vhd` que soma dois valores de ponto flutuante, gere casos de teste no formato de testbench em um arquivo nomeado `tb_fp_adder.vhd`, com intervalos de 20 ns”.
```

O resultado foi muito bom e auxiliou na compreensão do problema/funcionamento do sistema, com alguns dos vetores gerados utilizados na simulação GTKWave apresentada na seção 2.

---

### 5.3. Geração de scripts para conversão numérica

Foi utilizada a IA Gemini para auxiliar na geração de código para conversões numéricas. O seguinte prompt foi utilizado:

```
“Ajude a criar um script que faz o seguinte:

Converte um número decimal para de ponto flutuante usando 13 bits, os bits da esquerda para direita funcionam da seguinte forma:

Primeiro ---> sinal (1 = negativo; 0 = positivo)

Próximos oito bits ---> mantissa (vai até 0,99609375, 2^-1 + 2^-2… até 2^-8)

Próximos 4 bits ---> vai até 15, é o expoente, usa base 2

Assim, o número máximo é:

0 11111111 1111 = 32640

Quero um script que converta de decimal para essa representação, e o contrário também“
```

O output foi muito satisfatório, no entanto, foi gerada uma versão inicial bem básica; dessa forma, o código gerado foi alterado, não corrigido, diversas vezes posteriormente (sem o uso de IA), com o objetivo de atender plenamente às necessidades do projeto.

---

### 5.4. Validação de resultados obtidos referentes a cálculos numéricos para verificar possíveis erros

Apenas para validação externa e de modo a evitar erros humanos na conversão de valores em bases, foi solicitado que a IA Gemini calculasse qual a representação decimal de valores na forma adotada [sinal] 0.[msb_hex][lsb_hex]E[exp_hex]. Para quatro dos cinco valores solicitados, o cálculo foi correto. O prompt utilizado foi:

```
“Se considerarmos que na representação [sinal] 0.[msb_hex][lsb_hex]E[exp_hex], o caractere E representa uma potência de base 2 (2<sup>x</sup>) e que os valores depois de E representam os bits do expoente x e, ainda, pensando em representação hexadecimal, quais os valores na base decimal de 
-0,c0Eb

0,dcEf

0,9eEf

0,e3Ed

0,9cEc?”
```

O erro da IA foi observado no cálculo de $-0,c0Eb$, conforme trecho da resposta a seguir:  

"**-0,c0Eb**
- **Sinal:** Negativo (-)
- **Mantissa (0,c0<sub>16</sub>)**:
12/16 + 0/256 = 0,75 + 0 = 0,75
- **Expoente (11<sub>2</sub>)**:
11<sub>2</sub> = 3<sub>10</sub> ⇒ 2<sup>3</sup> = 8
- **Cálculo**:
-0,75 * 8 = **-6**"

> CORREÇÃO HUMANA: o expoente não é 11 na base binária, mas sim 11 já na base decimal. Como o único erro relatado acima não se tratava do código, mas sim de um cálculo de verificação, não foi necessário alterar o código.

## 6. Contribuição dos participantes

 - **Bruno Augusto Soares Gallani:** Conceituação; Curadoria de dados; Desenvolvimento, implementação e teste de software; Administração do Projeto; Disponibilização de ferramenta; Supervisão; Redação do manuscrito original; Redação - revisão e edição.

- **Rafael de Souza Coelho:** Conceituação; Disponibilização de ferramentas; Desenvolvimento, implementação e teste de software; Redação do manuscrito original; Redação - revisão e edição.

 - **Thiago Alexandre Paiares e Silva:** Conceituação; Curadoria de dados; Análise Formal; Investigação; Metodologia; Disponibilização de ferramentas; Desenvolvimento, implementação e teste de software; Validação de dados e experimentos; Redação do manuscrito original; Redação - revisão e edição.