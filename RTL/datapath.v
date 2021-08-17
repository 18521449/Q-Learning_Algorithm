module datapath
	(	clk,
		rst_n,
		i_valid,
		i_write_file_en,
		i_count,
		i_step,
		i_first_st,
		i_at_random,
		o_valid
	);
`include "params.sv"
//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 										i_write_file_en;
input 		[COUNTER_WIDTH-1:0]		i_count;
input 		[COUNTER_WIDTH-1:0]		i_step;
input 		[STATES_WIDTH-1:0] 		i_first_st;
input 		[ACTIONS_WIDTH-1:0]		i_at_random;
output 										o_valid;
//------------------------------------------------//
wire 		[STATES_WIDTH-1:0] 			o_st;
wire 		[STATES_WIDTH-1:0] 			o_next_st;
wire 		[ACTIONS_WIDTH-1:0] 			o_at;
//wire 		[ACTIONS_WIDTH-1:0] 			o_at_max;
wire 		[DATA_WIDTH-1:0] 				o_rt;
wire 		valid_out_agent;
//-----------------------------------------------//
	agent agent_block
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(i_valid),
		.i_count(i_count),
		.i_step(i_step),
//		.i_at_max(o_at_max),
		.i_at_random(i_at_random),
		.i_first_st(i_first_st),
		.o_st(o_st),
		.o_next_st(o_next_st),
		.o_at(o_at),
		.o_valid(valid_out_agent)
	);
//-----------------------------------------------//
	reward_rom reward_rom_block
	(	.i_st(o_st),
		.o_rt(o_rt)
	);
//-----------------------------------------------//
	q_learning q_learning_block
	(	.clk(clk),
		.rst_n(rst_n),
		.i_valid(valid_out_agent),
		.i_write_file_en(i_write_file_en),
		.i_st(o_st),
		.i_next_st(o_next_st),
		.i_at(o_at),
		.i_rt(o_rt),
//		.o_at_max(o_at_max),
		.o_valid(o_valid)
	);
//-----------------------------------------------//

endmodule


