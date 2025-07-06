`timescale 1ns / 1ps
module Clk_Div25(
    input logic clk_in100, reset,
    output logic clk_out25
    );
    
    logic [1:0] counter;
    logic clk_reg;
    
    always_ff @(posedge clk_in100 or posedge reset) begin
        if (reset) begin
            counter <= 0;
            clk_reg <= 0;
        end else begin
            if (counter == 1) begin
                clk_reg <= ~clk_reg;
                counter <= 0;
            end else counter <= counter + 1;
        end
    end
    
    assign clk_out25 = clk_reg;
endmodule