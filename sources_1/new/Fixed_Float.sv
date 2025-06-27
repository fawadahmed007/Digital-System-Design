`timescale 1ns / 1ps
module Fixed_Float #(parameter M = 16, N = 16)(
    input  logic [M+N-1:0] fixed_in,
    output logic [31:0] float_out,
    output logic        sign,
    output logic [7:0]  exp,
    output logic [22:0] fract
);

    logic [M+N-1:0] abs;
    logic [46:0] normalized; 
    integer i;

    always_comb begin
        sign = fixed_in[M+N-1];
        abs = (sign == 1) ? (~fixed_in + 1) : fixed_in;
        normalized = abs;
        exp = 0;
        fract = 0;

        for (i = M+N-1; i >= 0; i--) begin
            if (normalized[i]) begin
                exp = i - N + 127;
                normalized = abs << (46 - i); 
                break;
            end
        end

        fract = normalized[45:23]; 
        float_out = {sign, exp, fract};
    end
endmodule