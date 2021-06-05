module mux (out, in_data, sel, en);
`include "params.sv"
parameter SEL_WIDTH = ACTIONS_WIDTH;
parameter CHANNELS = ACTIONS;
		
input en; // enable
input [DATA_WIDTH*CHANNELS-1:0] in_data; // data input bus
input [SEL_WIDTH-1:0] sel; // select signal
output [DATA_WIDTH-1:0] out; // data output

// data output = data input bus shift to the right select bits
assign out = (en) ? in_data >> (sel * DATA_WIDTH) : 0;

endmodule
