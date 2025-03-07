`timescale 1ns / 1ps


module xin_rom_tb;

parameter DATA_WIDTH = 32;
parameter ADDR_WIDTH = 6;
parameter ROM_DEPTH = 49;

reg [5:0] rom_addr_count;

wire [5:0] rom_addr;
wire [31:0] rom_data;
reg rst_flag;
reg clk;

initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

initial begin

    $readmemb("D:\\Internship\\verilog\\TM_states\\input_number_3.mem", XIN_ROM.rom);

    rst_flag = 1;
    #10 rst_flag = 0;

    $monitor("Time: %0t | rom data: %b |",
    $time, rom_data);

    wait(rom_addr_count == 6'h30);

    $finish;

end

always @(posedge clk) begin
    if (rst_flag) begin
        rom_addr_count <= 6'h00;
    end else if (rom_addr < 6'h31) begin
        rom_addr_count <= rom_addr_count + 1;
    end
end

assign rom_addr = rom_addr_count;

ROM_XIN_3 #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .ROM_DEPTH(ROM_DEPTH)
) XIN_ROM (
    .addr(rom_addr),
    .data(rom_data)
);

endmodule