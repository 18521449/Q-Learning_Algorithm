`timescale 1ns/1ps
module q_learning_tb();
`include "params.sv" 
parameter k = 20;

//--------------------------Input and output port-----------------------------//
reg 													        clk;
reg 													        rst_n;
reg 													        i_valid; // enable
reg                               i_write_file_en;
reg 	[STATES_WIDTH-1:0]       	   i_st;
reg 	[STATES_WIDTH-1:0]       	   i_next_st;
reg 	[ACTIONS_WIDTH-1:0]       	  i_at;
reg	  [DATA_WIDTH-1:0]						      i_rt;
wire	[ACTIONS_WIDTH-1:0]					     o_at_max;
wire     	 											          o_valid;
//----------------------------------------------------------------------------//  

initial begin
  clk <= 0;
  rst_n <= 0;
  i_write_file_en <= 0;
  #k#k rst_n <= 1;
  i_valid <= 1;
  i_st <= 'd0;
	i_next_st <= 'd5;
	i_at <= 'd3;
	i_rt <= 32'b01000010010010000000000000000000;
  #(20*k) $finish;
end 

q_learning q_learn
	(	clk,
		rst_n,
		i_valid,
		i_write_file_en,
		i_st,
		i_next_st,
		i_at,
		i_rt,
		o_at_max,
		o_valid
	);
always @(*)
  #k clk <= ~clk;

endmodule

