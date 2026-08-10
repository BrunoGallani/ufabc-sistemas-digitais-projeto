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
O sistema funciona como um somador de dois valores na representação de ponto flutuante, com a simplificação adotada pelo livro-texto. Os valores são constituídos por um bit de sinal (1 para negativo e 0 para positivo), oito bits que representam a parte fracionária (0.f) e quatro bits de expoente (X), na forma S **0.**FFFFFFFF**E**XXXX, em que E representa uma potência de base 2. Por exemplo, o valor 0 0.11000110E1000 é a representação de 0,77343 × 2<sup>8</sup> = 198.

Para esse sistema, o autor do livro adotou a representação normalizada, que exige o bit mais significativo (MSB) da parte fracionária (`frac`) sempre igual a 1. Assim, a menor representação absoluta possível (diferente de zero) é 0.10000000E0000 (0,5 × 2<sup>0</sup> = 0,5) e a maior, 0.11111111E1111 (0,99609 × 2<sup>15</sup> = 32640).

Ao receber os dois valores, cada um segmentado em `sign` (sinal), `frac` (parte fracionária após o 0.) e `exp` (expoente da potência de base 2), a entidade matemática principal fp_adder realiza a ordenação (*sort*) decrescente (maior para menor; *big number* e *small number*), o alinhamento (*align*) de expoentes, de forma que o expoente do *small number* deve se igualar ao expoente do *big number*. Nessa etapa, os *bits* da parte fracionária do *small number* são deslocados à direita o tanto quanto for necessário para que os expoentes se igualem. Em seguida, ocorre a soma/subtração (*add/sub*) de fato, com a operação sendo realizada na parte fracionária, já que os expoentes são iguais. O último passo é a normalização (*normalize*) do resultado. Eventualmente, pode ser necessário deslocar *bits* à direita no caso de a soma gerar *carry-out*, deslocar *bits* à esquerda caso o resultado tenha zeros à esquerda na parte fracionária ou, ainda, converter o resultado para zero quando o valor é pequeno demais para ser representado na forma adotada.

A primeira etapa da adaptação para a DE10-Lite correspondia à comprovação do funcionamento da parte matemática implementada em `fp_adder.vhd` (listing 3.19 do livro-texto). Para isso, foi necessário elaborar, com auxílio do Claude (detalhes na seção 5), um *testbench* (`tb_fp_adder.vhd`) com seis casos de teste para `fp_adder.vhd`, onde são escolhidos, em cada caso, vetores de `signN`, `fracN`, `expN` (com N sendo 1 ou 2), representando valores representáveis. 
Os arquivos `tb_fp_adder.vhd` e `fp_adder.vhd` foram compilados utilizando os comandos devidos com GHDL e as formas de onda observadas no GTKWave são as presentes nas imagens a seguir.

![Formas de onda observadas no GTKWave - Primeira imagem](/assets/images/GTKWave_1.png)
Considerando que, na representação de ponto flutuante adotada, signN é o bit de sinal, fracN são os bits da parte fracionária (após 0.) e expN são os bits do expoente, para o primeiro caso de testes (com valores exibidos no GTKWave em representação hexadecimal), o primeiro número dos testes era composto por sign1 = 0, frac1 = AA (10101010<sub>2</sub>) e exp1 = 8 (1000<sub>2</sub>), o que corresponde a 0 0.10101010E1000 (0,6640625 × 2<sup>8</sup> = 170). Já o segundo valor era 0 0.10000000E1000 (0,5 × 2<sup>8</sup> = 128). 
Portanto, a soma esperada é 298. O resultado (`_out`) é 0 0.10010101E1001 (0,58203125 × 2<sup>9</sup> = 298), compatível com a soma esperada.

![Formas de onda observadas no GTKWave - Segunda imagem](/assets/images/GTKWave_2.png)
Para o terceiro caso de teste, o detalhamento dos passos do *simplified floating-point adder* descritos pelo autor estão listados a seguir.

**numbers**

- num1: 0 0.11000000E1010 (0,75 × 2<sup>10</sup> = 768)<br>
(`sign1` = 0, `frac1` = C0 [11000000] e `exp1` = A [1010])

- num2: 0 0.10000000E1001 (0,5 × 2<sup>9</sup> = 256)<br>
(`sign2` = 0, `frac2` = 80 [10000000] e `exp2` = 9 [1001])


