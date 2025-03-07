module ROM_XIN_3 #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 6,
    parameter ROM_DEPTH  = 49
) (
    input  wire [ADDR_WIDTH-1:0] addr,
    output reg [DATA_WIDTH-1:0] data
);
    // Define the ROM memory array
    reg [DATA_WIDTH-1:0] rom [0:ROM_DEPTH-1];

    // ROM Initialization
    always @(*) begin
        data = rom[addr];
    end


endmodule