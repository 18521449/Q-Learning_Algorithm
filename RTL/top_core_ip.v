module top_core_ip 
	(	clk,
		rst_n,
		i_start,
		i_first_st,
		i_at_random,
		o_valid
	);
`include "params.sv"

//----------Input and output port-----------//
input 									clk;
input 									rst_n;
input 									i_start;
input 	[STATES_WIDTH-1:0]		i_first_st;
input 	[ACTIONS_WIDTH-1:0]		i_at_random;
output 									o_valid;
//------------------------------------------//
wire 		[COUNTER_WIDTH-1:0]		o_count;
wire 		[COUNTER_WIDTH-1:0]		o_step;
wire valid_out_ctrl, valid_out_dtp, o_re_random;
//------------------------------------------//

datapath dtp_block
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_ctrl),
		.i_write_file_en(o_valid),
		.i_count(o_count),
		.i_step(o_step),
		.i_first_st(i_first_st),
		.i_at_random(i_at_random),
		.o_valid(valid_out_dtp)
	);
controller ctrl_block
	(	.clk(clk),
		.rst_n(rst_n),
		.i_start(i_start),
		.i_valid(valid_out_dtp),
		.o_count(o_count),
		.o_step(o_step),
		.o_write_file_en(o_valid),
		.o_valid(valid_out_ctrl)
	);

endmodule 