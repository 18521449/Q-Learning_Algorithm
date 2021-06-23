module decoder (out, in, en);
`include "params.sv"

input en;
input [ACTIONS_WIDTH-1:0] in;
output [(2**ACTIONS_WIDTH)-1:0] out;

assign out = (en) ? 1 << in : 'd0;

endmodule

