# Python script to generate the always block for ROM initialization from a binary .mem file

# Parameters
DATA_WIDTH = 32  # Bit-width of each entry
ADDR_WIDTH = 17  # Address width (2^ADDR_WIDTH = number of entries)
ROM_DEPTH = 2**ADDR_WIDTH - 33072  # Number of entries (1024 for ADDR_WIDTH = 10)
MEM_FILE = "TM_states\\input_number_2.mem"  # Input file containing binary ROM values
OUTPUT_FILE = "rom_always_block_in.v"  # Output Verilog file


# Function to read binary ROM values from .mem file
def read_mem_file(file_path):
    with open(file_path, "r") as f:
        lines = f.readlines()
    # Remove comments and whitespace, and keep only valid lines
    data = [
        line.split("//")[0].strip()
        for line in lines
        if line.strip() and not line.strip().startswith("//")
    ]
    return data


# Function to generate the always block
def generate_always_block(data, output_file):
    with open(output_file, "w") as f:
        f.write("    // ROM Initialization\n")
        f.write("    always @(*) begin\n")
        f.write("        case (addr)\n")

        # Generate case statements for all addresses
        for addr in range(ROM_DEPTH):
            if addr < len(data):
                # Use the binary value from the .mem file
                binary_value = data[addr]
                # Ensure the binary value has the correct width
                if len(binary_value) != DATA_WIDTH:
                    raise ValueError(
                        f"Binary value at address {addr} has incorrect width: {binary_value}"
                    )
            else:
                # Default value for unused addresses (binary 0)
                binary_value = "0" * DATA_WIDTH
            f.write(
                f"            {ADDR_WIDTH}'h{addr:05X}: data = {DATA_WIDTH}'b{binary_value};\n"
            )

        # Add the default case
        f.write(f"            default: data = {DATA_WIDTH}'b{'0' * DATA_WIDTH};\n")
        f.write("        endcase\n")
        f.write("    end\n")


# Main script
if __name__ == "__main__":
    # Read ROM values from .mem file

    for file_num in range(1, 11):

        rom_data = read_mem_file(f"TM_states\\ta_state_final_{file_num}.mem")

        # Generate the always block
        generate_always_block(rom_data, f"rom_always_block_{file_num}.v")
        print(f"Always block generated and saved to rom_always_block_{file_num}.v")

    # rom_data = read_mem_file(MEM_FILE)
    # generate_always_block(rom_data, OUTPUT_FILE)
    # print(f"Always block generated and saved to {OUTPUT_FILE}")
