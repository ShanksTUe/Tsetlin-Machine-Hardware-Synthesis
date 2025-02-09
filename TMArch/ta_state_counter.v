module ta_state_counter #(
    parameter CLAUSES = 17'h0000A,
    parameter LA_CHUNKS = 17'h0000A
)(
    input clk,
    input rst_flag,
    input stop_flag,
    output reg [16:0] clause_count,
    output reg [16:0] la_chunk_count
);

always @(posedge clk or posedge rst_flag) begin
    if (rst_flag) begin
        // Reset both counters
        clause_count <= 17'h00000;
        la_chunk_count <= 17'h00000;
    end else if (!stop_flag) begin
        if (clause_count < CLAUSES) begin
            if (la_chunk_count == LA_CHUNKS-1) begin
                // Reset la_chunk_count and increment clause_count
                la_chunk_count <= 17'h00000;
                clause_count <= clause_count + 1;
            end else begin
                // Increment la_chunk_count
                la_chunk_count <= la_chunk_count + 1;
            end
        end else begin
            // Reset both counters when clause_count reaches CLAUSES
            clause_count <= 17'h00000;
            la_chunk_count <= 17'h00000;
        end
    end
end

endmodule