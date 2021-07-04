module max_top (o_data, o_valid, i_data, i_valid, clk, rst_n);
`include "params.sv"

localparam CHANNELS = ACTIONS;

//-------------------------Input and output port---------------------------//
input 												clk;
input 												rst_n;
input 												i_valid; // enable
input 	[DATA_WIDTH*CHANNELS-1:0] 			i_data; // data input bus
output 	[DATA_WIDTH-1:0]						o_data;
output 	 											o_valid;
//-------------------------------------------------------------------------//

//-----------Test port-----------//
//wire [63:0] data_ram_out0 ,data_ram_out1;
//assign data_ram_out0 = data_ram_out[0];
//assign data_ram_out1 = data_ram_out[1];
//
// - create ram input bus and output bus
// - then assign input <= output 
// - then transmits the output of the before block to the input of after block
reg 		[DATA_WIDTH*CHANNELS-1:0] 			data_ram_in 	[0:ACTIONS_WIDTH-1];
wire 	[DATA_WIDTH*((CHANNELS+1)/2)-1:0]	data_ram_out 	[0:ACTIONS_WIDTH-1]; 
reg 													valid_in_max 	[0:ACTIONS_WIDTH-1];
//---------------------------------------------------------------------------//

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
			max (
				.o_data(data_ram_out[i-1]),
				.i_data(data_ram_in[i-1]),
				.i_valid(valid_in_max[i-1]));
	end
endgenerate
//-------------------------------------------------------------------------//
//
assign o_valid = valid_in_max[0];
// output bus = <DATA_WIDTH> low bits of ram output bus
assign o_data = (o_valid) ? data_ram_out[0] : 'dz;
//
endmodule
