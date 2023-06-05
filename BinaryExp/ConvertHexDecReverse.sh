#!/bin/sh

hex_to_reversed_hex() {
    decimal_value=$(printf "%d" "$(( 16#${1} ))")
    reversed_decimal_value=$(printf "%d" "$(( decimal_value ^ 0xFFFFFFFF ))")
    reversed_hex_value=$( printf "0x%08X" "$(( reversed_decimal_value + 1 ))" )
    echo "$reversed_hex_value"
}

decimal_to_hex() {
    hex_value=$( printf "0x%08X" "$(( $1 & 0xFFFFFFFF ))" )
    echo "$hex_value"
}

# Display help message
show_help() {
    echo "Usage: ./ConvertHexDecReverse.sh [OPTIONS]"
    echo "Convert hexadecimal and decimal values"
    echo ""
    echo "Options:"
    echo "  --hex HEX_VALUE    Convert hexadecimal value to decimal and reversed hex"
    echo "  --dec DEC_VALUE    Convert decimal value to hex"
}

# Parse command-line arguments
if [ $# -eq 0 ]; then
    show_help
    exit 1
fi

while [ $# -gt 0 ]; do
    key="$1"

    case $key in
        --hex)
            hex_input="$2"
            decimal_output=$(printf "%d" "$(( 16#${hex_input} ))")
            reversed_hex_output=$(hex_to_reversed_hex "$hex_input")

            echo "Hex $hex_input to decimal: $decimal_output"
            echo "Hex $hex_input to reversed hex: $reversed_hex_output"

            shift
            shift
            ;;
        --dec)
            decimal_input="$2"
            hex_output=$(decimal_to_hex "$decimal_input")

            echo "Decimal $decimal_input to hex: $hex_output"

            shift
            shift
            ;;
        --help|-h)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $key"
            exit 1
            ;;
    esac
done
