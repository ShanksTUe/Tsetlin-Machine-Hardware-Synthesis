module TM_pipeline #(
    parameter CLAUSES = 2000,
    parameter LA_CHUNKS = 49,
    parameter FILTER = 32'hFFFFFFFF,
    parameter CLAUSE_CHUNKS = 63,
    parameter INT_SIZE = 32
)(
    input clk,
    input rst_flag,
    input stop_flag,
    input [31:0] ta_state,
    input [31:0] xin,
    input [16:0] clause_count,
    input [16:0] la_chunk_count,
    output done,
    output signed [31:0] class_sum_th
);

// Internal wires to connect modules
wire [18:0] CMP_OUT_Reg;
wire [31:0] clause_chunk_id;
wire [31:0] clause_pos_id;
wire [5:0]  clause_addr_reg;
wire [5:0]  clause_chunk_count;
wire [31:0] clause_chunk_data;
wire signed [31:0] class_sum;
wire signed [31:0] class_sum_thrd;

// Internal wires from controllers
wire stop_class_sum, stop_compare_states, stop_clause_out, stop_class_sum_th;
wire reset_all, write_mode, read_mode;
wire done_flag;

//Instantiate compare_states module to compare ta_states and x_in
compare_states #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER)
) COMPARE_STATES_1(
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_compare_states),
    .ta_state(ta_state),
    .xin(xin),
    .clause_id(clause_count),
    .la_chunk_id(la_chunk_count),
    .CMP_OUT_Reg(CMP_OUT_Reg)
);

//Instantiate clause_output module to calculate the output clause values
clause_output #(
    .INT_SIZE(INT_SIZE),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS)
) CLAUSE_OUT_CALC_1(
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_clause_out),
    .CMP_OUT_Reg(CMP_OUT_Reg),
    .clause_chunk(clause_chunk_id),
    .clause_pos(clause_pos_id)
);

//Store the output clauses in a register bank
clause_out_regbank #(
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .REG_WIDTH(INT_SIZE)
) CLAUSE_OUT_MEM_1(
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag_1(stop_clause_out),
    .stop_flag_2(stop_class_sum),
    .clause_chunk(clause_chunk_id),
    .clause_pos(clause_pos_id),
    .write_mode(write_mode),
    .read_mode(read_mode),
    .read_addr(clause_addr_reg),
    .output_clause(clause_chunk_data)
);

//Instantiate class_sum module to calculate the sum for respective class
class_sum SUM_CALC_1(
    .clk(clk),
    .stop_flag(stop_class_sum),
    .rst_flag(rst_flag),
    .clause_output(clause_chunk_data),
    .class_sum(class_sum)
);

//Instantiate the class_sum_th for thresholding the class sum
class_sum_th SUM_THRESHOLD_1 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_class_sum_th),
    .class_sum_in(class_sum),
    .class_sum_out(class_sum_thrd)
);

//Instantiate a counter to access clauses from register bank
clause_counter #(
    .VALUE(CLAUSE_CHUNKS)
) COUNT(
    .clk(clk),
    .stop_flag(stop_class_sum),
    .rst_flag(rst_flag),
    .count(clause_chunk_count)
);

// Output of clause_chunk counter to calculate clause_chunk address
assign clause_addr_reg = clause_chunk_count;

TM_controller #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS)
) Controller (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_flag),
    .clause_id(clause_count),
    .la_chunk_id(la_chunk_count),
    .clause_chunk_id(clause_chunk_count),
    .compare_states_ctrl(stop_compare_states),
    .clause_out_ctrl(stop_clause_out),
    .class_sum_ctrl(stop_class_sum),
    .class_sum_th_ctrl(stop_class_sum_th),
    .reset_all(reset_all),
    .write_mode(write_mode),
    .read_mode(read_mode),
    .done_flag(done_flag)
);


//Indicate the TM pipeline has finished
assign done = done_flag;
assign class_sum_th = class_sum_thrd;

endmodule