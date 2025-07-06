`timescale 1ns / 1ps
module tb_PGen;

    logic clk25 = 0;
    logic reset_sync;
    logic pulse_out = 0;;

    // Clock generation: 25 MHz (period = 40 ns)
    always #20 clk25 = ~clk25;

    // DUT
    Pulse_Gen25 dut (
        .clk25(clk25),
        .reset(reset_sync),
        .out_pulse(pulse_out)
    );

    initial begin
        $display("Time\tReset\tPulse");
        $monitor("%0t\t%b\t%b", $time, reset_sync, pulse_out);

        reset_sync = 1;
        #100;
        reset_sync = 0;

        #1000;  // Run for some time
        $finish;
    end

endmodule