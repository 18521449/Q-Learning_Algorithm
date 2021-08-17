module max_2_fp (o_data, i_data_1, i_data_2);

input 	[31:0] 	i_data_1;
input 	[31:0] 	i_data_2;
output 	[31:0] 	o_data;

wire 		[31:0] 	sub;

addition_fp add (sub, i_data_1, {~i_data_2[31], i_data_2[30:0]});
assign o_data = (sub[31]) ? i_data_2 : i_data_1;

endmodule

