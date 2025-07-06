`timescale 1ns / 1ps
module Top_Task2(
    input  logic clk,
    input  logic reseta_n,
    output logic [7:0] data_sent,
    output logic [7:0] data_received
    );
    
    logic clk25, clk30;
    logic reset_sync_25, reset_sync_30;
    logic rst25_sync, rst30_sync;
    logic [7:0] count, data_out, data_latched;
    logic valid_data, ack_out, valid_sync, ack_sync;
    logic load_data, count_enable;
    logic latch_en;
    
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
     
    Counter_8B Ctr (
        .clk(clk25),
        .reset(rst25_sync),
        .enable(count_enable),
        .count(count)
    );
    
   SRCHandShake_CP SHS_C (
        .clk(clk25),
        .reset(rst25_sync),
        .ack_sync(ack_sync),
        .valid_data(valid_data),
        .load_data(load_data),
        .count_enable(count_enable)
    );

    SRCHandShake_DP SHS_D (
        .clk(clk25),
        .reset(rst25_sync),
        .count_in(count),
        .load_data(load_data),
        .data_out(data_out)
    );
    
    DFF_Sync DFF1(
        .clk30(clk30),
        .pulse_in(valid_data),
        .pulse_sync(valid_sync)    
    );
       
   DESTHandShake_CP DHS_C (
        .clk(clk30),
        .reset(rst30_sync),
        .valid_sync(valid_sync),
        .ack_out(ack_out),
        .latch_en(latch_en)
    );

    DESTHandShake_DP DHS_D (
        .clk(clk30),
        .reset(rst30_sync),
        .data_in(data_out),
        .latch_en(latch_en),
        .data_latched(data_latched)
    );
    
    DFF_Sync DFF2(
        .clk30(clk25),
        .pulse_in(ack_out),
        .pulse_sync(ack_sync)    
    );
    
    assign data_sent     = data_out;
    assign data_received = data_latched;
endmodule
