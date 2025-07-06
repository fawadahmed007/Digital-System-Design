`timescale 1ns / 1ps
module tb_TopT4;

    logic clk;
    logic reseta_n;
    logic clk_sel;
    logic clk_out;

    Top_Task4 DUT (
        .clk(clk),
        .reseta_n(reseta_n),
        .clk_sel(clk_sel),
        .clk_out(clk_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reseta_n = 0;
        clk_sel = 0;
    
        #100;
        reseta_n = 1;
    
        clk_sel = 0;
        #200;
    
        clk_sel = 1;
        #200;
    
        clk_sel = 0;
        #200;
    
        clk_sel = 1;
        #200;
    
        clk_sel = 0;
        #200;
    
        clk_sel = 1;
        #200;
    
        clk_sel = 0;
        #200;
    
        clk_sel = 1;
        #200;
    
        clk_sel = 0;
        #200;
    
        $finish;
    end

    // Display info
    initial begin
        $display("Time\tclk_sel\tclk_out");
        $monitor("%0t\t%b\t%b", $time, clk_sel, clk_out);
    end

endmodule