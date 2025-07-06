`timescale 1ns / 1ps
module Bin2Gray(
    input logic [4:0] bin_in,
    output logic [4:0] gray_out
    );
    
    assign gray_out[4] = bin_in[4];
    assign gray_out[3] = bin_in[4] ^ bin_in[3];
    assign gray_out[2] = bin_in[3] ^ bin_in[2];
    assign gray_out[1] = bin_in[2] ^ bin_in[1];
    assign gray_out[0] = bin_in[1] ^ bin_in[0];
endmodule