**sorting**

Já estão ordenados, logo:

- *big number*: 0 0.11000000E1010

- *small number*: 0 0.10000000E1001


**alignment**

Nessa etapa é necessário igualar o expoente do *small number* ao do *big number* deslocando bits à direita.

- *big number*: 0 0.11000000E1010

- *small number*: 0 0.01000000E1010

**addition**

A soma é de fato realizada nessa etapa.

- Resultado: 0 1.00000000E1010

**normalization**

Como a etapa anterior gerou bit de *carry-out*, será necessário normalizar o resultado com deslocamento à direita.

- final: 0 0.10000000E1011 (0,5 × 2<sup>11</sup> = 1024)<br>
(`sign_out` = 0, `frac_out` = 80 [10000000] e `exp_out` = B [1011])

O resultado final é, portanto, o esperado (1024 = 768 + 256)

![Formas de onda observadas no GTKWave - Terceira imagem](/assets/images/GTKWave_3.png)
O penúltimo caso de teste foi elaborado para observar saídas com sinal negativo e possui os passos descritos a seguir.  

**numbers**

num1: 0 0.10100000E0010 (0,625 × 2<sup>2</sup> = 2,5)<br>
(`sign1` = 0, `frac1` = A0 [10100000] e `exp1` = 2 [0010])


num2: 1 0.10000000E0011 (0,5 × 2<sup>3</sup> = 4)<br>
(`sign2` = 1, `frac2` = 80 [10000000] e `exp2` = 3 [0011])

**sorting**

Necessário efetuar a ordenação:

- *big number*: 1 0.10000000E0011

- *small number*: 0 0.10100000E0010

**alignment**

Nessa etapa é necessário igualar o expoente do *small number* ao do *big number* deslocando bits à direita.

- *big number*: 1 0.10000000E0011

- *small number*: 0 0.01010000E0011

**addition**

A soma é de fato realizada nessa etapa.

- Resultado: 1 0.00110000E0011 (-0,1875 × 2<sup>3</sup> = -1,5)

**normalization**

Como, na etapa anterior, há dois bits `0` à esquerda na parte fracionária, é preciso normalizar. Para isso, os bits são deslocados à esquerda, com o devido ajuste no expoente.

- final: 1 0.11000000E0001 (-0,75 × 2<sup>1</sup> = -1,5)<br>
(`sign_out` = 1, `frac_out` = C0 [11000000] e `exp_out` = 1 [0001])

O resultado final é, assim, o esperado (-1,5 = 2,5 - 4).

Com os resultados anteriormente exibidos, foi possível analisar que o algoritmo matemático de `fp_adder.vhd` funciona antes de alterar o hardware. 

---

*Etapa 2*

## 3. Adaptações de Hardware (DE10-Lite)

A implementação sugerida pelo autor da soma dos valores em `fp_adder.vhd` permaneceu inalterada. O código responsável por inserir a lógica matemática de `fp_adder.vhd`na placa é o `fp_adder_test.vhd`. Na arquitetura originalmente desenvolvida para a placa Xilinx Spartan-3, o código presente no Listing 3.20 *Floating-point adder testing circuit* usa artefatos específicos, tais como `clk` (*clock*), `an`, a entidade auxiliar `disp_mux.vhd`, necessária para a multiplexação dos quatro displays de sete segmentos, recebendo os padrões armazenados em `led`, além de 8 *switches* (`sw`) e 4 botões (`btn`).

Como os displays da Spartan-3 **não** são individualizados, isto é, era possível acionar apenas um dos displays por vez, o código adotava uma lógica de alternar (multiplexar) entre os displays de forma muito rápida pelo *clock* `clk` (sendo necessária multiplexação pela entidade `disp_mux.vhd`), em que o display escolhido era representado por `an` (anodo) de modo que a impressão visual fosse dos quatro simultaneamente acesos.

No caso da DE10-Lite, existem 10 *switches* (`sw`),  2 botões (`key`) e 6 displays **individuais** de sete segmentos (`hex`), o que dispensa a necessidade do `clk` (*clock*), da multiplexação (`disp_mux.vhd`) e de `an`. Cada um dos displays pode receber valores de entrada individualmente e são declarados separadamente no código.

