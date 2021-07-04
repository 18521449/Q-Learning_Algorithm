`timescale 1ns/1ps
module top_tb();
`include "params.sv"

parameter k = 50;

reg clk;
reg rst_n;
reg i_valid;
reg i_start;
reg [STATES_WIDTH-1:0] i_first_st;
wire o_valid;

initial begin
  clk <= 0;
  rst_n <= 1;
  i_valid <= 1;
  i_start <= 1;
  i_first_st <= 'd0;
  #k#k i_valid <= 0;
  i_start <= 0;
end

top q_learning
	(	clk,
		rst_n,
		i_valid,
		i_start,
		i_first_st,
		o_valid
	);

always @(posedge clk) begin
  if (o_valid) begin
    #k#k#k#k $finish;
  end
end

always @(*) begin
  #k clk <= ~clk;
end

endmodule