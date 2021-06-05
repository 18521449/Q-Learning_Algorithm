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
