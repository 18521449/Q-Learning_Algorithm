module max_top 
	(	clk,
		rst_n,
		i_valid,
		i_data,
		o_data,
		o_at_max,
		o_valid
	);
`include "params.sv"

localparam CHANNELS = ACTIONS;

//--------------------------Input and output port-----------------------------//
input 													clk;
input 													rst_n;
input 													i_valid; // enable
input 		[DATA_WIDTH*CHANNELS-1:0] 			i_data; // data input bus
output reg	[DATA_WIDTH-1:0]						o_data;
output reg	[ACTIONS_WIDTH-1:0]					o_at_max;
output reg 	 											o_valid;
//----------------------------------------------------------------------------//
reg 		[DATA_WIDTH*CHANNELS-1:0] 				data_ram_in 	[ACTIONS_WIDTH-1:0];
wire 		[DATA_WIDTH*((CHANNELS+1)/2)-1:0]	data_ram_out 	[ACTIONS_WIDTH-1:0]; 
reg 		[ACTIONS_WIDTH-1:0]						valid_in_max;	
//----------------------------------------------------------------------------//

//----------------Pineline to find max------------------//
integer k;
always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		for (k=0; k<ACTIONS_WIDTH-1; k=k+1) begin
			data_ram_in[k] <= 'd0;
		end
	end
	else begin
		for (k=0; k<ACTIONS_WIDTH-1; k=k+1) begin
			data_ram_in[k] <= data_ram_out[k+1];
			valid_in_max[k] <= valid_in_max[k+1];
		end
		if (i_valid) begin
			data_ram_in[ACTIONS_WIDTH-1] <= i_data;
			valid_in_max[ACTIONS_WIDTH-1] <= 1'b1;
		end
		else begin
			data_ram_in[ACTIONS_WIDTH-1] <= 'd0;
			valid_in_max[ACTIONS_WIDTH-1] <= 1'b0;
		end
		if (&valid_in_max) begin
			for (k=0; k<ACTIONS; k=k+1) begin
				if (data_ram_out[0][DATA_WIDTH-1:0] == data_ram_in[ACTIONS_WIDTH-1][DATA_WIDTH-1:0])
					o_at_max <= 'd0 + k;
				data_ram_in[ACTIONS_WIDTH-1] <= data_ram_in[ACTIONS_WIDTH-1] >> DATA_WIDTH;
			end
			o_data <= data_ram_out[0];
			o_valid <= 1;
		end
		else o_valid <= 0;
	end
end
//------------------------------------------------------//

//------------------------------max generate-------------------------------//
genvar i;
generate 
	// The number of blocks = the square root of the CHANNELS
	for (i=$clog2(CHANNELS); i>0; i=i-1) begin : generate_max_bottom
	// generate each block 
		max_bottom 
			#(	.CHANNELS(2**i))
			max
			(	.o_data(data_ram_out[i-1]),
				.i_data(data_ram_in[i-1])
			);
	end
endgenerate
//-------------------------------------------------------------------------//

endmodule
