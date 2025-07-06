`timescale 1ns / 1ps
module W_Logic(
    input logic wr_clk, reseta_n,
    input logic wr_en,
    input logic [4:0] rd_GRY_sync,
    output logic [4:0] wr_ptr_BIN, wr_ptr_GRY,
    output logic FF_Full
    );
    
    logic [4:0] wr_ptr_BIN_nxt, wr_ptr_GRY_nxt;
    
    Bin2Gray B2G (
        .bin_in(wr_ptr_BIN_nxt),
        .gray_out(wr_ptr_GRY_nxt)
    );
        
    always_ff @(posedge wr_clk or negedge reseta_n) begin
        if (!reseta_n) begin
            wr_ptr_BIN <= 0;
            wr_ptr_GRY <= 0;
        end else if (wr_en && !FF_Full) begin
            wr_ptr_BIN <= wr_ptr_BIN_nxt;
            wr_ptr_GRY <= wr_ptr_GRY_nxt;
        end
    end
    
    assign wr_ptr_BIN_nxt = wr_ptr_BIN + 1;
    assign FF_Full = (wr_ptr_GRY_nxt == {~rd_GRY_sync[4:3], rd_GRY_sync[2:0]});
    
 endmodule