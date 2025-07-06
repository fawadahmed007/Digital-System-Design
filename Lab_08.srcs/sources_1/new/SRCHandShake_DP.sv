`timescale 1ns / 1ps
module SRCHandShake_DP(
    input  logic clk,
    input  logic reset,
    input  logic [7:0] count_in,
    input  logic load_data,
    output logic [7:0] data_out
    );
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset)
            data_out <= 8'd0;
        else if (load_data)
            data_out <= count_in;
    end
endmodule