`timescale 1ns / 1ps
module tb_TopT1;

    logic clk;
    logic reseta_n;
    logic [7:0] pulse_count;
    logic pulse_out_25, pulse_sync_30;

    Top_Task1 dut (
        .clk(clk),
        .reseta_n(reseta_n),
        .pulse_count(pulse_count),
        .pulse_out_25(pulse_out_25),
        .pulse_sync_30(pulse_sync_30)
    );
    
    always #5 clk = ~clk;
    initial begin
        // Initialize
        clk = 0;
        reseta_n = 0;
        #100;
        reseta_n = 1;
        // Run simulation long enough to observe pulses & counts
        #5000000;

        $display("\nSimulation completed.");
        $finish;
    end

    // Monitor key signals
    initial begin
        $display("Time\t\tpulse_out_25\tpulse_sync_30\tpulse_count");
        $monitor("%0t\t\t%b\t\t%b\t\t%0d", $time, pulse_out_25, pulse_sync_30, pulse_count);
    end

endmodule