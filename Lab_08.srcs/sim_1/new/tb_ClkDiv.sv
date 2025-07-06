`timescale 1ns / 1ps
module tb_ClkDiv;
    
    logic clk_in100;
    logic reset;
    logic clk_out25;
    logic clk_out33;
    
    Clk_Div25 C0(.clk_in100(clk_in100), .reset(reset), .clk_out25(clk_out25)
);
    Clk_Div33 C1(.clk_in100(clk_in100), .reset(reset), .clk_out33(clk_out33));
    
    always #5 clk_in100 = ~clk_in100;
    
    initial begin
        clk_in100 = 0;
        reset = 1;
        #10 reset = 0;
        #200 $finish;
    end

endmodule