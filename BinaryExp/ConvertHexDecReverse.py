import argparse

def hex_to_reversed_hex(hex_value):
    decimal_value = int(hex_value, 16)
    reversed_decimal_value = decimal_value ^ 0xFFFFFFFF
    reversed_hex_value = hex(reversed_decimal_value + 1)[2:].upper()
    return "0x" + reversed_hex_value.zfill(8)

def decimal_to_hex(decimal_value):
    hex_value = hex(decimal_value & 0xFFFFFFFF)[2:].upper()
    return "0x" + hex_value.zfill(8)

parser = argparse.ArgumentParser(description="Hexadecimal and decimal conversion")

group = parser.add_mutually_exclusive_group(required=True)
group.add_argument("--hex", type=str, help="Hexadecimal input")
group.add_argument("--dec", type=int, help="Decimal input")

args = parser.parse_args()

if args.hex:
    hex_input = args.hex
    decimal_output = int(hex_input, 16)
    reversed_hex_output = hex_to_reversed_hex(hex_input)

    print(f"Hex {hex_input} to decimal: {decimal_output}")
    print(f"Hex {hex_input} to reversed hex: {reversed_hex_output}")
else:
    decimal_input = args.dec
    hex_output = decimal_to_hex(decimal_input)

    print(f"Decimal {decimal_input} to hex: {hex_output}")
