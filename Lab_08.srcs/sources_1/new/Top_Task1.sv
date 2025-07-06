`timescale 1ns / 1ps
module Top_Task1(
    input  logic clk, 
    input  logic reseta_n, 
    output logic [7:0] pulse_count,
    output logic pulse_out_25,
    output logic pulse_sync_30
);

    logic clk25, clk30;
    logic reset_sync_25, reset_sync_30;
    logic rst25_sync, rst30_sync;

    Reset_Sync R0 (
        .clk(clk),
        .reseta_n(reseta_n),
        .resets_p(reset_sync_25)
    );

    Reset_Sync R1 (
        .clk(clk),
        .reseta_n(reseta_n),
        .resets_p(reset_sync_30)
    );

    Clk_Div25 clk_25 (
        .clk_in100(clk),
        .reset(reset_sync_25), 
        .clk_out25(clk25)
    );

    Clk_Div33 clk_30 (
        .clk_in100(clk),
        .reset(reset_sync_30),
        .clk_out33(clk30)
    );

    Reset_Sync rst25 (
        .clk(clk25),
        .reseta_n(reseta_n),
        .resets_p(rst25_sync)
    );

    Reset_Sync rst30 (
        .clk(clk30),
        .reseta_n(reseta_n),
        .resets_p(rst30_sync)
    );

    Pulse_Gen25 PGen (
        .clk25(clk25),
        .reset(rst25_sync),
        .out_pulse(pulse_out_25)
    );

    DFF_Sync DFF (
        .clk30(clk30),
        .pulse_in(pulse_out_25),
        .pulse_sync(pulse_sync_30)
    );

    Pulse_Cnt PCnt (
        .clk30(clk30),
        .resets_p(rst30_sync),
        .pulse_sync(pulse_sync_30),
        .pulse_count(pulse_count)
    );
    
endmodule