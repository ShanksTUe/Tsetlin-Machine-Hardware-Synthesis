module clause_output #(
    parameter INT_SIZE = 32,
    parameter CLAUSE_CHUNKS = 63
)(
    input [18:0] CMP_OUT_Reg,
    input clk,
    input rst_flag,
    input stop_flag,
    output reg [31:0] clause_chunk,
    output reg [31:0] clause_pos
);

wire output_flag;
localparam PREDICT = 1'b0;

assign output_flag = (CMP_OUT_Reg[1] && !(PREDICT && (CMP_OUT_Reg[0] == 1'b1)));

always @(posedge clk or posedge rst_flag) begin

    if (rst_flag) begin
        clause_chunk <= 32'h00000000;
        clause_pos <= 32'h00000000;
    end else if (!stop_flag) begin
        if (output_flag) begin
            clause_chunk <= (CMP_OUT_Reg[18:2] >> 5);
            clause_pos <= (CMP_OUT_Reg[18:2] & (INT_SIZE-1));
        end           
    end

end


endmodule