Outra diferença é com relação à nomenclatura dos botões, que na Spartan-3 é `btn`e na DE10-Lite, `key`, conforme o arquivo de especificações `DE10_Lite.qsf`.

Ao analisar a representação de 13 bits adotada (S 0.FFFFFFFFEXXXX), ou ainda mais especificamente, a forma normalizada, S 0.1FFFFFFFEXXXX, é de livre escolha o valor de 12 bits (o de S, os sete LSB da parte fracionária e os quatro do expoente). No entanto, na placa Spartan-3 há limitações para inserir os 12 bits de cada um dos dois valores a serem somados, ou seja, seriam necessários 24 inputs entre botões e *switches*, enquanto a placa possui capacidade para apenas 12 entradas.

Para contornar isso, o autor fixou valores para a maioria dos *bits* de `num1`. No Listing 3.20, são definidos `sign1` como `0`, `exp1` como `1000` e `frac1` como `1[sw1][sw0]10101`, em que os *switches* 1 e 0 definem o valor representado. Ou seja, `num1` é 0 0.1FF10101E1000, com mobilidade apenas em dois bits e, dessa forma, com apenas 4 valores possíveis. Já `num2` é mais flexível, com todos os *bits* (exceto o MSB da parte fracionária que já foi definido como 1 devido à representação normalizada) personalizáveis, sendo `sign2` definido pelo *switch* 7, os quatro *bits* de `exp2` determinados pelos botões e a parte fracionária, `frac2`, composta por `1[sw6][sw5][sw4][sw3][sw2][sw1][sw0]`.

Há, entretanto, uma observação importante. Note que os *switches* 1 e 0 definem *bits* simultaneamente das partes fracionárias de `num1` e `num2`, o que causa interdependência entre os números, reduzindo bastante a flexibilidade de escolha dos valores.

Na adaptação para a DE10-Lite, o grupo escolheu seguir a mesma estratégia do autor na fixação de bits, mas com alterações. No caso dessa placa, também há 12 elementos de entrada, mas são distribuídos em 10 *switches* e 2 botões. Para `num1`, foram definidos `sign1` como `0`, `exp1` como `1[not key1][not key0]1` e a parte fracionária `frac1` como `1[s9][s8][s7]1101`. Logo, a representação de `num1` é 0 0.1FFF1101E1XX1 (isto é, `0 0.1[s9][s8][s7]1101E1[key1][key0]1`), com 32 possibilidades de valores.

As entradas dos botões são interpretadas inversamente pois esse esses inputs são ativos em nível baixo na DE10-Lite. O outro valor, `num2`, tem `sign2` determinado pelo *switch* 5 (`[sw5]`), `exp2` como `1[sw6]00` e a parte fracionária `frac2` como `1[sw4][sw3][sw2][sw1][sw0]10`. A representação de `num2` é S 0.1FFFFF10E1X00 (isto é, `[sw5] 0.1[sw4][sw3][sw2][sw1][sw0]10E1[sw6]00`), com 64 valores absolutos possíveis (ou 128 se considerados os valores opostos).

Logo, o mapeamento dos *inputs* dos *switches* e botões da DE10-Lite para os valores *floating point* é:<br>
- **num1**: `0 0.1[s9][s8][s7]1101E1[not key1][not key0]1`

- **num2**: `[sw5] 0.1[sw4][sw3][sw2][sw1][sw0]10E1[sw6]00`  

As possibilidades de valores são:

`num1`:<br>
282, 314, 346, 378, 410, 442, 474, 506, 1128, 1256, 1384, 1512, 1640, 1768, 1896, 2024, 4512, 5024, 5536, 6048, 6560, 7072, 7584, 8096, 18048, 20096, 22144, 24192, 26240, 28288, 30336, 32384

`num2`:<br>
130, 134, 138, 142, 146, 150, 154, 158, 162, 166, 170, 174, 178, 182, 186, 190, 194, 198, 202, 206, 210, 214, 218, 222, 226, 230, 234, 238, 242, 246, 250, 254, 2080, 2144, 2208, 2272, 2336, 2400, 2464, 2528, 2592, 2656, 2720, 2784, 2848, 2912, 2976, 3040, 3104, 3168, 3232, 3296, 3360, 3424, 3488, 3552, 3616, 3680, 3744, 3808, 3872, 3936, 4000, 4064

