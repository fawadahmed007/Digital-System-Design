`timescale 1ns / 1ps
module FPU_Arithmatic(
    input  logic [31:0] A,        // Operand A
    input  logic [31:0] B,        // Operand B
    input  logic        op,       // 0 for add, 1 for sub
    output logic [31:0] result,
    output logic        overflow,
    output logic        underflow
);

    // Step 1: Extract sign, exponent, mantissa
    logic sign_a, sign_b, sign_b_eff;
    logic [7:0] exp_a, exp_b;
    logic [23:0] mant_a, mant_b;

    assign sign_a = A[31];
    assign sign_b = B[31];
    assign exp_a = A[30:23];
    assign exp_b = B[30:23];

    assign mant_a = (exp_a == 8'd0) ? {1'b0, A[22:0]} : {1'b1, A[22:0]};
    assign mant_b = (exp_b == 8'd0) ? {1'b0, B[22:0]} : {1'b1, B[22:0]};
    assign sign_b_eff = sign_b ^ op;  // flip B's sign if op=1 (sub)

    // Step 2: Align exponents
    logic [7:0] exp_diff;
    logic [7:0] exp_large;
    logic [23:0] mant_large, mant_small;
    logic [23:0] shifted_small;
    logic sign_large, sign_small;
	//Difference of Exponent
    always_comb begin
        if (exp_a >= exp_b) begin
            exp_diff = exp_a - exp_b;
            exp_large = exp_a;
            mant_large = mant_a;
            mant_small = mant_b;
            sign_large = sign_a;
            sign_small = sign_b_eff;
        end else begin
            exp_diff = exp_b - exp_a;
            exp_large = exp_b;
            mant_large = mant_b;
            mant_small = mant_a;
            sign_large = sign_b_eff;
            sign_small = sign_a;
        end
    end

    // Right shift mantissa of smaller exponent
    always_comb begin
        case (exp_diff)
            8'd0:  shifted_small = mant_small;
            8'd1:  shifted_small = mant_small >> 1;
            8'd2:  shifted_small = mant_small >> 2;
            8'd3:  shifted_small = mant_small >> 3;
            8'd4:  shifted_small = mant_small >> 4;
            8'd5:  shifted_small = mant_small >> 5;
            8'd6:  shifted_small = mant_small >> 6;
            8'd7:  shifted_small = mant_small >> 7;
            8'd8:  shifted_small = mant_small >> 8;
            default: shifted_small = 24'd0;
        endcase
    end

    // Step 3: Perform operation
    logic [24:0] mant_result;
    logic result_sign;

    always_comb begin
        if (sign_large == sign_small) begin
            mant_result = mant_large + shifted_small;
            result_sign = sign_large;
        end else begin
            if (mant_large >= shifted_small) begin
                mant_result = mant_large - shifted_small;
                result_sign = sign_large;
            end else begin
                mant_result = shifted_small - mant_large;
                result_sign = sign_small;
            end
        end
    end

    // Step 4-5: Normalization for addition or subtraction
    logic [7:0] norm_exp;
    logic [23:0] norm_mant;

    always_comb begin
        if (mant_result[24] == 1) begin
            norm_mant = mant_result[24:1];
            norm_exp = exp_large + 1;
        end else if (mant_result[23]) begin
            norm_mant = mant_result[23:0];
            norm_exp = exp_large;
        end else if (mant_result[22]) begin
            norm_mant = mant_result[22:0] << 1;
            norm_exp = exp_large - 1;
        end else if (mant_result[21]) begin
            norm_mant = mant_result[21:0] << 2;
            norm_exp = exp_large - 2;
        end else if (mant_result[20]) begin
            norm_mant = mant_result[20:0] << 3;
            norm_exp = exp_large - 3;
        end else begin
            norm_mant = 24'd0;
            norm_exp = 8'd0;
        end
    end

    // Step 6: Pack result
    assign result = {result_sign, norm_exp, norm_mant[22:0]};

    // Overflow and Underflow Flags
    assign overflow  = (norm_exp >= 8'd255);
    assign underflow = (norm_exp == 8'd0);
endmodule