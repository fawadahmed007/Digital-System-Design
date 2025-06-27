`timescale 1ns / 1ps
module tb_FF;

    // Parameters for Q(m,n) format
    localparam M = 16;
    localparam N = 16;

    // DUT I/Os
    logic [M+N-1:0] fixed_in;
    logic [31:0] float_out;

    // Instantiate the DUT
    Fixed_Float #(M, N) dut (
        .fixed_in(fixed_in),
        .float_out(float_out),
        .sign(),
        .exp(),
        .fract()
    );

    // Task to print result
    task print_result(input string name);
        $display("%s => Fixed: 0x%08h | IEEE-754: 0x%08h", name, fixed_in, float_out);
    endtask

    initial begin
        // Case 1: 3.75
        fixed_in =  $rtoi(3.75 * (1 << N)); // 3.75 * 65536 = 245760 = 0x0003C000
        #10;
        print_result("3.75");

        // Case 2: -2.5
        fixed_in = $rtoi(-2.5 * (1 << N)); // -2.5 * 65536 = -163840 = 0xFFFD8000
        #10;
        print_result("-2.5");

        // Case 3: 0.0
        fixed_in = $rtoi(0.0 * (1 << N));
        #10;
        print_result("0.0");

        // Case 4: 1.0
        fixed_in = 32'h00000001; // 1.0 * 65536 = 65536 = 0x00010000
        #10;
        print_result("1.0");

        // Done
        $finish;
    end

endmodule