Note que a interdependência de *bits* entre os dois números foi removida ao não utilizar um mesmo *input* (*switch* ou botão) nas duas representações. Assim, apesar de possuir limitações na escolha dos valores devido à fixação dos *bits*, cada um é independente do outro.

Como possuía apenas 4 displays, a exibição do resultado na Spartan-3 foi definida pelo autor como (da esquerda para a direita):

- Display 3 (`led3`): sinal (vazio para positivo e traço para negativo)

- Display 2 (`led2`): 4 bits mais significativos (MSBs) da parte fracionária em hexadecimal (por exemplo, 1010 é exibido como A)

- Display 1 (`led1`): 4 bits menos significativos (LSBs) da parte fracionária em hexadecimal

- Display 0 (`led0`): 4 bits do expoente em hexadecimal

Na adaptação do código para a placa DE10-Lite, o grupo optou por seguir uma lógica semelhante à do autor. Como o resultado é também um número na representação adotada S 0.FFFFFFFFEXXXX, os seis displays da placa exibem, da esquerda para a direita:

- Display 5 (`hex5`): sinal (vazio para positivo e traço para negativo)

- Display 4 (`hex4`): fixo em `0.`

- Display 3 (`hex3`): 4 MSBs da parte fracionária em hexadecimal

- Display 2 (`hex2`): 4 LSBs da parte fracionária em hexadecimal

- Display 1 (`hex1`): fixo em `E`, representando a potência de base 2 (2<sup>x</sup>)

- Display 0 (`hex0`): 4 bits do expoente em hexadecimal

Logo, os displays exibem algo como - 0.31EF, que representa:

> 1 0.00110001E1111 = - ((3 × 16<sup>-1</sup> + 1 × 16<sup>-2</sup>) × 2<sup>15</sup>)

Assim, a informação exibida é a mesma da arquitetura anterior, apenas com os dois displays adicionais aproveitados para melhorar a formatação (exibindo `0.` e `E`).

Como observação, a exibição de cada display é definida por oito bits e não por sete. O MSB indica se o ponto/vírgula é exibido ou não no display, enquanto os 7 LSBs se relacionam de fato com a representação numérica em sete segmentos.

Também foi realizada adaptação no código `hex_to_sseg.vhd`, responsável por definir a sequência de bits (`sseg`) necessária para exibir os valores desejados nos displays. Como foi originalmente escrito para a Spartan-3, cujos displays são ativos em nível alto, foi preciso redefinir os *bits* para o formato da DE10-Lite, com displays ativos em nível baixo. 

Os displays 5 (`hex5`), 4 (`hex4`) e 1 (`hex1`) não utilizaram a entidade `hex_to_sseg.vhd` e tiveram a sequência de bits definida diretamente nas linhas do código `fp_adder_test.vhd` (`hex5` é resultado de um condicional com base no sinal do número).

Abaixo, uma tabela com a sequência de bits necessária para exibir cada dígito nos displays da DE10-Lite, com a representação hexadecimal dessa sequência de bits na última coluna.

| exibição do display |    sequência de bits para o display    | hexadecimal da sequência de bits |
|:--------:|:---------:|:---:|
| negativo | 10111111  | BF |
| vazio    | 11111111  | FF |
| 0 com ponto  | 01000000  | 40 |
| 0 sem ponto  | 11000000  | C0 |
| 1        | 11111001  | F9 |
| 2        | 10100100  | A4 |
| 3        | 10110000  | B0 |
| 4        | 10011001  | 99 |
| 5        | 10010010  | 92 |
| 6        | 10000010  | 82 |
| 7        | 11111000  | F8 |
| 8        | 10000000  | 80 |
| 9        | 10010000  | 90 |
| a        | 10001000  | 88 |
| b        | 10000011  | 83 |
| c        | 10100111  | A7 |
| d        | 10100001  | A1 |
| e        | 10000110  | 86 |
| f        | 10001110  | 8E |

## 4. Evidências de Validação

### Simulação 
A seguir, imagem do RTL Viewer gerada no Quartus Prime Lite Edition.

![RTL_Viewer_image](/assets/images/RTL%20Viewer_4.png)

