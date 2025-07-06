`timescale 1ns / 1ps
module Gray2Bin(
    input logic [4:0] gray_in,
    output logic [4:0] bin_out
    );
    
    assign bin_out[4] = gray_in[4];
    assign bin_out[3] = bin_out[4] ^ gray_in[3];
    assign bin_out[2] = bin_out[3] ^ gray_in[2];
    assign bin_out[1] = bin_out[2] ^ gray_in[1];
    assign bin_out[0] = bin_out[1] ^ gray_in[0];
endmodule