`timescale 1ns / 1ps

module counter_tb;
    // Parameters
    parameter CLAUSES = 17'h007D0;
    parameter LA_CHUNKS = 17'h00031;
    
    // Testbench signals
    reg clk;
    reg rst_flag;
    reg stop_flag;
    wire [16:0] clause_count;
    wire [16:0] la_chunk_count;
    
    // Instantiate the counter module
    counter #(
        .CLAUSES(CLAUSES),
        .LA_CHUNKS(LA_CHUNKS)
    ) uut (
        .clk(clk),
        .rst_flag(rst_flag),
        .stop_flag(stop_flag),
        .clause_count(clause_count),
        .la_chunk_count(la_chunk_count)
    );

    // ROM parameters
    parameter ROM_DATA_WIDTH = 32; 
    parameter ROM_ADDR_WIDTH = 17;        
    parameter ROM_DEPTH = 98000;       

    // ROM address and data signals
    wire [ROM_ADDR_WIDTH-1:0] rom_addr_ta; 
    wire [ROM_ADDR_WIDTH-1:0] rom_offset_ta;    // Address for TA_STATE_MEM ROM
    wire [ROM_DATA_WIDTH-1:0] rom_data_ta;

    // Instantiate the ROM module
    ROM_1 #(
        .DATA_WIDTH(ROM_DATA_WIDTH),
        .ADDR_WIDTH(ROM_ADDR_WIDTH),
        .ROM_DEPTH(ROM_DEPTH)
    ) TA_STATE_MEM_ROM (
        .addr(rom_addr_ta),
        .offset(rom_offset_ta),
        .data(rom_data_ta)
    );
    
    //Assign wires
    assign rom_addr_ta = clause_count;
    assign rom_offset_ta = la_chunk_count;

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end
    
    // Testbench logic
    initial begin
        // Initialize inputs
        stop_flag = 0;
        //cmp_flag = 0;
        rst_flag = 1; // Assert reset

        // Wait for a few clock cycles
        #20;

        // De-assert reset
        rst_flag = 0;

        // Test case 1: Normal operation
        //cmp_flag = 1; // Enable comparison
        #50;

        // Test case 2: Stop operation
        stop_flag = 1; // Stop reading
        #20;

        // Test case 3: Resume operation
        stop_flag = 0; // Resume reading
        #50;

        // Test case 4: Reset during operation
        rst_flag = 1; // Assert reset
        #10;
        rst_flag = 0; // De-assert reset
        #50;

        // End simulation
        $stop;
    end
    
    // Monitor output
    initial begin
        $monitor("Time=%0t | clause_count=%h | la_chunk_count=%h | TA_state=%b ", $time, clause_count, la_chunk_count, rom_data_ta);
    end
    
endmodule
