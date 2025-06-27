`timescale 1ns / 1ps
module Cel_Farn(
    input  logic [31:0] Celsius,        
    output logic [31:0] PartialResult   
);

    logic [31:0] CelFactor;  
    logic [63:0] mult_result;

    assign CelFactor = 32'h0001CCD5;

    assign mult_result = Celsius * CelFactor;

    // Taking upper 32 bits
    assign PartialResult = mult_result[47:16];
endmodule