module q_updater (o_q_new, i_q, i_max_q, i_rt, i_valid, o_valid, clk, rst_n);
`include "params.sv"

input 								clk;
input									rst_n;
input 								i_valid;
input 		[DATA_WIDTH-1:0] 	i_q;
input 		[DATA_WIDTH-1:0] 	i_max_q;
input 		[DATA_WIDTH-1:0] 	i_rt;
output reg	[DATA_WIDTH-1:0] 	o_q_new;
output reg							o_valid;

wire 			[DATA_WIDTH-1:0] 	out_1, out_2, out_3, out_4;
wire 									valid_out_cal_1, valid_out_cal_2, valid_out_cal_3, valid_out_cal_4;
reg 									valid_in_cal;
reg 			[DATA_WIDTH-1:0] 	q, max_q;
wire			[DATA_WIDTH-1:0] 	q_new;
wire 									valid_out;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
	end
	else begin
		if (i_valid) begin
			valid_in_cal <= 1'b1;
			q <= i_q;
			max_q <= i_max_q;
		end
		else begin
			valid_in_cal <= 1'b0;
		end
		if (valid_out) begin
			o_q_new <= q_new;
			o_valid <= 1;
		end
		else begin
			o_q_new <= 'dz;
			o_valid <= 0;
		end
	end
end

multiple_fp cal_1 (out_1, gamma, max_q, valid_in_cal, valid_out_cal_1);
addition_fp cal_2 (out_2, i_rt, {~q[31],q[30:0]}, valid_in_cal, valid_out_cal_2);
addition_fp cal_3 (out_3, out_1, out_2, valid_out_cal_1 & valid_out_cal_2, valid_out_cal_3);
multiple_fp cal_4 (out_4, out_3, alpha, valid_out_cal_3, valid_out_cal_4);
addition_fp cal_5 (q_new, out_4, i_q, valid_out_cal_4, valid_out);

endmodule 