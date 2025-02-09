module read_mem #(
    parameter CLAUSES = 2000,
    parameter LA_CHUNKS = 49
) (
    input stop_flag,
    input rst_flag,
    input clk,
    output reg [65:0] READ_CMP_Reg, // Output Register between read_mem stage and cmp_stage
    // output reg [48:0] debug_rom_data_ta
    // output reg [16:0] debug_clause_count
    output reg read_mem_flag
);

    wire [16:0] clause_count;
    wire [16:0] la_chunk_count;

    // ROM parameters
    parameter ROM_DATA_WIDTH = 32; 
    parameter ROM_ADDR_WIDTH = 17;        
    parameter ROM_DEPTH = 98000;       

    // ROM address and data signals
    wire [ROM_ADDR_WIDTH-1:0] rom_addr_ta; 
    wire [ROM_ADDR_WIDTH-1:0] rom_offset_ta;    // Address for TA_STATE_MEM ROM
    wire [ROM_DATA_WIDTH-1:0] rom_data_ta;     // Data from TA_STATE_MEM ROM

    // Instantiate TA_STATE_MEM ROM
    ROM_1 #(
        .DATA_WIDTH(ROM_DATA_WIDTH),
        .ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DEPTH(ROM_DEPTH)
    ) TA_STATE_MEM_ROM (
        .addr(rom_addr_ta),
        .offset(rom_offset_ta),
        .data(rom_data_ta)
    );

    // Instantiate counter
    ta_state_counter #(
        .CLAUSES(CLAUSES),
        .LA_CHUNKS(LA_CHUNKS)
    ) TA_STATE_COUNTER (
        .clk(clk), 
        .rst_flag(rst_flag),
        .stop_flag(stop_flag),
        .clause_count(clause_count),
        .la_chunk_count(la_chunk_count)
    );

    // Assign ROM addresses
    assign rom_addr_ta = clause_count;     // Address for TA_STATE_MEM ROM
    assign rom_offset_ta = la_chunk_count;  

    // Always block for reading memory
    always @(posedge clk or posedge rst_flag) begin
        if (rst_flag) begin
            READ_CMP_Reg <= 66'h00000000000000000;
            read_mem_flag <= 1'b0;
        end else if (!stop_flag) begin
            READ_CMP_Reg[65:34] <= rom_data_ta;
            READ_CMP_Reg[33:17] <= clause_count;
            READ_CMP_Reg[16:0] <= la_chunk_count;
            read_mem_flag <= 1'b1;    
        end else if (stop_flag) begin
            read_mem_flag <= 1'b0;
        end
    end
// always @(posedge clk) begin
//     debug_rom_data_ta <= (rom_data_ta << 17) | clause_count;
//     debug_clause_count <= clause_count;
// end

endmodule