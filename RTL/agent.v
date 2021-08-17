module agent 
	(	clk,
		rst_n,
		i_valid,
		i_count,
		i_step,
		//i_at_max,
		i_at_random,
		i_first_st,
		o_st,
		o_next_st,
		o_at,
		o_valid
	);
`include "params.sv"
//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 		[COUNTER_WIDTH-1:0]		i_count;
input 		[COUNTER_WIDTH-1:0]		i_step;
//input 		[ACTIONS_WIDTH-1:0]		i_at_max;
input 		[ACTIONS_WIDTH-1:0]		i_at_random;
input 		[STATES_WIDTH-1:0] 		i_first_st;
output reg	[STATES_WIDTH-1:0] 		o_st;
output 		[STATES_WIDTH-1:0] 		o_next_st;
output reg	[ACTIONS_WIDTH-1:0] 		o_at;
output reg									o_valid;
//------------------------------------------------//
reg 	[STATES_WIDTH-1:0] 	next_st_reg;
wire								re_random;
reg 								valid_delay;
//------------------------------------------------//
always @(posedge clk or negedge rst_n) begin
	if (!rst_n)
		next_st_reg <= 'd0;
	else begin
		if (i_valid) begin
			o_at <= i_at_random;
			if (i_step == 0)
				o_st <= i_first_st;
			else o_st <= next_st_reg;
			valid_delay <= 1;
		end
		else begin
			if (valid_delay && re_random) begin
				o_at <= i_at_random;
				o_valid <= 0;
			end
			else if (valid_delay && ~re_random) begin
				valid_delay <= 0;
				o_valid <= 1;
			end
			else o_valid <= 0;
		end
		next_st_reg <= o_next_st;
	end
end
//------------------------------------------------//
update_state update_state_block
	(	.i_st(o_st),
		.i_at(o_at),
		.o_next_st(o_next_st),
		.o_re_random(re_random)
	);
//------------------------------------------------//
endmodule
