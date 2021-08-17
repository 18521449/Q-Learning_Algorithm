module comparator_action 
	(	i_data_max,
		i_data,
		o_at_max
	);

`include "params.sv"
//--------------Input and output port----------------//
input 		[DATA_WIDTH-1:0] 				i_data_max;
input			[DATA_WIDTH*ACTIONS-1:0]	i_data;
output reg	[ACTIONS_WIDTH-1:0]			o_at_max;
//---------------------------------------------------//
wire [DATA_WIDTH-1:0] data_0;
wire [DATA_WIDTH-1:0] data_1;
wire [DATA_WIDTH-1:0] data_2;
wire [DATA_WIDTH-1:0] data_3;
//---------------------------------------------------//
assign data_0 = i_data[DATA_WIDTH*4-1:DATA_WIDTH*3];
assign data_1 = i_data[DATA_WIDTH*3-1:DATA_WIDTH*2];
assign data_2 = i_data[DATA_WIDTH*2-1:DATA_WIDTH*1];
assign data_3 = i_data[DATA_WIDTH*1-1:DATA_WIDTH*0];
//---------------------------------------------------//
//---------------------------------------------------//
always @(*) begin
	case(i_data_max)
		data_0: o_at_max <= 'd0;
		data_1: o_at_max <= 'd1;
		data_2: o_at_max <= 'd2;
		data_3: o_at_max <= 'd3;
		default: o_at_max <= 'd0;
	endcase
end
//---------------------------------------------------//
endmodule

