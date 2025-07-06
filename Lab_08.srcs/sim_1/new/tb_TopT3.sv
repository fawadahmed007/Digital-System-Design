`timescale 1ns / 1ps
module tb_TopT3;

  logic clk;
  logic reseta_n;
  logic rd_en;
  logic [7:0] rd_data;
  logic FF_Full, FF_Emp;

  Top_Task3 dut (
    .clk(clk),
    .reseta_n(reseta_n),
    .rd_en(rd_en),
    .rd_data(rd_data),
    .FF_Full(FF_Full),
    .FF_Emp(FF_Emp)
  );

  always #5 clk = ~clk;

  initial begin
    clk = 0;
    reseta_n = 0;
    rd_en = 0;

    #50;
    reseta_n = 1;

    // Wait some time for FIFO to start filling
    #800;

    // Enable reading periodically
    forever begin
      rd_en = 1;
      #30;
      rd_en = 0;
      #70;
    end
  end

  // Monitor output
  initial begin
    $display("Time\t\twr_data\t\t rd_data\tFF_Full\tFF_Emp");
    $monitor("%0t\t\t%0d\t\t%0d\t\t%b\t%b", $time, dut.wr_data, rd_data, FF_Full, FF_Emp);

    #5000 $finish;
  end

endmodule