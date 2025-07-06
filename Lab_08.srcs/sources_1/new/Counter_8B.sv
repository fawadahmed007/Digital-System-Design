`timescale 1ns / 1ps
module Counter_8B(
    input logic clk, reset,
    input logic enable,
    output logic [7:0] count
    );
    
    always_ff @(posedge clk or posedge reset) begin
        if (reset) count <= 0;
        else if (enable) count <= count + 1;
    end
endmodule
