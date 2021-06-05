module max_2_fp (out, in_a, in_b, en, clk);

input en, clk;
input [31:0] in_a;
input [31:0] in_b;
output [31:0] out;

wire [31:0] sub;
reg [31:0] out_temp;
reg valid_in;

always @(posedge clk) begin
	if (en) begin
		valid_in = 1;
	end
	out_temp = (sub[31]) ? in_b : in_a;
end
addition_fp add (sub, in_a, {1'b1, in_b[30:0]}, valid_in);

assign out = (valid_in) ? out_temp : 32'dz;

endmodule

