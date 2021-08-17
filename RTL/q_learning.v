module q_learning
	(	clk,
		rst_n,
		i_valid,
		i_write_file_en,
		i_st,
		i_next_st,
		i_at,
		i_rt,
//		o_at_max,
		o_valid
	);
`include "params.sv"
//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 										i_write_file_en;
input 		[STATES_WIDTH-1:0] 		i_st;
input 		[STATES_WIDTH-1:0] 		i_next_st;
input 		[ACTIONS_WIDTH-1:0] 		i_at;
input 		[DATA_WIDTH-1:0] 			i_rt;
//output reg	[ACTIONS_WIDTH-1:0] 		o_at_max;
output 										o_valid;
//------------------------------------------------//
//--------------------Bus-----------------------//
//wire		[ACTIONS_WIDTH-1:0] 			at_max;
wire 		[DATA_WIDTH-1:0] 				q;
wire 		[DATA_WIDTH*ACTIONS-1:0] 	next_q;
wire 		[DATA_WIDTH-1:0] 				max_q;
wire 		[DATA_WIDTH-1:0] 				q_new;
wire 		valid_out_act_ram;
wire 		valid_out_max;
//------------------------------------//
reg [ACTIONS_WIDTH-1:0] write_at [NUMBER_OF_LOOP*NUMBER_OF_STEP-1:0];
integer i = 0;
always @(posedge clk) begin
	if (i_valid) begin
		write_at[i] <= i_at;
		i = i + 1;
	end
	if (i_write_file_en) 
		$writememb(ACTIONS_FILE, write_at);
end
//always @(posedge clk) begin
//	if (valid_out_max) begin
//		o_at_max <= at_max;
//	end
//end
//-----------------------------------------------//
	action_ram action_ram_block
		(	.clk(clk), 
			.rst_n(rst_n),
			.i_write_file_en(i_write_file_en),
			.i_re(i_valid),
			.i_we(o_valid),
			.i_at(i_at),
			.i_st(i_st),
			.i_next_st(i_next_st),
			.i_data(q_new),
			.o_q(q),
			.o_next_q(next_q),
			.o_valid(valid_out_act_ram)
		);
//-----------------------------------------------//
	max_top max_block
		(	.clk(clk), 
			.rst_n(rst_n),
			.i_valid(valid_out_act_ram),
			.i_data(next_q),			
			.o_data(max_q),
//			.o_at_max(at_max),
			.o_valid(valid_out_max)
		);
//-----------------------------------------------//
	q_update q_update_block
		(	.clk(clk),
			.rst_n(rst_n),
			.i_valid(valid_out_max),
			.i_q(q), 
			.i_max_q(max_q), 
			.i_rt(i_rt),
			.o_q_new(q_new),
			.o_valid(o_valid)
		);
//-----------------------------------------------//

endmodule


