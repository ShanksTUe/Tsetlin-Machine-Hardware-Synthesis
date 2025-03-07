`timescale 1ns / 1ps

module TM_Classifier_tb;

    // Parameters
    parameter CLAUSES = 2000;
    parameter LA_CHUNKS = 49;
    parameter FILTER = 32'hFFFFFFFF;
    parameter CLAUSE_CHUNKS = 63;
    parameter INT_SIZE = 32;

    // Inputs
    reg clk;
    reg rst_flag;
    reg stop_flag;
    
    // Outputs
    wire signed [31:0] class_sum_1;
    wire signed [31:0] class_sum_2;
    wire signed [31:0] class_sum_3;
    wire signed [31:0] class_sum_4;
    wire signed [31:0] class_sum_5;
    wire signed [31:0] class_sum_6;
    wire signed [31:0] class_sum_7;
    wire signed [31:0] class_sum_8;
    wire signed [31:0] class_sum_9;
    wire signed [31:0] class_sum_10;
    wire full_done;

    // Instantiate the TM_pipeline module
    TM_Classifier #(
        .CLAUSES(CLAUSES),
        .LA_CHUNKS(LA_CHUNKS),
        .FILTER(FILTER),
        .CLAUSE_CHUNKS(CLAUSE_CHUNKS),
        .INT_SIZE(INT_SIZE)
    ) DUT (
        .clk(clk),
        .rst_flag(rst_flag),
        .class_sum_1(class_sum_1),
        .class_sum_2(class_sum_2),
        .class_sum_3(class_sum_3),
        .class_sum_4(class_sum_4),
        .class_sum_5(class_sum_5),
        .class_sum_6(class_sum_6),
        .class_sum_7(class_sum_7),
        .class_sum_8(class_sum_8),
        .class_sum_9(class_sum_9),
        .class_sum_10(class_sum_10),
        .full_done(full_done)
    );

     // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test procedure
    initial begin

        //Read the input memory data
        $readmemb("D:\\Internship\\verilog\\TM_states\\input_number_3.mem", DUT.XIN_MEM_ROM.rom);
  
        // Initialize signals
        rst_flag = 1;

        // Apply reset
        #20 rst_flag = 0;
        
        // Run the simulation for a while
        wait(full_done == 1'b1);
        
        $display({"Time: %0t | class_sum_0: %d | ", 
          "class_sum_1: %d | ", 
          "class_sum_2: %d | ", 
          "class_sum_3: %d | ", 
          "class_sum_4: %d | ", 
          "class_sum_5: %d | ", 
          "class_sum_6: %d | ", 
          "class_sum_7: %d | ", 
          "class_sum_8: %d | ", 
          "class_sum_9: %d |"}, 
          $time, class_sum_1, class_sum_2, class_sum_3, class_sum_4, class_sum_5, class_sum_6, class_sum_7, class_sum_8, class_sum_9, class_sum_10);
        
        #10 rst_flag = 1;
        // End simulation
        $finish;
    end

   // Monitor wires
    initial begin
        $monitor("Time: %0t | clause: %h | la_chunk:%h | ta2_clause_out:%b | ta2_state:%b",
                 $time, DUT.clause_count, DUT.la_chunk_count, DUT.TM_2.clause_chunk_data, DUT.TM_2.Controller.state);
    end




endmodule
