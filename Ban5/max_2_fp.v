module max_2_fp (o_data, i_data_1, i_data_2, i_valid);

input 				i_valid;
input 	[31:0] 	i_data_1;
input 	[31:0] 	i_data_2;
output 	[31:0] 	o_data;

wire 		[31:0] 	sub;
wire 		[31:0]	data_temp;
wire 					valid_out;

assign data_temp = (sub[31]) ? i_data_2 : i_data_1;
assign o_data = (valid_out) ? data_temp : 32'dz;

addition_fp add (sub, i_data_1, {~i_data_2[31], i_data_2[30:0]}, i_valid, valid_out);

endmodule

