module next_state (i_st, i_at, o_next_st, i_valid);
`include "params.sv"

input 									i_valid;
input 		[STATES_WIDTH-1:0] 	i_st;
input 		[ACTIONS_WIDTH-1:0] 	i_at;
output reg 	[STATES_WIDTH-1:0] 	o_next_st;

always @(i_st or i_at) begin
	if (i_valid) begin
		case(i_at)
			2'b00: begin // Up
				if (i_st >= 5'd5) begin
					o_next_st <= i_st - 5'd5;
				end
				else begin
					o_next_st <= i_st;
				end
			end
			2'b01: begin // Down
				if (i_st <= 5'd19) begin
					o_next_st <= i_st + 5'd5;
				end
				else begin
					o_next_st <= i_st;
				end
			end
			2'b10: begin // Right
				if (i_st == 5'd4 || i_st == 5'd9 || i_st == 5'd14 || i_st == 5'd19 || i_st == 5'd24) begin
					o_next_st <= i_st;
				end
				else begin
					o_next_st <= i_st + 5'd1;
				end
			end
			2'b11: begin // Left
				if (i_st == 5'd0 || i_st == 5'd5 || i_st == 5'd10 || i_st == 5'd15 || i_st == 5'd20) begin
					o_next_st <= 5'd0;
				end
				else begin
					o_next_st <= i_st - 5'd1;
				end
			end
			default: o_next_st <= i_st;
		endcase
	end
end
endmodule
