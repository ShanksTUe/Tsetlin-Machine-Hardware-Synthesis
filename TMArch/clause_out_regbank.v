module clause_out_regbank #(
    parameter CLAUSE_CHUNKS = 63,
    parameter REG_WIDTH = 32
)(
    input clk,
    input rst_flag,
    input stop_flag_1,
    input stop_flag_2,
    input write_mode,
    input [31:0] clause_chunk,
    input [31:0] clause_pos,
    input read_mode,
    input [5:0] read_addr, // 6-bit address to address 63 registers
    output reg [31:0] output_clause
);

    integer i;

    // Declare the register bank
    reg [REG_WIDTH-1:0] clause_registers [0:CLAUSE_CHUNKS-1];

    // Write operation
    always @(posedge clk or posedge rst_flag) begin
        if (rst_flag) begin
                // Reset all registers to 0
                
                for (i = 0; i < CLAUSE_CHUNKS; i = i + 1) begin
                    clause_registers[i] <= {REG_WIDTH{1'b0}};
                end
        end else if (!stop_flag_1) begin
                if (write_mode) begin
                // Write (1 << clause_pos) to the register at address clause_chunk
                if (clause_chunk < CLAUSE_CHUNKS) begin
                    clause_registers[clause_chunk] <= (clause_registers[clause_chunk] | (1 << clause_pos));
                end
            end
        end
    end

    // Read operation
    always @(posedge clk or posedge rst_flag) begin
        if (rst_flag) begin
            output_clause <= {REG_WIDTH{1'b0}};
        end else if (!stop_flag_2) begin
                if (read_mode) begin
                    // Output the data from the register at read_addr
                    if (read_addr < CLAUSE_CHUNKS) begin
                        output_clause <= clause_registers[read_addr];
                    end else begin
                        output_clause <= {REG_WIDTH{1'b0}}; // Default to 0 if address is out of range
                    end
                end
            end
    end

endmodule