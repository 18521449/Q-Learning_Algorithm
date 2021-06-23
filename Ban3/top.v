module top //(o_st, o_valid, i_valid, i_start, i_finish, i_first_st, i_at, clk, rst_n);
	(
//------------Input and output port----------------//
input 										clk,
input 										rst_n,
input 										i_valid,
input 										i_start,
input 										i_finish,
input			[STATES_WIDTH-1:0] 		i_first_st,
input 		[ACTIONS_WIDTH-1:0] 		i_at,
output reg	[STATES_WIDTH-1:0] 		o_st,
output reg       							o_valid_st,
output       								o_valid
//output reg       							re_act_ram, 
//output       								we_act_ram,
//output reg       							valid_next_st,
//output       								valid_out_max,
//output	      							valid_out_q_up,
//output reg 	[STATES_WIDTH-1:0]		st_reg,
//output reg	[STATES_WIDTH-1:0]		next_st_reg
);
//-------------------------------------------------//
`include "params.sv"
//
localparam STAGES_PIPELINE = $clog2(ACTIONS);
//-------------Register for pipeline------------//
reg 		[DATA_WIDTH-1:0] 				q_reg;
reg		[DATA_WIDTH-1:0]  			rt_reg;
reg 		[ACTIONS_WIDTH-1:0]			at_reg;
reg 		[STATES_WIDTH-1:0]			st_reg;
reg		[STATES_WIDTH-1:0]			next_st_reg;
//----------------------------------------------//

//--------------------Bus------------------//
wire		[STATES_WIDTH-1:0]			next_st;
wire 		[DATA_WIDTH-1:0] 				rt;
wire 		[DATA_WIDTH-1:0] 				q;
wire 		[DATA_WIDTH*ACTIONS-1:0] 	next_q;
wire 		[DATA_WIDTH-1:0] 				max_q;
wire 		[DATA_WIDTH-1:0] 				q_new;
//-----------------------------------------//

//----------------valid---------------//
reg 	re_act_ram, we_act_ram;
wire 	valid_out_max, valid_out_q_up;
reg valid_next_st;
//------------------------------------//
assign we_act_ram = valid_out_q_up;
assign o_valid = valid_out_q_up;
//------------------------------------//

//----------------------Pipeline------------------------//
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rt_reg <= 'd0;
		q_reg <= 'd0;
		next_st_reg <= 'd0;
		st_reg <= 'd0;
		at_reg <= 'd0;
	end
	else begin
	//Import first state and action to design//
		if (i_start) begin	
			st_reg <= i_first_st;
			valid_next_st <= 1'b1;
		end
		else valid_next_st <= 1'b0;
		if (i_valid) begin
			at_reg <= i_at;
		end
		if (valid_next_st) begin	
			o_st <= st_reg;
			o_valid_st <= 1'b1;
		end
		else o_valid_st <= 1'b0;
	//---------------------------------------//
	//---------------------------------------//
		if (valid_out_q_up) begin
			valid_next_st <= 1'b1;
			st_reg <= next_st;
		end
		else begin
			if (valid_next_st) begin
				valid_next_st <= 1'b0;
				next_st_reg <= next_st;
				rt_reg <= rt;
				q_reg <= q;
				re_act_ram <= 1'b1;
			end
			else begin	
				if (re_act_ram) begin
					re_act_ram <= 1'b0;
				end
			end
		end
	//---------------------------------------//
	end
end
//--------------------------------------------------------//

//--------------------Component blocks of design-----------------------//
// 
	next_state next__state 
		(	.o_next_st(next_st),
			.i_st(st_reg), 
			.i_at(at_reg),  
			.i_valid(valid_next_st));	
//
	reward_rom reward 
		(	.o_rt(rt),
			.i_addr(next_st),
			.i_valid(valid_next_st));
//
	action_ram act_ram
		(	.o_q(q),
			.o_next_q(next_q),
			.i_data(q_new),
			.i_st(st_reg), 
			.i_next_st(next_st_reg),
			.i_re(re_act_ram),
			.i_we(we_act_ram),
			.i_at(at_reg),
			.i_write_file_en(i_finish),
			.clk(clk),
			.rst_n(rst_n));
//
	max_top max
		(	.o_data(max_q), 
			.o_valid(valid_out_max), 
			.i_data(next_q), 
			.i_valid(re_act_ram),
			.clk(clk), 
			.rst_n(rst_n));
//
	q_updater q_up 
		(	.o_q_new(q_new),
			.o_valid(valid_out_q_up),
			.i_q(q_reg), 
			.i_max_q(max_q), 
			.i_rt(rt_reg), 
			.i_valid(valid_out_max),
			.clk(clk),
			.rst_n(rst_n));
//---------------------------------------------------------------------//
endmodule



