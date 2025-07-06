`timescale 1ns / 1ps
module Pulse_Cnt(
    input logic clk30,
    input logic resets_p, pulse_sync,
    output logic [7:0] pulse_count
    );
    
    logic pulse_sync_d;
    
    always_ff @(posedge clk30) begin
        if (resets_p) begin
            pulse_sync_d <= 0;
            pulse_count <= 0;
        end else begin
            pulse_sync_d <= pulse_sync;
            if (pulse_sync && !pulse_sync_d) pulse_count <= pulse_count + 1;
        end
    end
endmodule