Dentro do Quartus Prime Lite Edition, utilizou-se o simulador Questa Altera Starter FPGA para compilar os testes contidos no arquivo `fp_adder_test.vht` e observar as formas de onda. Esse arquivo contém, para cada caso de teste, as sequências de `sw` e `key`, que correspondem aos inputs da placa DE10-Lite real. 

Por exemplo, considerando as limitações de cada número (`num1` e `num2`) explicadas na seção 3, é possível escolher um dos valores possíveis.
Escolhendo `num1` = 2024 e `num2` = 210, é necessário convertê-los para a representação adotada.

`num1` = 2024 = 0,98828 × 2<sup>11</sup>

Pelo método das multiplicações sucessivas por 2, convertemos 0,98828 para a representação binária:

- 0,98828 × 2 = **1**,97656

- 0,97656 × 2 = **1**,95312

- 0,95312 × 2 = **1**,90624

- 0,90624 × 2 = **1**,81248

- 0,81248 × 2 = **1**,62496

- 0,62496 × 2 = **1**,24992

- 0,24992 × 2 ≈ **0**,5

- 0,5 × 2 = **1**

Logo, na representação binária, temos:<br>
> 2024 = 0 0,11111101E1011

Realizando o mesmo procedimento para `num2`,<br>
`num2` = 210 = 0,82031 × 2<sup>8</sup> = 0 0,11010010E1000

Utilizando o mapeamento de bits descrito na seção 3,<br>

- **num1**: `0 0.1[s9][s8][s7]1101E1[not key1][not key0]1`

- **num2**: `[sw5] 0.1[sw4][sw3][sw2][sw1][sw0]10E1[sw6]00`  

A sequência das chaves e botões da FPGA será:
`sw  <= "1110010100"` e `key <= "01"` (na simulação `.vht`, como `key` possui lógica inversa, inserimos o valor inverso: `10`).

Compilando o `fp_adder_test.vht` no Questa com essas informações, as formas de onda obtidas apresentaram os valores hexadecimais de cada `hex` correspondentes às sequências de bits necessárias para ativar os displays com o dígito desejado. De acordo com a tabela presente ao final da seção anterior, é possível encontrar qual o dígito cada hexadecimal representa.

![Questa_exemplo_1](/assets/images/questa%20exemplo1_5.png)

|hex5|hex4|hex3|hex2|hex1|hex0|
|:--:|:--:|:--:|:--:|:--:|:--:|
|FF  | 40 |  80| 83 | 86 | A7 |
|    |  0.| 8  |  b | E  | c  |

Logo, o resultado foi 0,8bEc, o que equivale a:<br>
> (8 × 16<sup>-1</sup> + 11 × 16<sup>-2</sup>) × 2<sup>12</sup> = 2224.

O valor final, 2224, é muito próximo ao esperado, 2234 (2024 + 210). Esse erro de precisão é compreensível e aceitável, haja vista a perda de bits que pode ocorrer nos truncamentos/deslocamentos de bits à esquerda ou à direita no alinhamento e normalização das partes fracionárias com 8 bits.

Mais um exemplo possível é `num1` = 506 e `num2` = -2144.<br>
Executando os mesmos procedimentos do caso anterior, teremos:
- `num1` = 506 = 0,98828 × 2<sup>9</sup> = 0 0.11111101E1001

- `num2`= -2144 = -0,52343 × 2<sup>12</sup> = 1 0.10000110E1100

Mapeando para os inputs da FPGA, `sw  <= "1111100001"` e `key <= "00"`(pela lógica inversa, consta como `11` no `.vht`). A saída da simulação no Questa consta a seguir.

![Questa_exemplo_2](/assets/images/questa%20exemplo2_6.png)

|hex5|hex4|hex3|hex2|hex1|hex0|
|:--:|:--:|:--:|:--:|:--:|:--:|
|BF  | 40 |  A7| 86 | 86 | 83 |
| -  |  0.| c  |  e | E  | b  |

Assim, o resultado foi -0,ceEb, que equivale a:
> \- ((12 × 16<sup>-1</sup> + 14 × 16<sup>-2</sup>) × 2<sup>11</sup>) = -1648

O valor esperado era -1638, novamente muito próximo do valor obtido pelo sistema.

