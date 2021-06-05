module max_bottom
	#(	parameter CHANNELS = ACTIONS) // CHANNELS Input
	(	out, in_data, valid_in, valid_out, clk);

`include "params.sv"

input valid_in, clk; // enable
input [DATA_WIDTH*CHANNELS-1:0] in_data; // data input bus
output [((CHANNELS+1)/2)*DATA_WIDTH-1:0] out; // data ouput bus		
output reg valid_out;

wire [((CHANNELS+1)/2)*DATA_WIDTH-1:0] out_temp; // data ouput bus	

always @(posedge clk) begin
	if (valid_in) begin
		valid_out <= 1;
	end
	else begin
		valid_out <= 0;
	end
end


genvar i;
// generate max blocks to CHANNELS input
generate 
	// If CHANNELS is even number
	if (CHANNELS%2==0) begin 
		// Loop with (i += 2)
		for (i=0; i < CHANNELS; i=i+2) begin : generate_max_block_enven
			max_2_fp max_block_enven (
					.out(out_temp[(DATA_WIDTH*(i/2+1)-1):(DATA_WIDTH*(i/2))]), 
					.in_a(in_data[(DATA_WIDTH*(i+1)-1):(i*DATA_WIDTH)]), 
					.in_b(in_data[(DATA_WIDTH*(i+2)-1):((i+1)*DATA_WIDTH)]), 
					.en(valid_in),
					.clk(clk));
		end
	end
	// else CHANNELS is odd number
	else begin
		for (i=0; i < (CHANNELS-1); i=i+2) begin: generate_max_block_odd
			max_2_fp max_block_odd
					(.out(out_temp[(DATA_WIDTH*(i/2+1)-1):(DATA_WIDTH*(i/2))]), 
					.in_a(in_data[(DATA_WIDTH*(i+1)-1):(i*DATA_WIDTH)]), 
					.in_b(in_data[(DATA_WIDTH*(i+2)-1):((i+1)*DATA_WIDTH)]), 
					.en(valid_in),
					.clk(clk));
		end
		// assign the last data to output bus
		assign out_temp[(((CHANNELS+1)/2)*DATA_WIDTH)-1:(CHANNELS/2)*DATA_WIDTH] = in_data[DATA_WIDTH*CHANNELS-1:DATA_WIDTH*(CHANNELS-1)];
	end
endgenerate

assign out = (valid_out) ? out_temp : 32'dz;

endmodule
