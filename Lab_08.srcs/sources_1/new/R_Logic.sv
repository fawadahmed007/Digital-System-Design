`timescale 1ns / 1ps
module R_Logic(
    input logic rd_clk, reseta_n,
    input logic rd_en,
    input logic [4:0] wr_GRY_sync,
    output logic [4:0] rd_ptr_BIN, rd_ptr_GRY, 
    output logic [3:0] rd_addr,
    output logic FF_Emp
    );
    
    logic [4:0] rd_ptr_BIN_nxt, rd_ptr_GRY_nxt;
    
    Bin2Gray G2B (
        .bin_in(rd_ptr_BIN_nxt),
        .gray_out(rd_ptr_GRY_nxt)    
    );
    
    always_ff @(posedge rd_clk or negedge reseta_n) begin
        if (!reseta_n) begin
            rd_ptr_BIN <= 0;
            rd_ptr_GRY <= 0;
        end else if (rd_en && !FF_Emp) begin
            rd_ptr_BIN <= rd_ptr_BIN_nxt;
            rd_ptr_GRY <= rd_ptr_GRY_nxt;
        end
    end
    
    assign rd_ptr_BIN_nxt = rd_ptr_BIN + 1;
    assign rd_addr = rd_ptr_BIN[3:0];
    assign FF_Emp = (rd_ptr_GRY == wr_GRY_sync);
endmodule