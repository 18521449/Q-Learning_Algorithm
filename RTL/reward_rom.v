module reward_rom 
	(	i_st,
		o_rt
	);
`include "params.sv"
//----------------Input and output port-----------//
input 		[STATES_WIDTH-1:0] 	i_st;
output reg 	[DATA_WIDTH-1:0] 		o_rt;
//------------------------------------------------//
reg 			[DATA_WIDTH-1:0] 		rom 	[2**STATES_WIDTH-1:0];
//------------------------------------------------//
initial begin
	$readmemb(REWARD_FILE, rom);
end
//------------------------------------------------//
always @(i_st) begin
	o_rt <= rom[i_st];
end
//------------------------------------------------//
endmodule 