module Random (const, at);
`include "params.v"
input [DATA_WIDTH-1:0] const;
output [ACTIONS_WIDTH-1:0] at;

always @(const) begin
end
endmodule
