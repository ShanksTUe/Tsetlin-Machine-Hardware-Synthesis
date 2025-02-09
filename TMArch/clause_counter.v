module clause_counter #(
    parameter VALUE = 6'h3F
)(
    input clk,
    input rst_flag,
    input stop_flag,
    output reg [5:0] count
);

always @(posedge clk or posedge rst_flag) begin
    if (rst_flag) begin
        count <= 6'h00;
    end else if (!stop_flag) begin
        if (count == VALUE) begin
            count <= 6'h00;
        end else begin
            count <= count + 1;
        end
    end

end

endmodule