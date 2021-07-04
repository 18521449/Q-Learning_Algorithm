module datapath 
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
input											i_write_file_en;
input 		[STATES_WIDTH-1:0] 		i_st;
input 		[STATES_WIDTH-1:0] 		i_next_st;
input 		[ACTIONS_WIDTH-1:0] 		i_at;
input 		[DATA_WIDTH-1:0] 			i_rt;
output reg 	[ACTIONS_WIDTH-1:0] 		o_at_max;
output reg 									o_valid;
//------------------------------------------------//

//-------------------register-------------------//
reg 		[DATA_WIDTH-1:0] 				q_reg;
reg 		[DATA_WIDTH*ACTIONS-1:0] 	next_q_reg;
reg 		[STATES_WIDTH-1:0]			st_reg;
reg		[STATES_WIDTH-1:0]			next_st_reg;
reg 		[ACTIONS_WIDTH-1:0]			at_reg;
reg		[DATA_WIDTH-1:0]  			rt_reg;
//----------------------------------------------//

//--------------------Bus-----------------------//
wire 		[DATA_WIDTH-1:0] 				q;
wire 		[DATA_WIDTH*ACTIONS-1:0] 	next_q;
wire 		[DATA_WIDTH-1:0] 				max_q;
wire 		[DATA_WIDTH-1:0] 				q_new;
//----------------------------------------------//

//----------------valid---------------//
reg 	re_act_ram;
wire 	valid_out_max;
wire 	valid_out_q_up;
reg 	valid_next_st;
//------------------------------------//

always @(posedge clk) begin
	if (i_valid) begin
		st_reg <= i_st;
		next_st_reg <= i_next_st;
		at_reg <= i_at;
		rt_reg <= i_rt;
		re_act_ram <= 1;
	end
	else re_act_ram <= 0;
end

integer i;
always @(posedge clk) begin
	if (re_act_ram) begin
		next_q_reg <= next_q;
		q_reg <= q;
	end
	if (valid_out_max) begin
		for (i=0; i<ACTIONS; i=i+1) begin
			if (max_q == next_q_reg[DATA_WIDTH-1:0]) begin
				o_at_max <= i;
			end
			next_q_reg <= next_q_reg >> DATA_WIDTH;
		end
	end
	if (valid_out_q_up) begin
		o_valid <= 1;
	end 
	else o_valid <= 0;
end
	
//-----------------------------------------------//
	action_ram act_ram
		(	.o_q(q),
			.o_next_q(next_q),
			.i_data(q_new),
			.i_st(st_reg), 
			.i_next_st(next_st_reg),
			.i_re(re_act_ram),
			.i_we(valid_out_q_up),
			.i_at(at_reg),
			.i_write_file_en(i_write_file_en),
			.clk(clk),
			.rst_n(rst_n));
//-----------------------------------------------//

//-----------------------------------------------//
	max_top max
		(	.o_data(max_q), 
			.o_valid(valid_out_max), 
			.i_data(next_q), 
			.i_valid(re_act_ram),
			.clk(clk), 
			.rst_n(rst_n));
//-----------------------------------------------//

//-----------------------------------------------//
	q_updater q_up 
		(	.o_q_new(q_new),
			.o_valid(valid_out_q_up),
			.i_q(q_reg), 
			.i_max_q(max_q), 
			.i_rt(rt_reg), 
			.i_valid(valid_out_max),
			.clk(clk),
			.rst_n(rst_n));
//-----------------------------------------------//

endmodule


