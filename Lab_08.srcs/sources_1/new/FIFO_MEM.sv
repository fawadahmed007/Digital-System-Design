`timescale 1ns / 1ps
module FIFO_MEM(
    input logic wr_clk, rd_clk,
    input logic wr_en,
    input logic [3:0] wr_addr, rd_addr,
    input logic [7:0] wr_data,
    output logic [7:0] rd_data
    );
    
    logic [7:0] FMEM [0:15];
    
    assign rd_data = FMEM[rd_addr];
    
    always_ff @(posedge wr_clk) begin
        if (wr_en) FMEM[wr_addr] <= wr_data;
    end
    
endmodule