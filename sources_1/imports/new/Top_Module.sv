`timescale 1ns / 1ps
module Top_Module(
    input logic clk, reset,
    input logic rx_in, op,
    input logic tx_valid,
    input logic [2:0] rx_count, 
    output logic tx_ready,
    output logic tx_out,
    output logic rx_valid,
    output logic tx_led,
    output logic [7:0] rx_data, 
    output logic overflow, underflow
    );
    
    logic [31:0] tx_data;
    logic [63:0] rx_shift_reg;
    logic [31:0] op_a, op_b;
    logic [31:0] op_afloat, op_bfloat;
    logic [31:0] out_a;
       
    uart_32bit u1(
        .clk(clk), 
        .reset(reset),
        .rx_in(rx_in),
        .tx_valid(tx_valid), 
        .rx_count(rx_count),
        .tx_data(tx_data),
        .tx_ready(tx_ready),
        .tx_out(tx_out),
        .rx_valid(rx_valid),
        .tx_led(tx_led),
        .rx_data(rx_data),
        .rx_shift_reg(rx_shift_reg)
    );
    
    assign op_a = rx_shift_reg[31:0];
  //  assign op_b = rx_shift_reg[63:32];
    
    Cel_Farn C1(
    .Celsius(op_a),        
    .PartialResult(out_a)   
    );
       
    Fixed_Float #(.M(16), .N(16)) FF0 (
    .fixed_in(out_a),
    .float_out(op_afloat),
    .sign(),
    .exp(),
    .fract()
    );
    
    Fixed_Float #(.M(16), .N(16)) FF1 (
    .fixed_in(32'h00200000),
    .float_out(op_bfloat),
    .sign(),
    .exp(),
    .fract()
    );
    
    FPU_Arithmatic FPU(
    .A(op_afloat),        // Operand A
    .B(op_bfloat),        // Operand B
    .op(op),       // 0 for add, 1 for sub
    .result(tx_data),
    .overflow(overflow),
    .underflow(underflow)
    );
    
     
endmodule