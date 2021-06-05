module top_max
	#(	parameter CHANNELS = 8,
		parameter DATA_WIDTH = 32)
	(	input en, // enable
		input [DATA_WIDTH*CHANNELS-1:0] in_data, // data input bus
		output [DATA_WIDTH-1:0] out); // data output bus
		
// create ram input bus and output bus
// then assign input <= output 
// then transmits the output of the before block to the input of after block
wire [DATA_WIDTH*CHANNELS-1:0] data_ram_in;
wire [DATA_WIDTH*((CHANNELS+1)/2)-1:0] data_ram_out; 

// output bus = <DATA_WIDTH> low bits of ram output bus
assign out = data_ram_out[DATA_WIDTH-1:0];

// initial assign ram input bus = input data bus 
assign data_ram_in = in_data;

// generate 
genvar i;

generate 
	// The number of blocks = the square root of the CHANNELS
	for (i=$clog2(CHANNELS)-1; i>=0; i=i-1) begin : generate_max_bottom
	
	// generate each block 
		max_bottom 
			#(	.CHANNELS(2**i),
				.DATA_WIDTH(DATA_WIDTH)) 
			max (
				.en(en),
				.in_data(data_ram_in[DATA_WIDTH*(2**(i+1))-1:0]),
				.out(data_ram_out[DATA_WIDTH*(2**i)-1:0]));
				
		// After each block, assign ram output bus = ram input bus
		assign data_ram_out[DATA_WIDTH*(2**i)-1:0] = data_ram_in[DATA_WIDTH*(2**i)-1:0];
	end
endgenerate

// function for clog2
function integer clog2;
input integer value;
begin
	value = value-1;
	for (clog2=0; value>0; clog2=clog2+1)
		value = value>>1;
end
endfunction

endmodule
