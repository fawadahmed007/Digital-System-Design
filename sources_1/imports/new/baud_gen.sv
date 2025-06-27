`timescale 1ns / 1ps
module baud_gen #(
    parameter CLK_FREQ = 100_000_000,
    parameter BAUD_RATE = 9600
)(
    input  logic sys_clk,
    input  logic reset,
    output logic bclk,
    output logic bclk_x8
);

    localparam BAUD_DIVISOR     = (CLK_FREQ / BAUD_RATE) / 2 - 1;
    localparam BAUD_DIVISOR_X8  = (CLK_FREQ / (BAUD_RATE * 8)) / 2 - 1;

    logic [15:0] counter_1x, counter_8x;

    always_ff @(posedge sys_clk or negedge reset) begin
        if (!reset) begin
            counter_1x <= 0;
            bclk <= 0;
        end else begin
            if (counter_1x == BAUD_DIVISOR) begin
                bclk <= ~bclk;
                counter_1x <= 0;
            end else begin
                counter_1x <= counter_1x + 1;
            end
        end
    end

    always_ff @(posedge sys_clk or negedge reset) begin
        if (!reset) begin
            counter_8x <= 0;
            bclk_x8 <= 0;
        end else begin
            if (counter_8x == BAUD_DIVISOR_X8) begin
                bclk_x8 <= ~bclk_x8;
                counter_8x <= 0;
            end else begin
                counter_8x <= counter_8x + 1;
            end
        end
    end

endmodule
