module q_updater (q_new, q, max_q, rt, valid_in);
`include "params.sv"
input valid_in;
input [31:0] q, max_q;
input [31:0] rt;
output [31:0] q_new;

wire [31:0] out_1, out_2, out_3, out_4;

multiple_fp mul_1 (out_1, gamma, max_q, valid_in);
addition_fp add_1 (out_2, out_1, rt, valid_in);
addition_fp add_2 (out_3, out_2, {1'b1,q[30:0]}, valid_in);
multiple_fp mul_2 (out_4, out_3, alpha, valid_in);
addition_fp add_3 (q_new, out_4, q, valid_in);

endmodule




/*module q_updater (q_new, q, max_q, rt, valid_in, valid_out, clk, rst_n);
`include "params.sv"

input 							clk;
input 							rst_n;
input 							valid_in;
input 	[DATA_WIDTH-1:0] 	q, max_q;
input 	[DATA_WIDTH-1:0] 	rt;
output 	[DATA_WIDTH-1:0] 	q_new;
output 							valid_out;

wire 		[DATA_WIDTH-1:0] 	out_1, out_2, out_3, out_4;
reg 		[DATA_WIDTH-1:0]	Reg [0:2];
reg 								VReg;


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		Reg [0] <= 32'd0;
		Reg [1] <= 32'd0;
	end
	else begin
		Reg[0] <= out_1;
		Reg[1] <= out_3;
		VReg   <= valid_out_2 && valid_out_1;
	end
end

multiple_fp mul_alpha_n (out_1, q, alpha_n, valid_in, valid_out_1);
multiple_fp mul_gama (out_2, gamma, max_q, valid_in, valid_out_2);


addition_fp add_rt (out_3, out_2, rt, valid_out_2);

multiple_fp mul_alpha (out_4, Reg[1], alpha, VReg, valid_out);
addition_fp add_q (q_new, Reg[0], out_4, valid_out);
	

endmodule 
*/