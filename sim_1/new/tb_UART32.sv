`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 06/26/2025 09:47:58 AM
// Design Name: 
// Module Name: tb_UART32
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module tb_UART32;

    logic clk, reset;
    logic rx_in;
    logic tx_valid;
    logic  [2:0] rx_count;
    logic tx_ready;
    logic tx_out;
    logic rx_valid;
    logic tx_led;
    logic [7:0] rx_data;
    logic op, overflow, underflow;

    logic bclk;

    Top_Module uut(.*);

    baud_gen #(.CLK_FREQ(100_000_000),.BAUD_RATE(9600)) b1 ( .sys_clk(clk), .reset, .bclk);

    always #5 clk = ~clk;

    task send_byte;
        input [7:0] data;
        integer i;
        begin
            @(posedge bclk);
            
            // Start bit
            rx_in = 0;
            @(posedge bclk);
            // Data bits (LSB fireset)
            for (i = 0; i < 8; i = i + 1) begin
                rx_in = data[i];
                @(posedge bclk);
            end
            
            // Stop bit
            rx_in = 1;
            @(posedge bclk);
        end
    endtask

    task test_add;
        input [63:0] data;
        integer i;
        reg [7:0] byte_in;
        begin
            for (i = 7; i > -1; i = i - 1) begin
                byte_in = data >> (i * 8);
                send_byte(byte_in);
            end
            
            tx_valid = 1;
            // wait for tx 
            #4500000; // 9600 !!
        end
    endtask
    
    // Test sequence
    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        rx_in = 1;
        tx_valid = 0;
        //  
        #100;

        reset = 1;
        op = 0;
        // Send test bytes
        test_add(64'h00000000_00050000);
        test_add(64'h00000000_000F0000);
        test_add(64'h00000000_000A0000);
        $finish;
    end

endmodule
