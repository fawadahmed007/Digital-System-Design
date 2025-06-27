`timescale 1ns / 1ps
module tb_FPUA;

    // Inputs
    logic [31:0] A, B;
    logic        op;

    // Outputs
    logic [31:0] result;
    logic        overflow, underflow;

    // Instantiate the FPU module
    FPU_Arithmatic uut (
        .A(A),
        .B(B),
        .op(op),
        .result(result),
        .overflow(overflow),
        .underflow(underflow)
    );

    // Test stimulus
    initial begin
        $display("Time\tA\t\t\tB\t\t\tOp\tResult\t\t\tOverflow\tUnderflow");

        // Test 1: 1.5 + 2.25
        A = 32'h3FC00000; // 1.5
        B = 32'h40200000; // 2.25
        op = 0;
        #10;
        $display("%0t\t%h\t%h\t%b\t%h\t%b\t\t%b", $time, A, B, op, result, overflow, underflow);

        // Test 2: 5.0 - 1.5
        A = 32'h40A00000; // 5.0
        B = 32'h3FC00000; // 1.5
        op = 1;
        #10;
        $display("%0t\t%h\t%h\t%b\t%h\t%b\t\t%b", $time, A, B, op, result, overflow, underflow);

        // Test 3: -3.0 + 3.0 => should be zero
        A = 32'hC0400000; // -3.0
        B = 32'h40400000; // +3.0
        op = 0;
        #10;
        $display("%0t\t%h\t%h\t%b\t%h\t%b\t\t%b", $time, A, B, op, result, overflow, underflow);

        // Test 4: Very small + very small => possible underflow
        A = 32'h00000010; // very small subnormal
        B = 32'h00000010; // very small subnormal
        op = 0;
        #10;
        $display("%0t\t%h\t%h\t%b\t%h\t%b\t\t%b", $time, A, B, op, result, overflow, underflow);

        // Test 5: Large + Large => possible overflow
        A = 32'h7F000000; // large number
        B = 32'h7F000000; // large number
        op = 0;
        #10;
        $display("%0t\t%h\t%h\t%b\t%h\t%b\t\t%b", $time, A, B, op, result, overflow, underflow);

        $finish;
    end
endmodule