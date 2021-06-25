`timescale 1ns/1ps
module top_tb();
parameter k = 50;
parameter LOOPS = 300;
`include "params.sv"

reg 								          clk;
reg 								          rst_n;
reg 								          valid_in;
reg                       start;
reg                       finish;
reg 	 [ACTIONS_WIDTH-1:0] at;
reg 	 [STATES_WIDTH-1:0] 	first_st;
wire	 [STATES_WIDTH-1:0] 	st;
wire                      vaid_st;
wire 		 						          valid_out;
wire       							valid_out_max;
wire 		[DATA_WIDTH-1:0] 			rt;
wire		[DATA_WIDTH-1:0] 			q;
wire 		[DATA_WIDTH-1:0] 			max_q;

top qlearn 
  ( .o_st(st), 
    .o_valid_st(valid_st), 
    .o_valid(valid_out), 
    .i_valid(valid_in), 
    .i_start(start), 
    .i_finish(finish), 
    .i_first_st(first_st), 
    .i_at(at), 
    .clk(clk), 
    .rst_n(rst_n),
    .valid_out_max(valid_out_max),
    .rt(rt), 
    .q(q), 
    .max_q(max_q)
);

integer fd;
initial begin
	fd = $fopen(STATE_FILE, "w");
	finish <= 1'b0;
	clk <= 1'b0;
	rst_n <= 1'b0;
	valid_in <= 1'b0;
	start <= 1'b0;
	first_st <= 'd0;
	#k#k rst_n <= 1'b1;
	valid_in <= 1'b1;
	start <= 1'b1;
	at <= $random%3;
	#k#k valid_in <= 1'b0;
	start <= 1'b0;
end

integer dem = 0;
always @(posedge clk) begin
	if (dem<LOOPS) begin
		if (valid_out_max) begin
		  valid_in <= 1'b1;
		  at <= $random%3;
		  dem = dem + 1;
		  $fwriteb(fd, st);
		  $fwriteb(fd, "\n");
		end 
		else begin
		  if (dem>0) begin
		    valid_in <= 1'b0;
		  end
		end
	end
	else begin
	  finish <= 1'b1;
	  #k $finish;
	end
end

always @(clk) begin
  #k clk <= ~clk;
end
endmodule



