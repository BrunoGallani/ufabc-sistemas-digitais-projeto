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
