`timescale 1ns / 1ps
module tb_Cel_Farn;

    logic [31:0] Celsius;
    logic [31:0] PartialResult;

    // Instantiate the DUT
    Cel_Farn dut (
        .Celsius(Celsius),
        .PartialResult(PartialResult)
    );

    // Constants
    logic [31:0] add_32 = 32'd2097152; // 32.0 in Q16.16

    initial begin
        // Test Case 1: Celsius = 0
        Celsius = 32'd0;
        #10;
        $display("C = 0, Partial = %h, Final = %h", PartialResult, PartialResult + add_32);

        // Test Case 2: Celsius = 5
        Celsius = 32'd327680;  // 5 × 65536
        #10;
        $display("C = 5, Partial = %h, Final = %h", PartialResult, PartialResult + add_32);

        // Test Case 3: Celsius = 10
        Celsius = 32'd655360;  // 10 × 65536
        #10;
        $display("C = 10, Partial = %h, Final = %h", PartialResult, PartialResult + add_32);

        // Test Case 4: Celsius = 15
        Celsius = 32'd983040;  // 15 × 65536
        #10;
        $display("C = 15, Partial = %h, Final = %h", PartialResult, PartialResult + add_32);

        // Test Case 5: Celsius = 25
        Celsius = 32'd1638400;  // 25 × 65536
        #10;
        $display("C = 25, Partial = %h, Final = %h", PartialResult, PartialResult + add_32);

        $stop;
    end

endmodule