module top 
	(	clk,
		rst_n,
		i_valid,
		i_start,
		i_first_st,
		o_valid
	);
`include "params.sv"

//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 										i_start;
input			[STATES_WIDTH-1:0]		i_first_st;
output reg 									o_valid;
//------------------------------------------------//

//--------------------bus--------------------//
wire 		[STATES_WIDTH-1:0]			st;
wire		[STATES_WIDTH-1:0]			next_st;
wire 		[ACTIONS_WIDTH-1:0]			at;
wire		[DATA_WIDTH-1:0]  			rt;
//-------------------------------------------//

//--------valid--------//
wire o_valid_ctrl;
wire o_valid_dtp;
wire we;
//---------------------//

always @(posedge clk) begin
	if (we) begin
		o_valid <= 1;
	end
	else o_valid <= 0;
end

//------------datapath------------//
	datapath DATAPATH
		(	.clk(clk),
			.rst_n(rst_n),
			.i_valid(o_valid_ctrl),
			.i_write_file_en(we),
			.i_st(st),
			.i_next_st(next_st),
			.i_at(at),
			.i_rt(rt),
			.o_at_max(at_max),
			.o_valid(o_valid_dtp)
		);
//--------------------------------//

//-----------controller-----------//
	controller CONTROLLER
		(	.clk(clk),
			.rst_n(rst_n),
			.i_valid(o_valid_dtp),
			.i_start(i_start),
			.i_first_st(i_first_st),
			.i_at_max(at_max),
			.o_st(st),
			.o_next_st(next_st),
			.o_at(at),
			.o_rt(rt),
			.o_write_file_en(we),
			.o_valid(o_valid_ctrl)
		);
//--------------------------------//
endmodule



