module TM_Classifier #(
    parameter CLAUSES = 2000,
    parameter LA_CHUNKS = 49,
    parameter FILTER = 32'hFFFFFFFF,
    parameter CLAUSE_CHUNKS = 63,
    parameter INT_SIZE = 32
)(
    input clk,
    input rst_flag,
    output signed [31:0] class_sum_1,
    output signed [31:0] class_sum_2,
    output signed [31:0] class_sum_3,
    output signed [31:0] class_sum_4,
    output signed [31:0] class_sum_5,
    output signed [31:0] class_sum_6,
    output signed [31:0] class_sum_7,
    output signed [31:0] class_sum_8,
    output signed [31:0] class_sum_9,
    output signed [31:0] class_sum_10,
    output full_done

);

//Internal wires for class_sums
wire signed [31:0] class_sum_th1;
wire signed [31:0] class_sum_th2;
wire signed [31:0] class_sum_th3;
wire signed [31:0] class_sum_th4;
wire signed [31:0] class_sum_th5;
wire signed [31:0] class_sum_th6;
wire signed [31:0] class_sum_th7;
wire signed [31:0] class_sum_th8;
wire signed [31:0] class_sum_th9;
wire signed [31:0] class_sum_th10;

//Internal wires for stop_TMs
wire stop_TM1, stop_TM2, stop_TM3, stop_TM4, stop_TM5, stop_TM6, stop_TM7, stop_TM8, stop_TM9, stop_TM10;
//Internal wires for dones
wire done1, done2, done3, done4, done5, done6, done7, done8, done9, done10;

// ROM parameters
parameter ROM_DATA_WIDTH = 32; 
parameter ROM_ADDR_WIDTH_TA = 17; 
parameter ROM_ADDR_WIDTH_XIN = 6;       
parameter ROM_DEPTH_TA = 98000;       
parameter ROM_DEPTH_XIN = LA_CHUNKS;

//Internal wires for rom_data_tas
wire [ROM_DATA_WIDTH-1:0] rom_data_ta1;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta2;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta3;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta4;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta5;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta6;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta7;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta8;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta9;
wire [ROM_DATA_WIDTH-1:0] rom_data_ta10;

//Internal wires for count signals
wire [16:0] clause_count;
wire [16:0] la_chunk_count;
wire stop_count;

// TA_STATE_MEM_ROMs address and data signals
wire [ROM_ADDR_WIDTH_TA-1:0] rom_addr_ta; 
wire [ROM_ADDR_WIDTH_TA-1:0] rom_offset_ta;    // Address for TA_STATE_MEM ROM

//Internal wires to acces XIN_MEM addresses and data
wire [ROM_ADDR_WIDTH_XIN-1:0] rom_addr_xin; //Address for XIN_MEM_ROM
wire [ROM_DATA_WIDTH-1:0] rom_data_xin;    //Data from XIN_MEM_ROM


// Instantiate X_IN_ROM
ROM_XIN_3 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_XIN),
    .ROM_DEPTH(ROM_DEPTH_XIN)
) XIN_MEM_ROM (
    .addr(rom_addr_xin),
    .data(rom_data_xin)
);


// Instantiate counter
ta_state_counter #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS)
) TA_STATE_COUNTER (
    .clk(clk), 
    .rst_flag(rst_flag),
    .stop_flag(stop_count),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count)
);
// Assign ROM addresses
assign rom_addr_ta = clause_count;     // Address for TA_STATE_MEM ROM
assign rom_offset_ta = la_chunk_count;
assign rom_addr_xin = la_chunk_count[5:0];

// Instantiate TA_STATE_MEM ROM
ROM_1 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_1 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta1)
);

ROM_2 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_2 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta2)
);

ROM_3 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_3 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta3)
);

ROM_4 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_4 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta4)
);

ROM_5 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_5 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta5)
);

ROM_6 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_6 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta6)
);

ROM_7 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_7 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta7)
);

ROM_8 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_8 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta8)
);

ROM_9 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_9 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta9)
);

ROM_10 #(
    .DATA_WIDTH(ROM_DATA_WIDTH),
    .ADDR_WIDTH(ROM_ADDR_WIDTH_TA),
    .ROM_DEPTH(ROM_DEPTH_TA)
) TA_STATE_MEM_ROM_10 (
    .addr(rom_addr_ta),
    .offset(rom_offset_ta),
    .data(rom_data_ta10)
);


//TM Pipeline instantiations
TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_1 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM1),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta1),
    .xin(rom_data_xin),
    .class_sum_th(class_sum_th1),
    .done(done1)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_2 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM2),
    .class_sum_th(class_sum_th2),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta2),
    .xin(rom_data_xin),
    .done(done2)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_3 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM3),
    .class_sum_th(class_sum_th3),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta3),
    .xin(rom_data_xin),
    .done(done3)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_4 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM4),
    .class_sum_th(class_sum_th4),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta4),
    .xin(rom_data_xin),
    .done(done4)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_5 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM5),
    .class_sum_th(class_sum_th5),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta5),
    .xin(rom_data_xin),
    .done(done5)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_6 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM6),
    .class_sum_th(class_sum_th6),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta6),
    .xin(rom_data_xin),
    .done(done6)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_7 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM7),
    .class_sum_th(class_sum_th7),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta7),
    .xin(rom_data_xin),
    .done(done7)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_8 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM8),
    .class_sum_th(class_sum_th8),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta8),
    .xin(rom_data_xin),
    .done(done8)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_9 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM9),
    .class_sum_th(class_sum_th9),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta9),
    .xin(rom_data_xin),
    .done(done9)
);

TM_pipeline #(
    .CLAUSES(CLAUSES),
    .LA_CHUNKS(LA_CHUNKS),
    .FILTER(FILTER),
    .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
    .INT_SIZE(INT_SIZE)
) TM_10 (
    .clk(clk),
    .rst_flag(rst_flag),
    .stop_flag(stop_TM10),
    .class_sum_th(class_sum_th10),
    .clause_count(clause_count),
    .la_chunk_count(la_chunk_count),
    .ta_state(rom_data_ta10),
    .xin(rom_data_xin),
    .done(done10)
);

//Assign sums from each TM
assign class_sum_1 = class_sum_th1;
assign class_sum_2 = class_sum_th2;
assign class_sum_3 = class_sum_th3;
assign class_sum_4 = class_sum_th4;
assign class_sum_5 = class_sum_th5;
assign class_sum_6 = class_sum_th6;
assign class_sum_7 = class_sum_th7;
assign class_sum_8 = class_sum_th8;
assign class_sum_9 = class_sum_th9;
assign class_sum_10 = class_sum_th10;



//Indicate that the entire Tsetlin machine is done
assign full_done = done1 && done2 && done3 && done4 && done5 && done6 && done7 && done8 && done9 && done10;

//Stop the count and TMs as soon as count reaches the last clause
assign stop_count = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM1 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM2 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM3 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM4 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM5 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM6 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM7 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM8 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM9 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;
assign stop_TM10 = ((clause_count == CLAUSES-1) && (la_chunk_count == LA_CHUNKS-1)) ? 1 : 0;

endmodule
