`timescale 1ns / 1ps
module DFF_Sync(
    input logic clk30,
    input logic pulse_in,
    output logic pulse_sync    
    );
    
    logic ff1, ff2;
    
    always_ff @(posedge clk30) begin
        ff1 <= pulse_in;
        ff2 <= ff1;
    end
    
    assign pulse_sync = ff2;
endmodule