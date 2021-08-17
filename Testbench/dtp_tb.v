`timescale 1ns/1ps
module dtp_tb();
`include "params.sv" 
parameter k = 20;

//-----------Input and output port-------------//
reg 													 clk;
reg 													 rst_n;
reg 										       i_valid;
reg 										       i_write_file_en;
reg 		[COUNTER_WIDTH-1:0]		i_count;
reg 		[COUNTER_WIDTH-1:0]		i_step;
reg 		[ACTIONS_WIDTH-1:0]		i_at_random;
reg 		[STATES_WIDTH-1:0] 		i_first_st;
wire									         o_valid;
//--------------------------------------------//  

initial begin
  clk <= 0;
  rst_n <= 0;
  #k#k rst_n <= 1;
  i_valid <= 1;
	i_write_file_en <= 0;
	i_count <= 'd0;
	i_step <= 'd0;
	i_first_st <= 'd0;
end 

datapath dtp
	(	clk,
		rst_n,
		i_valid,
		i_write_file_en,
		i_count,
		i_step,
		i_first_st,
		i_at_random,
		o_re_random,
		o_valid
	);


always @(posedge clk) begin
  i_at_random <= $urandom%3;
  if (o_valid) begin
    #k#k#k#k $finish;
  end
end

always @(*)
  #k clk <= ~clk;

endmodule




