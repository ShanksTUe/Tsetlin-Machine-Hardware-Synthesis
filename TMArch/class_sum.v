module class_sum (
    input clk,               
    input rst_flag,
    input stop_flag,               
    input [31:0] clause_output, // Input clause_output
    output reg signed [31:0] class_sum // Output class_sum (signed)
);

    // Constants for bitwise AND operations
    localparam [31:0] MASK_ODD  = 32'h55555555; // 
    localparam [31:0] MASK_EVEN = 32'hAAAAAAAA; //

    // Temporary signals for intermediate results
    wire [31:0] odd_bits;
    wire [31:0] even_bits;
    wire [5:0] odd_count;
    wire [5:0] even_count;


    assign odd_bits  = clause_output & MASK_ODD;  // Extract odd-positioned bits
    assign even_bits = clause_output & MASK_EVEN; // Extract even-positioned bits

    assign odd_count = popcount(odd_bits);
    assign even_count = popcount(even_bits);
    // Update class_sum
    always @(posedge clk or posedge rst_flag) begin
        if (rst_flag) begin
            // Reset class_sum
            class_sum <= 32'h00000000;
        end else if (!stop_flag) begin
            // Add odd-positioned bits and subtract even-positioned bits
            class_sum <= class_sum + odd_count - even_count;
        end
    end

    // Optimized population count function
    function [5:0] popcount;
        input signed [31:0] data;
        begin
            popcount = data[0] + data[1] + data[2] + data[3] + data[4] + data[5] + data[6] + data[7] +
                       data[8] + data[9] + data[10] + data[11] + data[12] + data[13] + data[14] + data[15] +
                       data[16] + data[17] + data[18] + data[19] + data[20] + data[21] + data[22] + data[23] +
                       data[24] + data[25] + data[26] + data[27] + data[28] + data[29] + data[30] + data[31];
        end
    endfunction

endmodule