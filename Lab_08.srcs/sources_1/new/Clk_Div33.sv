`timescale 1ns / 1ps
module Clk_Div33(
    input logic clk_in100, reset,
    output logic clk_out33
    );
    
    logic [1:0] counter;
    
    always_ff @(posedge clk_in100 or posedge reset) begin
            if (reset)
                counter <= 0;
            else if (counter == 2)
                counter <= 0;
            else
                counter <= counter + 1;
        end
    
        assign clk_out33 = (counter == 2); 

endmodule