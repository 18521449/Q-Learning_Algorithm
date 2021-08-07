module q_learning 
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
`include "params.sv"
//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 		[STATES_WIDTH-1:0] 		i_st;
input 		[STATES_WIDTH-1:0] 		i_next_st;
input 		[ACTIONS_WIDTH-1:0] 		i_at;
input 		[DATA_WIDTH-1:0] 			i_rt;
output	 	[ACTIONS_WIDTH-1:0] 		o_at_max;
output 										o_valid;
//------------------------------------------------//
//--------------------Bus-----------------------//
wire 		[DATA_WIDTH-1:0] 				q;
wire 		[DATA_WIDTH*ACTIONS-1:0] 	next_q;
wire 		[DATA_WIDTH-1:0] 				max_q;
wire 		[DATA_WIDTH-1:0] 				q_new;
wire 		valid_out_act_ram;
wire 		valid_out_max;
wire 		valid_out_q_up;
//------------------------------------//
//-----------------------------------------------//
	action_ram act_ram
		(	.clk(clk), 
			.rst_n(rst_n),
			.i_write_file_en(i_write_file_en),
			.i_re(i_valid),
			.i_we(valid_out_q_up),
			.i_at(i_at),
			.i_st(i_st),
			.i_next_st(i_next_st),
			.i_data(q_new),
			.o_q(q),
			.o_next_q(next_q),
			.o_valid(valid_out_act_ram)
		);
//-----------------------------------------------//
	max_top max
		(	.clk(clk), 
			.rst_n(rst_n),
			.i_valid(valid_out_act_ram),
			.i_data(next_q),			
			.o_data(max_q),
			.o_at_max(o_at_max),
			.o_valid(valid_out_max)
		);
//-----------------------------------------------//
	q_updater q_up
		(	.clk(clk),
			.rst_n(rst_n),
			.i_valid(valid_out_max),
			.i_q(q), 
			.i_max_q(max_q), 
			.i_rt(i_rt),
			.o_q_new(q_new),
			.o_valid(valid_out_q_up),
		);
//-----------------------------------------------//

endmodule


