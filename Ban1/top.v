module top
		(	input valid_in,
			input clk,
			input rst,
			input [STATES_WIDTH-1:0] st,
			input [STATES_WIDTH-1:0] st_1,
			input [ACTIONS_WIDTH-1:0] at,
			input [DATA_WIDTH-1:0] rt,
			output [DATA_WIDTH-1:0] q			// <out of mux> to <write data> to <out file>
		);

`include "params.sv"

wire [DATA_WIDTH*ACTIONS-1:0] out_qt;
wire [DATA_WIDTH*ACTIONS-1:0] out_qt_1;

// generate action_ram blocks
action_ram act_ram [ACTIONS-1:0]
			(	.clk(clk),
				.we(select), // Write Enable
				.st(st), 
				.st_1(st_1),
				.in_data(q_new),
				.out_qt(out_qt),
				.out_qt_1(out_qt_1));

wire [ACTIONS-1:0] select;
wire [DATA_WIDTH-1:0] max_q, q_new;

// decoder for at
decoder dec (.en(valid_in), .in(at), .out(select));

// mux: <input> = <output> (qt) of [action_ram]
mux muxx
	(	.en(valid_in), 	// enable	
		.in_data(out_qt), // data input bus
		.sel(at), 			// select signal
		.out(q) 				// data output
	); 
		
// max: <input> = <output> (qt_1) of [action_ram]
max_top maxx
	(	.en(valid_in), 		// enable
		.in_data(out_qt_1), 	// data input bus
		.out(max_q)				// data output
	);

// q_update: update (q_new) to [action_ram]
q_updater q_up (q_new, q, max_q, rt, valid_in);

endmodule



