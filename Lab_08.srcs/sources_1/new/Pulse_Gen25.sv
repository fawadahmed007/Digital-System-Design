`timescale 1ns / 1ps
module Pulse_Gen25(
    input logic clk25, reset,
    output logic out_pulse
    );
    
    logic [3:0] count;
    
    always_ff @(posedge clk25) begin
        if (reset) begin
            count <= 0;
            out_pulse <= 0;
        end else begin
            if (count == 9) begin
                out_pulse <= 1;
                count <= 0;
            end else begin
                out_pulse <= 0;
                count <= count + 1;
            end
        end
    end
endmodule