module action_ram 
	(	input clk,
		input we, // Write Enable
		input [STATES_WIDTH-1:0] st, 
		input [STATES_WIDTH-1:0] st_1,
		input [DATA_WIDTH-1:0] in_data,
		output reg [DATA_WIDTH-1:0] out_qt,
		output reg [DATA_WIDTH-1:0] out_qt_1);
		
`include "params.sv"

reg [DATA_WIDTH-1:0] ram [(STATES_WIDTH**2)-1:0];
always @(negedge clk) begin // write data -> negedge clk
	if (we) 
		ram [st] <= in_data;
end
always @(posedge clk) begin // read data -> posedge clk
	out_qt <= ram[st];
	out_qt_1 <= ram[st_1];
end

endmodule
