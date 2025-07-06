`timescale 1ns / 1ps
module tb_TopT2;

    logic clk;
    logic reseta_n;
    logic [7:0] data_sent;
    logic [7:0] data_received;

    Top_Task2 dut (
        .clk(clk),
        .reseta_n(reseta_n),
        .data_sent(data_sent),
        .data_received(data_received)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reseta_n = 0;
        #100;
        reseta_n = 1;
    end

    initial begin
        $display("Time\tdata_sent\tdata_received");
        $monitor("%0t\t%0d\t\t%0d", $time, data_sent, data_received);

        #5000_000;  // Simulate 5 ms
        $finish;
    end


endmodule