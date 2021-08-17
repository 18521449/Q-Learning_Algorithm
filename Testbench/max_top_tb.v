`timescale 1ns/1ps
module max_top_tb ();
`include "params.sv" 
parameter k = 20;

//--------------------------Input and output port-----------------------------//
reg 													        clk;
reg 													        rst_n;
reg 													        i_valid; // enable
reg 	[DATA_WIDTH*ACTIONS-1:0] 	  i_data; // data input bus
wire	[DATA_WIDTH-1:0]						       o_data;
wire	[ACTIONS_WIDTH-1:0]					     o_at_max;
wire     	 											          o_valid;
//----------------------------------------------------------------------------//  

initial begin
  clk <= 0;
  rst_n <= 0;
  #k#k rst_n <= 1;
  i_valid <= 1;
  i_data <= 128'b11000001010101100000000000000000010000011010000100001010001111010100000110100001000010100011110101000000101110001001001101110100;
  #(20*k) $finish;
end 

max_top max
	(	clk,
		rst_n,
		i_valid,
		i_data,
		o_data,
		o_at_max,
		o_valid
	);
	
always @(*)
  #k clk <= ~clk;

endmodule