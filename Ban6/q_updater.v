module q_updater 
	(	clk,
		rst_n,
		i_valid,
		i_q,
		i_max_q,
		i_rt,
		o_q_new,
		o_valid
	);
`include "params.sv"
//--------Input and output port---------//
input 							clk;
input								rst_n;
input 							i_valid;
input 	[DATA_WIDTH-1:0] 	i_q;
input 	[DATA_WIDTH-1:0] 	i_max_q;
input 	[DATA_WIDTH-1:0] 	i_rt;
output 	[DATA_WIDTH-1:0] 	o_q_new;
output							o_valid;
//--------------------------------------//
//--------------------------------------//
wire 		[DATA_WIDTH-1:0] 	out 	[3:0];
reg 		[DATA_WIDTH-1:0]	reg1 	[2:0];
reg 		[DATA_WIDTH-1:0]	reg2, reg3;
reg 		reg1_valid, reg2_valid, reg3_valid;
//--------------------------------------//
//---------------PIPELINE---------------//
always @(posedge clk) begin
// Reg 1
	reg1[0] <= out[0];
	reg1[1] <= out[1];
	reg1[2] <= i_q;
	reg1_valid <= i_valid;
// Reg 2
	reg2 <= out[2];
	reg2_valid <= reg1_valid;
// Reg 3
	reg3 <= out[3];
	reg3_valid <= reg2_valid;
end
//--------------------------------------//
multiple_fp cal_1 (out[0], gamma, i_max_q);
addition_fp cal_2 (out[1], i_rt, {~i_q[31], i_q[30:0]});
// Reg 1
addition_fp cal_3 (out[2], reg1[1], reg1[0]);
// Reg 2
multiple_fp cal_4 (out[3], reg2, alpha);
// Reg 3
addition_fp cal_5 (o_q_new, reg3, reg1[2]);
//--------------------------------------//
assign o_valid = reg3_valid;
//--------------------------------------//
endmodule 