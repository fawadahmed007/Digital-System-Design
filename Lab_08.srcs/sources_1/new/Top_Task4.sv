`timescale 1ns / 1ps
module Top_Task4(
    input logic clk, reseta_n,
    input logic clk_sel,
    output logic clk_out
    );
    
    logic clk25, clk30;
    logic reset_sync_25, reset_sync_30;
    logic rst25_sync, rst30_sync;
    logic clk_sel25, clk_sel30;
    logic clk25_Gated, clk30_Gated;
   
    
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
    
    DFF_Sync DFF25 (
        .clk30(clk25),
        .pulse_in(clk_sel),
        .pulse_sync(clk_sel25)
    );
    
    DFF_Sync DFF30 (
        .clk30(clk30),
        .pulse_in(clk_sel),
        .pulse_sync(clk_sel30)
    );
    
    assign clk25_Gated = clk25 & ~clk_sel25;
    assign clk30_Gated = clk30 & clk_sel30;
    assign clk_out = clk_sel ? clk30_Gated : clk25_Gated;
    
endmodule