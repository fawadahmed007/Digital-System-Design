`timescale 1ns / 1ps
module tb_DFFS;

    logic clk30 = 0;
    logic pulse_in;
    logic pulse_sync;

    always #16.67 clk30 = ~clk30;  // 30 MHz

    DFF_Sync dut (
        .clk30(clk30),
        .pulse_in(pulse_in),
        .pulse_sync(pulse_sync)
    );

    initial begin
        $display("Time\tPulse_in\tPulse_sync");
        $monitor("%0t\t%b\t\t%b", $time, pulse_in, pulse_sync);

        pulse_in = 0;
        #50;
        pulse_in = 1;  // send pulse
        #33;
        pulse_in = 0;
        #100;
        pulse_in = 1;  // another pulse
        #33;
        pulse_in = 0;
        #100;
        $finish;
    end

endmodule
