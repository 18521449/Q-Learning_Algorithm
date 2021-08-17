module update_state
	(	i_st,
		i_at,
		o_next_st,
		o_re_random
	);
`include "params.sv"

//----------------Input and output port-----------//
input 		[ACTIONS_WIDTH-1:0] 		i_at;
input			[STATES_WIDTH-1:0] 		i_st;
output reg	[STATES_WIDTH-1:0] 		o_next_st;
output reg 									o_re_random;
//------------------------------------------------//

always @(i_st or i_at) begin
	case(i_at)
		2'b00: begin // Right
			if (i_st == 5'd4 || i_st == 5'd9 || i_st == 5'd14 || i_st == 5'd19 || i_st == 5'd24) begin
				o_next_st <= i_st;
				o_re_random <= 1;
			end
			else begin
				o_next_st <= i_st + 5'd1;
				o_re_random <= 0;
			end
		end
		2'b01: begin // Up
			if (i_st >= 5'd5) begin
				o_next_st <= i_st - 5'd5;
				o_re_random <= 0;
			end
			else begin
				o_next_st <= i_st;
				o_re_random <= 1;
			end
		end
		2'b10: begin // Left
			if (i_st == 5'd0 || i_st == 5'd5 || i_st == 5'd10 || i_st == 5'd15 || i_st == 5'd20) begin
				o_next_st <= i_st;
				o_re_random <= 1;
			end
			else begin
				o_next_st <= i_st - 5'd1;
				o_re_random <= 0;
			end
		end
		2'b11: begin // Down
			if (i_st <= 5'd19) begin
				o_next_st <= i_st + 5'd5;
				o_re_random <= 0;
			end
			else begin
				o_next_st <= i_st;
				o_re_random <= 1;
			end
		end
		default: begin
			o_next_st <= i_st;
			o_re_random <= 1;
		end
	endcase
end
endmodule