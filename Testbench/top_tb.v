`timescale 1ns/1ps
module top_tb();
`include "params.sv" 
parameter k = 20;

//--------------------------Input and output port-----------------------------//
reg 													        clk;
reg 													        rst_n;
reg                               i_start;
reg 		[ACTIONS_WIDTH-1:0]		       i_at_random;
reg 		[STATES_WIDTH-1:0] 		       i_first_st;
wire									                o_valid;
//----------------------------------------------------------------------------//  

initial begin
  clk <= 0;
  rst_n <= 0;
  #k#k rst_n <= 1;
  i_start <= 1;
	i_first_st <= 'd0;
	#k#k i_start <= 0;
end 

top_core_ip top
	(	clk,
		rst_n,
		i_start,
		i_first_st,
		i_at_random,
		o_valid
	);


always @(posedge clk) begin
  i_at_random <= $urandom%4;
  if (o_valid) begin
    #k#k#k#k $finish;
  end
end

always @(*)
  #k clk <= ~clk;

endmodule


