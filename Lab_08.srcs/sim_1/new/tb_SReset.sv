`timescale 1ns / 1ps
module tb_SReset;
    
    logic clk = 0;
    logic reset_n;
    logic reset_sync;

    // 50 MHz clock
    always #10 clk = ~clk;

    Reset_Sync dut (
        .clk(clk),
        .reseta_n(reset_n),
        .resets_p(reset_sync)
    );

    initial begin
        $display("Time\treset_n\treset_sync");
        $monitor("%0t\t%b\t\t%b", $time, reset_n, reset_sync);

        reset_n = 0;  // async active-low reset asserted
        #50;
        reset_n = 1;  // release reset
        #200;
        $finish;
    end

endmodule