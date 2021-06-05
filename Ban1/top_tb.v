`timescale 1ns/1ps
module top_tb ();
`include "params.sv"
parameter k = 50;
/*
reg valid_in, clk, rst;
reg [STATES_WIDTH-1:0] state;
reg [STATES_WIDTH-1:0] next_state;
reg [ACTIONS_WIDTH-1:0] action;
reg [DATA_WIDTH-1:0] reward;

top top_test 
	(	.valid_in(en), 
		.clk(clk), 
		.rst(rst), 
		.state(state), 
		.action(action), 
		.reward(reward),
		.q(q)
	);

reg [STATES_WIDTH-1:0] st, st_1;
reg [ACTIONS_WIDTH-1:0] at;
reg [DATA_WIDTH-1:0] rt;

initial begin
	clk <= 0;
	rst <= 0;
	valid_in = 0;
	#(k*4) clk <=1;
	rst <= 1;
	valid_in <= 1;
end

// read data from in.txt
read_input read_data 
	(	.state(state), 
		.next_state(next_state), 
		.action(action), 
		.reward(reward), 
		.valid_in(valid_in), 
		.valid_out(en), 
		.stop(stop_read), 
		.clk(clk)
	);

integer loop_var;
integer i, j;
always @(posedge clk) begin
	if (!rst) begin
		loop_var = 0;
	end
	else begin
		if (loop_var < LOOPS) begin		// number of loops = (parameter LOOPS)
			if (valid_in) begin
				st <= state;
				st_1 <= next_state;
				at <= action;
				rt <= reward;
				loop_var = loop_var + 1;	// <loop var> run from 0->LOOPS
			end
		end
		else // <read data> of [action_ram]
		if (loop_var >= LOOPS) begin				// when finish loops -> write data to file
			for (i=0; i<ACTIONS; i=i+1) begin	// i = action
				for (j=0; j<STATES; j=j+1) begin	// j = state 
					st <= j;
					at <= i;
					loop_var = loop_var + 1;
				end
			end
		end
	end
end

// ####### write data in [action_ram] to file ########//
wire stop;
assign stop = (loop_var == (LOOPS + ACTIONS*STATES)) ? 1 : 0;
write_file write_data 				// write data to file
	(	.data(q), 						// <data> = (qt) = <output> of [mux block] 
		.valid_in(valid_in_write), 
		.stop(stop), 					// when finish write to file
		.clk(clk)
	);


reg valid_in_write;
always @(posedge clk) begin
	if (loop_var > LOOPS && loop_var < ACTIONS*STATES) begin
		valid_in_write <= 1;
	end
	else valid_in_write <= 0;
end

always @(*) begin
	#k clk <= ~clk;
end
*/
endmodule
