module max_bottom
	#(	parameter CHANNELS = 4) // CHANNELS Input
	(	o_data, i_data, i_valid);

`include "params.sv"

input 													i_valid; // enable
input 	[DATA_WIDTH*CHANNELS-1:0] 				i_data; // data input bus
output 	[((CHANNELS+1)/2)*DATA_WIDTH-1:0] 	o_data; // data ouput bus		

wire 		[((CHANNELS+1)/2)*DATA_WIDTH-1:0] 	out_temp; // data ouput bus	

assign o_data = (i_valid) ? out_temp[((CHANNELS+1)/2)*DATA_WIDTH-1:0] : 'dz;

genvar i;
// generate max blocks to CHANNELS input
generate 
	// If CHANNELS is even number
	if (CHANNELS%2==0) begin 
		// Loop with (i += 2)
		for (i=0; i < CHANNELS; i=i+2) begin : generate_max_block_enven
			max_2_fp max_block_enven (
					.o_data(out_temp[(DATA_WIDTH*(i/2+1)-1):(DATA_WIDTH*(i/2))]), 
					.i_data_1(i_data[(DATA_WIDTH*(i+1)-1):(i*DATA_WIDTH)]), 
					.i_data_2(i_data[(DATA_WIDTH*(i+2)-1):((i+1)*DATA_WIDTH)]), 
					.i_valid(i_valid));
		end
	end
	// else CHANNELS is odd number
	else begin
		for (i=0; i < (CHANNELS-1); i=i+2) begin: generate_max_block_odd
			max_2_fp max_block_odd (
					.data_out(out_temp[(DATA_WIDTH*(i/2+1)-1):(DATA_WIDTH*(i/2))]), 
					.i_data_1(i_data[(DATA_WIDTH*(i+1)-1):(i*DATA_WIDTH)]), 
					.i_data_2(i_data[(DATA_WIDTH*(i+2)-1):((i+1)*DATA_WIDTH)]), 
					.i_valid(i_valid));
		end
		// assign the last data to output bus
		assign out_temp[(((CHANNELS+1)/2)*DATA_WIDTH)-1:(CHANNELS/2)*DATA_WIDTH] = i_data[DATA_WIDTH*CHANNELS-1:DATA_WIDTH*(CHANNELS-1)];
	end
endgenerate


endmodule
