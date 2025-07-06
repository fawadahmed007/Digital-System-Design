`timescale 1ns / 1ps
module Top_Task3(
    input logic clk, reseta_n,
    input logic rd_en,
    output logic [7:0] rd_data,
    output logic FF_Full, FF_Emp
    );
    
    logic clk25, clk30;
    logic reset_sync_25, reset_sync_30;       
    logic rst25_sync, rst30_sync;
    logic [4:0] wr_ptr_BIN, wr_ptr_GRY;
    logic [4:0] rd_ptr_BIN, rd_ptr_GRY;
    logic [4:0] wr_ptr_GRY_sync, rd_ptr_GRY_sync;
    logic [3:0] wr_addr;
    logic [3:0] rd_addr;  
    logic [7:0] wr_data;
    logic wr_en;
    
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
    
    Counter_8B CTR (
        .clk(clk25),
        .reset(rst25_sync),
        .enable(!FF_Full),
        .count(wr_data)
    );
    
    assign wr_en = !FF_Full;
    assign wr_addr = wr_ptr_BIN[3:0];
    
    W_Logic wr_logic (
        .wr_clk(clk25),
        .reseta_n(~rst25_sync),
        .wr_en(wr_en),
        .rd_GRY_sync(rd_ptr_GRY_sync),
        .wr_ptr_BIN(wr_ptr_BIN),
        .wr_ptr_GRY(wr_ptr_GRY),
        .FF_Full(FF_Full)
    );
    
    R_Logic rd_logic (
        .rd_clk(clk30),
        .reseta_n(~rst30_sync),
        .rd_en(rd_en),
        .wr_GRY_sync(wr_ptr_GRY_sync),
        .rd_ptr_BIN(rd_ptr_BIN),
        .rd_ptr_GRY(rd_ptr_GRY),
        .rd_addr(rd_addr),
        .FF_Emp(FF_Emp)
    );
    
    genvar i;
    generate
        for (i = 0; i < 5; i++) begin : SYNC_BLOCK
            DFF_Sync sync_rd2wr (
                .clk30(clk25),
                .pulse_in(rd_ptr_GRY[i]),
                .pulse_sync(rd_ptr_GRY_sync[i])
            );
            DFF_Sync sync_wr2rd (
                .clk30(clk30),
                .pulse_in(wr_ptr_GRY[i]),
                .pulse_sync(wr_ptr_GRY_sync[i])
            );
        end
    endgenerate
    
    FIFO_MEM FMEM (
        .wr_clk(clk25),
        .rd_clk(clk30),
        .wr_en(wr_en && !FF_Full),
        .wr_addr(wr_addr),
        .wr_data(wr_data),
        .rd_addr(rd_addr),
        .rd_data(rd_data)
    );
    
endmodule
