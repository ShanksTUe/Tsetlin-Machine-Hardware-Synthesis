module compare_states #(
    parameter CLAUSES = 2000,
    parameter LA_CHUNKS = 49,
    parameter FILTER = 32'hFFFFFFFF
)(
    input [31:0] ta_state,
    input [31:0] xin,
    input [16:0] clause_id,
    input [16:0] la_chunk_id,
    input clk,
    input rst_flag,
    input stop_flag,
    output reg [18:0] CMP_OUT_Reg //Output Register between CMP stage and OUT stage
);

//Internal registers
reg output_val;
reg all_exclude_val;

//Always block for comparisons
always @(posedge clk or posedge rst_flag) begin
    if (rst_flag) begin
        output_val <= 1'b1;
        all_exclude_val <= 1'b1;
        CMP_OUT_Reg <= 19'b0;
    
    end else if (!stop_flag) begin        
        // Perform comparisons
        if (la_chunk_id == 17'h00000) begin
            output_val <= (1'b1 && ((ta_state & xin) == (ta_state)));
            all_exclude_val <= (1'b1 && ((ta_state & xin) == 32'h00000000));
        end else if (la_chunk_id == LA_CHUNKS-1) begin
            output_val <=  (output_val && ((ta_state & xin & FILTER) == (ta_state & FILTER)));
            all_exclude_val <= (all_exclude_val && ((ta_state & xin & FILTER) == 32'h00000000));
        end else begin
            output_val <=  (output_val && ((ta_state & xin) == (ta_state)));
            all_exclude_val <= (all_exclude_val && ((ta_state & xin) == 32'h00000000));
        end
        
        // Store the comparator outputs in CMP_OUT_Reg
        CMP_OUT_Reg[0] <= all_exclude_val; //Assign output values
        CMP_OUT_Reg[1] <= output_val;
        CMP_OUT_Reg[18:2] <= clause_id;
    end
end


endmodule