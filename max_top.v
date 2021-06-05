module max_top (out, in_data, en);
`include "params.sv"
parameter CHANNELS = ACTIONS;

input en; // enable
input [DATA_WIDTH*CHANNELS-1:0] in_data; // data input bus
output [((CHANNELS+1)/2)*DATA_WIDTH-1:0] out; // data ouput bus	

// create ram input bus and output bus
// then assign input <= output 
// then transmits the output of the before block to the input of after block
reg [DATA_WIDTH*CHANNELS-1:0] data_ram_in;
wire [DATA_WIDTH*((CHANNELS+1)/2)-1:0] data_ram_out; 

// output bus = <DATA_WIDTH> low bits of ram output bus
assign out = data_ram_out[DATA_WIDTH-1:0];

// initial assign ram input bus = input data bus 
initial data_ram_in = in_data;

// generate 
genvar i;
generate 
	// The number of blocks = the square root of the CHANNELS
	for (i=$clog2(CHANNELS)-1; i>=0; i=i-1) begin : generate_max_bottom
	// generate each block 
		max_bottom 
			#(	.CHANNELS(2**i))
			max (
				.en(en),
				.in_data(data_ram_in[DATA_WIDTH*(2**i)-1:0]),
				.out(data_ram_out[DATA_WIDTH*(((2**i)+1)/2)-1:0]));
		// After each block, assign ram input bus = ram output bus
		//data_ram_in[DATA_WIDTH*(((2**i)+1)/2)-1:0] = data_ram_out;
	end
endgenerate

endmodule