Na arquitetura adotada pelo grupo, o *switch* 5 (`[sw5]`) é responsável pelo sinal de `num2`. Basta, então, alterar o valor desse bit na sequência `sw` para observar qual seria o resultado da soma 506 + 2144. Mapeando, `sw  <= "1111000001"` e `key <= "00"`(pela lógica inversa, consta como `11` no `.vht`). O Questa exibe o seguinte resultado:

![Questa_exemplo_3](/assets/images/questa%20exemplo3_7.png)

|hex5|hex4|hex3|hex2|hex1|hex0|
|:--:|:--:|:--:|:--:|:--:|:--:|
|FF  | 40 |  88| 92 | 86 | A7 |
|   |  0.| a  |  5 | E  | c  |

O resultado 0,a5Ec é (10 × 16<sup>-1</sup> + 5 × 16<sup>-2</sup>) × 2<sup>12</sup>) = 2640, em linha com o esperado, 2650.

A simulação completa, com todos os outros casos de teste utilizados em `fp_adder_test.vht` consta a seguir.

![Questa_todos_exemplos](/assets/images/questa%20todos_exemplos_8.png)

### Código VHDL Final

A seguir, o código VHDL da entidade principal `fp_adder_test.vhd` na última versão utilizada no carregamento da placa na apresentação para a docente. Os outros códigos VHDL utilizados na compilação do projeto no Quartus estão disponíveis na pasta [`src`](/src/) do presente repositório.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
library work;
use work.all;

entity fp_adder_test is
    port (
        sw : in  std_logic_vector(9 downto 0);  -- os switches
        key : in  std_logic_vector(1 downto 0);  -- as chaves
        hex0 : out std_logic_vector(7 downto 0);  -- display expoente do resultado
        hex1 : out std_logic_vector(7 downto 0);  -- display letra E fixa
        hex2 : out std_logic_vector(7 downto 0);  -- display fracao, 4 LSBs
        hex3 : out std_logic_vector(7 downto 0);  -- display fracao, 4 MSBs
		  hex4 : out std_logic_vector(7 downto 0);  -- display digito zero
        hex5 : out std_logic_vector(7 downto 0)   -- display sinal do resultado
    );
end fp_adder_test;

architecture arch of fp_adder_test is
    signal sign1, sign2 : std_logic;
    signal exp1, exp2 : std_logic_vector(3 downto 0);
    signal frac1, frac2 : std_logic_vector(7 downto 0);
    signal sign_out : std_logic;
    signal exp_out : std_logic_vector(3 downto 0);
    signal frac_out : std_logic_vector(7 downto 0); 
