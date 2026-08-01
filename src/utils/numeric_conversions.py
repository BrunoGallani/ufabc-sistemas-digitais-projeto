############# FUNÇÕES AUXILIARES #############

####### 1. Normalização de número binário e hexadecimal
def transforma_representacao_hex(hex_representation):
    letters_to_upper = ['a', 'c', 'e', 'f']

    new_hex_representation = ""
    for i in range(len(hex_representation)):
        letter = hex_representation[i]
        if letter in letters_to_upper:
            new_hex_representation += letter.upper()
        else:
            new_hex_representation += letter
    
    hex_representation = new_hex_representation

    return hex_representation

def normalize_bin_number(bin_number: str) -> str:

    if(len(bin_number) < 4):
        bin_number = (4 - len(bin_number)) * '0' + bin_number
        
    return bin_number

####### 2. Strings de representação dos números

def get_cabecalho_string(number, tipo):

    if is_fpga_number(number):
        number = transforma_representacao_hex(number)

    return f"------------ TIPOS DE REPRESENTAÇÃO DO NÚMERO '{number}' ({tipo}) ------------\n\n"

def get_string_fpga_number(fpga_number: str) -> str:
    text = get_cabecalho_string(fpga_number, "formato display fpga")
    text += f"* Decimal: {fpga_number_para_decimal(fpga_number)}\n\n"
    text += f"* Ponto flutuante (13 bits): {fpga_number_para_13bits(fpga_number)}\n\n"
    text += f"* Representação no display da placa FPGA: {transforma_representacao_hex(fpga_number)}"

    return text

def get_string_decimal_number(decimal_number) -> str:
    text = get_cabecalho_string(decimal_number, "decimal")
    text += f"* Decimal: {decimal_number}\n\n"
    text += f"* Ponto flutuante (13 bits): {decimal_para_13bits(decimal_number)}\n\n"
    text += f"* Representação no display da placa FPGA: {decimal_para_fpga_number(decimal_number)}"

    return text

def get_string_bits13_number(bits) -> str:
    text = get_cabecalho_string(bits, "13 bits")
    text += f"* Decimal: {bits13_para_decimal(bits)}\n\n"
    text += f"* Ponto flutuante (13 bits): {bits}\n\n"
    text += f"* Representação no display da placa FPGA: {bits13_para_fpga_number(bits)}"

    return text

######## 3. Validação de tipos

def is_fpga_number(number: str) -> bool:
    
    try:
        fpga_number_para_decimal(number)
        return True
    except:
        return False

def is_decimal_number(number) -> bool:
    try:
        float(number)
        return True
    except (ValueError, TypeError):
        return False

def is_bits13_number(number: str) -> bool:
    
    try:
        bits13_para_decimal(number)
        return True
    except:
        return False

############# CONVERSÕES NUMÉRICAS #############

####### 1. Decimal <-> 13 bits

def decimal_para_13bits(valor):
    """Converte decimal para binário usando mantissa fracionária (potências de 2 negativas)."""
    if valor == 0:
        return "0000000000000"

    sinal = "1" if valor < 0 else "0"
    valor_absoluto = abs(valor)

    melhor_mantissa = 0
    melhor_expoente = 0
    menor_erro = float('inf')

    # Testa todos os expoentes (0 a 15)
    for e in range(16):
        # A fórmula é: valor = (m / 256) * (2 ** e)
        # Isolando 'm': m = (valor * 256) / (2 ** e)
        m_calculado = (valor_absoluto * 256) / (2 ** e)
        m_arredondado = int(round(m_calculado))

        # A mantissa em inteiro continua precisando caber em 8 bits (0 a 255)
        if 0 <= m_arredondado <= 255:
            valor_reconstruido = (m_arredondado / 256.0) * (2 ** e)
            erro = abs(valor_absoluto - valor_reconstruido)

            # Prioriza a menor perda de precisão
            if erro < menor_erro:
                menor_erro = erro
                melhor_mantissa = m_arredondado
                melhor_expoente = e

    if menor_erro == float('inf'):
        raise ValueError(f"O valor {valor} está fora dos limites de hardware.")

    bin_mantissa = f"{melhor_mantissa:08b}"
    bin_expoente = f"{melhor_expoente:04b}"

    return sinal + bin_mantissa + bin_expoente

