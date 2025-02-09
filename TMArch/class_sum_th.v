module class_sum_th (
    input clk,
    input rst_flag,
    input stop_flag,
    input signed [31:0] class_sum_in,
    output reg signed [31:0] class_sum_out

);


// Define the threshold value
localparam signed [31:0] THRESHOLD_POS = 50; 
localparam signed [31:0] THRESHOLD_NEG = -50; 

always @(posedge clk or posedge rst_flag) begin
    if (rst_flag) begin
        // Reset class_sum_out to 0
        class_sum_out <= 32'sh00000000;
    end else if (!stop_flag) begin
        // Clamp class_sum_in to the range [-THRESHOLD, THRESHOLD]
        if (class_sum_in > THRESHOLD_POS) begin
            class_sum_out <= THRESHOLD_POS;

        end else if (class_sum_in < THRESHOLD_NEG) begin
            class_sum_out <= THRESHOLD_NEG;

        end else begin
            class_sum_out <= class_sum_in;

        end
    end
end

endmodule