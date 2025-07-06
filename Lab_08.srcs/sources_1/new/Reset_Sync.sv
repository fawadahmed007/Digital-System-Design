`timescale 1ns / 1ps
module Reset_Sync(
    input logic clk, reseta_n,
    output logic resets_p
    );
    
    logic [2:0] sync_ff;
    
    always_ff @(posedge clk or negedge reseta_n) begin
        if (!reseta_n) sync_ff <= 7;
        else sync_ff <= {sync_ff[1:0], 1'b0};
    end
    
    assign resets_p = sync_ff[2];
endmodule