def bits13_para_decimal(bits):
    """Converte a string binária de 13 bits para número decimal usando soma de frações."""
    bits = bits.replace(" ", "")

    if len(bits) != 13:
        raise ValueError("A string binária deve conter exatamente 13 bits.")

    bit_sinal = bits[0]
    bits_mantissa = bits[1:9]
    bits_expoente = bits[9:13]

    sinal = -1 if bit_sinal == "1" else 1
    expoente = int(bits_expoente, 2)

    # Nova lógica da mantissa: somando os bits como frações
    mantissa_fracionaria = 0.0
    for i, bit in enumerate(bits_mantissa):
        if bit == '1':
            # i começa em 0, então i+1 faz os expoentes serem -1, -2, -3...
            mantissa_fracionaria += 2 ** -(i + 1)

    # Aplicação da nova fórmula
    valor = sinal * mantissa_fracionaria * (2 ** expoente)
    return valor

####### 2. 13 bits <-> Display FPGA

def bits13_para_fpga_number(bits: str) -> str:
    
    fpga_representation = ''
    signal = bits[0]
    if signal == '1': # número negativo
        fpga_representation += '-'

    fpga_representation += '0.'

    mantissa = bits[1:9]
    
    mantissa_first_slice = mantissa[:4]
    mantissa_second_slice = mantissa[4:]

    fpga_representation += hex(int(mantissa_first_slice, 2))[2:]
    fpga_representation += hex(int(mantissa_second_slice, 2))[2:]

    expoente = bits[9:13]

    fpga_representation += 'E'
    fpga_representation += hex(int(expoente, 2))[2:]

    fpga_representation = transforma_representacao_hex(fpga_representation)

    return fpga_representation

def fpga_number_para_13bits(fpga_number: str) -> str:

    # Normaliza
    fpga_number = transforma_representacao_hex(fpga_number)

    bits13_representation = ''

    signal = '1' if '-' in fpga_number.split(".")[0] else '0'

    bits13_representation += signal

    number = fpga_number.split(".")[1].split("E")[0]

    for bit in number:
        bits13_representation += normalize_bin_number(bin(int(bit, 16))[2:])
    
    exp = normalize_bin_number(
        bin(int(fpga_number.split(".")[1].split("E")[1], 16))[2:]
    )

    bits13_representation += exp

    return bits13_representation

####### 3. Decimal <-> Display FPGA

def fpga_number_para_decimal(fpga_number: str) -> float:

    fpga_number = transforma_representacao_hex(fpga_number)

    bits13_number = fpga_number_para_13bits(fpga_number)

    decimal_number = bits13_para_decimal(bits13_number)

    return decimal_number

def decimal_para_fpga_number(decimal_number: float) -> str:

    bits13_number = decimal_para_13bits(decimal_number)

    fpga_number = bits13_para_fpga_number(bits13_number)

    return fpga_number

############# ORQUESTRAÇÃO #############

def obtem_representacoes_numericas(numero = ""):

    if not numero:
        numero = input("Digite um número: ")
        
        print()

        valid_number = is_fpga_number(numero) or is_bits13_number(numero) or is_decimal_number(numero)
        while not valid_number:
            numero = input("Digite um número válido: ")
            print()
            valid_number = is_fpga_number(numero) or is_bits13_number(numero) or is_decimal_number(numero)

        if is_decimal_number(numero):
            numero = float(numero)

    if is_fpga_number(numero):
        print(get_string_fpga_number(numero))

    elif is_bits13_number(numero):
        print(get_string_bits13_number(numero))

    elif is_decimal_number(numero):
        print(get_string_decimal_number(numero))

    else:
        raise ValueError(f"O valor {numero} possui uma representação inválida."

                        "\n\nSão formas aceitas:"

                        "\n\n- 13 bits;"

                        "\n- Número decimal (inteiro ou não)"

                        "\n- Representação hexadecimal do display da placa FPGA DE10 Lite.")
        
############# EXECUÇÃO E TESTES #############

def main(number = ""):
    obtem_representacoes_numericas(number)

if __name__ == '__main__':
    # Definir dentro da função main o número hardcoded, ou inputar
    main()