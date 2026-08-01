def check_bounds():

    # Mantissa mínima
    min_mantissa = 2 ** -1

    # Mantissa máxima
    max_mantissa = 0
    for i in range(1, 9):
        max_mantissa += 2 ** -i

    # Número mínimo
    min_number = min_mantissa

    # Número máximo
    max_number = int(max_mantissa * (2 ** 15))
    
    print(
        "------- LIMITES -------"
        f"\n\n* Mantissa mínima: {min_mantissa}"
        f"\n* Mantissa máxima: {max_mantissa}"
        f"\n\n* Número mínimo: {min_number}"
        f"\n* Número máximo: {max_number}"
    )

check_bounds()