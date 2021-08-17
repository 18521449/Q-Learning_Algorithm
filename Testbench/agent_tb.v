`timescale 1ns/1ps
module agent_tb();
`include "params.sv" 
parameter k = 20;

//--------------------------Input and output port-----------------------------//
reg 													        clk;
reg 													        rst_n;
reg 													        i_valid; // enable
reg   [COUNTER_WIDTH-1:0]		       i_count;
reg 		[ACTIONS_WIDTH-1:0]		       i_at_max;
reg 		[ACTIONS_WIDTH-1:0]		       i_at_random;
reg 		[STATES_WIDTH-1:0] 		       i_first_st;
wire	 [STATES_WIDTH-1:0] 		       o_st;
wire	 [STATES_WIDTH-1:0] 	        o_next_st;
wire	 [ACTIONS_WIDTH-1:0] 		      o_at;
wire 										              o_re_random;
wire									                o_valid;
//----------------------------------------------------------------------------//  

initial begin
  clk <= 0;
  rst_n <= 0;
  #k#k rst_n <= 1;
  i_valid <= 1;
  i_count <= 'd0;
	i_first_st <= 'd0;
	#k#k i_valid <= 0;
end 

agent agent_test
	(	clk,
		rst_n,
		i_valid,
		i_count,
		i_at_max,
		i_at_random,
		i_first_st,
		o_st,
		o_next_st,
		o_at,
		o_re_random,
		o_valid
	);


always @(posedge clk) begin
  if (o_re_random) begin
    i_at_random <= $urandom%3;
    i_at_max <= $urandom%3;
    i_count <= i_count + 1;
  end
  if (i_count == 300) begin
    #k#k#k#k $finish;
  end
end

always @(*)
  #k clk <= ~clk;

endmodule
