module mux (o_data, i_data, i_sel, i_valid);
`include "params.sv"
localparam SEL_WIDTH = ACTIONS_WIDTH;
localparam CHANNELS = ACTIONS;

input 										i_valid;
input 	[DATA_WIDTH*CHANNELS-1:0] 	i_data; // data input bus
input 	[SEL_WIDTH-1:0]				i_sel; // select signal
output 	[DATA_WIDTH-1:0] 				o_data; // data output

// data output = data input bus shift to the right select bits
assign o_data = (i_valid) ? i_data >> (i_sel * DATA_WIDTH) : 'dz;

endmodule
