`timescale 1ns / 1ps
module uart (
    input  logic clk,
    input  logic reset,
    input  logic [7:0] tx_data,
    input  logic tx_valid,
    output logic tx_ready,
    output logic tx_busy,
    output logic tx_out,
    input  logic rx_in,
    output logic [7:0] rx_data,
    output logic rx_valid,
    output logic rx_error
);

    logic bclk, bclk_x8;

    // Baud Generator
    baud_gen #(
        .CLK_FREQ(100_000_000),
        .BAUD_RATE(9600)
    ) baud_inst (
        .sys_clk(clk),
        .reset(reset),
        .bclk(bclk),
        .bclk_x8(bclk_x8)
    );

    // UART Transmitter
    uart_tx tx_inst (
        .clk(clk),
        .reset(reset),
        .bclk(bclk),
        .tx_data(tx_data),
        .tx_valid(tx_valid),
        .tx_ready(tx_ready),
        .tx_busy(tx_busy),
        .tx_out(tx_out)
    );

    // UART Receiver
    uart_rx rx_inst (
        .clk(clk),
        .reset(reset),
        .bclk_x8(bclk_x8),
        .rx_in(rx_in),
        .rx_data(rx_data),
        .rx_valid(rx_valid),
        .rx_error(rx_error)
    );

endmodule
