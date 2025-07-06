`timescale 1ns / 1ps
module tb_PCount;


    logic clk30 = 0;
    logic reset_sync;
    logic pulse_sync;
    logic [7:0] pulse_count;

    // Clock: 30 MHz
    always #16.67 clk30 = ~clk30;

    Pulse_Cnt dut (
        .clk30(clk30),
        .resets_p(reset_sync),
        .pulse_sync(pulse_sync),
        .pulse_count(pulse_count)
    );

    initial begin
        $display("Time\tPulse_sync\tCount");
        $monitor("%0t\t%b\t\t%d", $time, pulse_sync, pulse_count);

        reset_sync = 1;
        pulse_sync = 0;
        #50;
        reset_sync = 0;

        // Apply pulses
        #50 pulse_sync = 1;
        #33 pulse_sync = 0;

        #100 pulse_sync = 1;
        #33 pulse_sync = 0;

        #100 pulse_sync = 1;
        #33 pulse_sync = 0;

        #200;
        $finish;
    end

endmodule