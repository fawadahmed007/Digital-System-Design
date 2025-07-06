`timescale 1ns / 1ps
module DESTHandShake_DP(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] data_in,
    input  logic latch_en,
    output logic [7:0] data_latched
);
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            data_latched <= 8'd0;
        else if (latch_en)
            data_latched <= data_in;
    end
endmodule