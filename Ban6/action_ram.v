module action_ram 
	(	clk, 
		rst_n,
		i_write_file_en,
		i_re,
		i_we,
		i_at,
		i_st,
		i_next_st,
		i_data,
		o_q,
		o_next_q,
		o_valid
	);
`include "params.sv"
//--------------Input and output port-----------------//
input 								   		clk;
input 											rst_n;
input 											i_write_file_en;
input 											i_re; // read enable
input 											i_we; // write enable
input 		[ACTIONS_WIDTH-1:0]			i_at; // write address
input 		[STATES_WIDTH-1:0]			i_st;
input 		[STATES_WIDTH-1:0] 			i_next_st;
input 		[DATA_WIDTH-1:0] 				i_data;
output reg 	[DATA_WIDTH-1:0] 				o_q;
output reg 	[DATA_WIDTH*ACTIONS-1:0] 	o_next_q;
output reg 										o_valid;
//----------------------------------------------------//
reg 	[DATA_WIDTH-1:0] 	ram 	[0:STATES*ACTIONS-1];
//----------------------------------------------------//
//----------------------------------------------------//
integer i;
always @(posedge clk) begin
	if (i_re) begin
		o_q <= ram[STATES*i_at + i_st];
		for (i=ACTIONS-1; i>=0; i=i-1) begin
			o_next_q = o_next_q << DATA_WIDTH;
			o_next_q = o_next_q | ram[STATES*i + i_next_st];
		end
		o_valid <= 1;
	end
	else o_valid <= 0;
	// Write q table to file
	if (i_write_file_en) begin
		$writememb(QTABLE_FILE, ram);
	end
end
//----------------------------------------------------//
//----------------------------------------------------//
always @(negedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (i=0; i<STATES*ACTIONS; i=i+1) begin
			ram[i] <= 'd0;
		end	
	end
	else begin
		if (i_we) begin
			ram[STATES*i_at + i_st] <= i_data;
		end
	end
end
//----------------------------------------------------//
endmodule
