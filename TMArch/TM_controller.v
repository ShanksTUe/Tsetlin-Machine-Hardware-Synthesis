module TM_controller #(
    parameter CLAUSES = 2000,
    parameter LA_CHUNKS = 49,
    parameter CLAUSE_CHUNKS = 63
)(
    input clk,
    input rst_flag,
    input stop_flag,
    input [16:0] clause_id,
    input [16:0] la_chunk_id,
    input [5:0] clause_chunk_id,
    output reg compare_states_ctrl,
    output reg clause_out_ctrl,
    output reg class_sum_ctrl,
    output reg class_sum_th_ctrl,
    output reg write_mode,
    output reg read_mode,
    output reg reset_all,
    output reg done_flag
);

parameter S0 = 3'b000, S1 = 3'b001, S2 = 3'b010, S3 = 3'b011, S4 = 3'b100, S5 = 3'b101, S6 = 3'b110, S7 = 3'b111;
reg [2:0] state;

always @(posedge clk) begin

    case(state)
        S0: if (!stop_flag) begin
            state <= S1;
        end
        S1: if (la_chunk_id == LA_CHUNKS-1) begin
                if (clause_id == CLAUSES-1) begin
                    state <= S3;
                end
                else begin 
                    state <= S2;
                end
        end else begin
            state <= S1;
        end
        S2: state <= S1;
        S3: state <= S4;
        S4: state <= S5;
        S5: if (clause_chunk_id == CLAUSE_CHUNKS-1) begin 
            state <= S6;
        end else begin
            state <= S5;
        end
        S6: state <= S7;
        S7: if (rst_flag) begin
            state <= S0;
        end else begin
            state <= S7;
        end
        default: state <= S0;
    endcase
end

always @(state) begin

    case(state)
        S0: begin
            compare_states_ctrl = 1'b1;
            clause_out_ctrl = 1'b1;
            class_sum_ctrl = 1'b1;
            class_sum_th_ctrl = 1'b1;
            write_mode = 1'b1;
            done_flag = 1'b0;
        end
        S1: begin
            compare_states_ctrl = 1'b0;
            clause_out_ctrl = 1'b1;
        end
        S2: begin
            clause_out_ctrl = 1'b0; 
        end
        S3: begin
            compare_states_ctrl = 1'b1;
            clause_out_ctrl = 1'b0; 
        end
        S4: begin
            clause_out_ctrl = 1'b1;
            write_mode = 1'b0;
            read_mode = 1'b1;
        end
        S5: begin
            class_sum_ctrl = 1'b0;
            class_sum_th_ctrl = 1'b1; 
        end
        S6: begin
            class_sum_ctrl = 1'b1;
            class_sum_th_ctrl = 1'b0;
        end
        S7: begin
            class_sum_th_ctrl = 1'b1;
            read_mode = 1'b0;
            done_flag = 1'b1;

        end
        default : begin
            compare_states_ctrl = 1'b1;
            clause_out_ctrl = 1'b1;
            class_sum_ctrl = 1'b1;
            class_sum_th_ctrl = 1'b1;
            read_mode = 1'b0;
            write_mode = 1'b0;
            done_flag = 1'b0;
        end
    endcase
end


endmodule