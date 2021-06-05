module decoder (out, in, en);
`include "params.sv"
parameter WIDTH = ACTIONS_WIDTH;

input en;
input [WIDTH-1:0] in;
output [(2**WIDTH)-1:0] out;

assign out = (en) ? 1 << in : 0;

endmodule