begin
    -- set up the fp adder input signals
    -- ================================
    -- Adaptacao dos bits dos numeros
    -- ================================
    --  os inputs foram reorganizados para se adequar as limitacoes da DE10 lite, gerando uma nova mascara de bits
    -- os bits variaveis de num1 usam os dois botoes key e os switches 9 a 7
    -- os bits variaveis de num2 usam os switches 6 a 0
    -- uma relevante adaptacao da versao Spartan eh a eliminacao do compartilhamento de inputs entre os numeros, o que elimina a interdependencia original entre os bits de num1 e num2
    sign1 <= '0';
    exp1  <= '1' & (not key(1)) & (not key(0)) & '1'; --como os botoes da DE10 lite sao ativos em nivel baixo, eh necessario inverter os valores de entrada para formar os bits do expoente de num1
    frac1 <= '1' & sw(9 downto 7) & "1101";            

    sign2 <= sw(5);                                    
    exp2  <= '1' & sw(6) & "00";                     
    frac2 <= '1' & sw(4 downto 0) & "10";      

    -- instantiate fp adder
    -- set up the fp adder input signals
    -- ================================
    -- FP Adder
    -- ================================
    -- esse trecho permaneceu inalterado, pois a logica matematica independe do hardware
    -- a logica utiliza apenas sign, exp e frac, independentes da parte fisica da placa
    fp_add_unit : entity work.fp_adder
        port map (
            sign1 => sign1, sign2 => sign2, exp1 => exp1, exp2 => exp2,
            frac1 => frac1, frac2 => frac2,
            sign_out => sign_out, exp_out => exp_out,
            frac_out => frac_out
        );

    -- set up the fp adder input signals
    -- ================================
    -- Adaptacao dos displays
    -- ================================
    -- uma diferenca significativa entre as versoes pode ser observada aqui
    -- a DE10 lite possui seis displays de sete segmentos individualmente controlados
    -- nao eh mais necessario utilizar clock, anodo ou a multiplexacao de disp_mux.vhd, como exigia a arquitetura original da Spartan 3
    -- alem disso, os displays hex1, hex4 e hex5 possuem a atribuicao da sequencia que ativa o digito desejado de forma direta no codigo
    -- os dois displays adicionais, que representam explicitamente E e 0., melhoram a apresentacao visual do resultado, sem alterar as informacoes numericas exibidas em relacao a arquitetura original
    -- os valores numericos que resultam de fp_adder ainda usam hex_to_sseg para definir a sequencia de bits que deve ir para o display, mas os caracteres fixos ou condicionais sao definidos diretamente, como ja mencionado
    -- o codigo de hex_to_sseg foi alterado para se adequar a logica de ativo em nivel baixo da DE10 lite

    -- instantiate three instances of hex decoders
    -- exponent -> HEX0
    sseg_unit_0 : entity work.hex_to_sseg
        port map (hex => exp_out, dp => '1', sseg => hex0);

	 hex1 <= "10000110"; --caractere E
		  
    -- 4 LSBs of fraction
    sseg_unit_1 : entity work.hex_to_sseg
        port map (hex => frac_out(3 downto 0), dp => '1', sseg => hex2);

    -- 4 MSBs of fraction -> HEX3
    sseg_unit_2 : entity work.hex_to_sseg
        port map (hex => frac_out(7 downto 4), dp => '1', sseg => hex3);

	 hex4 <= "01000000"; --zero com o ponto
	
    -- quando sign eh 1, ou seja, o valor eh negativo, o traco deve ser exibido
    -- para isso, uma atribuicao condicional eh utilizada nesse trecho	  
    -- sign 
    hex5 <= "10111111" when sign_out = '1' else --negativo
            "11111111"; -- apagado (positivo)
end arch;
```

A seguir, o código de `hex_to_sseg.vhd`, com o respectivo comentário.

```vhdl
library ieee;
use ieee.std_logic_1164.all;
entity hex_to_sseg is
    port (
        hex: in std_logic_vector(3 downto 0);
        dp: in std_logic;
        sseg: out std_logic_vector(7 downto 0)
    );
end hex_to_sseg;

-- todas as sequencias de sete bits foram adaptadas para contemplar a logica de ativo em nivel baixo da de10 lite
architecture arch of hex_to_sseg is
begin
    with hex select
        sseg(6 downto 0) <=
            "1000000" when "0000",
            "1111001" when "0001",
            "0100100" when "0010",
            "0110000" when "0011",
            "0011001" when "0100",
            "0010010" when "0101",
            "0000010" when "0110",
            "1111000" when "0111",
            "0000000" when "1000",
            "0010000" when "1001",
            "0001000" when "1010", --a
            "0000011" when "1011", --b
            "0100111" when "1100", --c
            "0100001" when "1101", --d
            "0000110" when "1110", --e
            "0001110" when others; --f
    sseg(7) <= dp;
end arch;
```

---

*Etapa 3*

### Funcionamento na Placa

O vídeo explicativo do funcionamento da placa com um exemplo está disponível nos seguintes endereços:

- **YouTube:** https://youtu.be/EKasa-b7qYc

- **Google Drive (proporção original):** https://drive.google.com/file/d/1Y5V62T0NyBKlgANrjc549bCeaxGeJ3ME/view?usp=drive_link

---

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

Para o segundo script de conversão numérica e visualização das possibilidades de números, foi utilizado o prompt:

```
“Crie um script em Python que, recebendo uma máscara de bits na forma 0.1BBBBBBBEXXXX, indique todas as possibilidades de valores. A representação usada é: após o ponto, uma parte fracionária binária de um decimal binário, ‘E’ indica uma potência de base 2 e X representa os bits do expoente. Crie também um script para que, dado um valor qualquer em decimal, seja retornado um valor de mantissa e de expoente de uma potência de base 2, onde a mantissa deve ser sempre menor que 1.”
```

O resultado foi um código funcional e matematicamente correto, o que possibilitou seu uso durante o desenvolvimento do projeto pelo grupo. O uso do script facilitou as conversões de decimal em mantissa + expoente e também no projeto de uma máscara de bits adequada.

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