module next_state (st, at, next_state, valid_in, valid_out);
`include "params.v"

input valid_in;
input [STATES_WIDTH-1:0] st;
input [ACTIONS_WIDTH-1:0] at;
output reg [STATES_WIDTH-1:0] next_state;
output reg valid_out;

//integer rand_at;

// function for next state
//function [STATES_WIDTH-1:0] next_state;
//input [STATES_WIDTH-1:0] st;
//input [ACTIONS_WIDTH-1:0] at;
//begin 
always @(st or at) begin
	//rand_at = $random_at(at);
	case(at)
		2'b00: begin // Up
			if (st >= 5'd5) begin
				next_state <= st - 5'd5;
			end
			else begin
				next_state <= st;
			end
		end
		2'b01: begin // Down
			if (st <= 5'd19) begin
				next_state <= st + 5'd5;
			end
			else begin
				next_state <= st;
			end
		end
		2'b10: begin // Right
			if (st == 5'd4 || st == 5'd9 || st == 5'd14 || st == 5'd19 || st == 5'd24) begin
				next_state <= st;
			end
			else begin
				next_state <= st + 5'd1;
			end
		end
		2'b11: begin // Left
			if (st == 5'd0 || st == 5'd5 || st == 5'd10 || st == 5'd15 || st == 5'd20) begin
				next_state <= 5'd0;
			end
			else begin
				next_state <= st - 5'd1;
			end
		end
		default: next_state <= st;
	endcase
	if (next_state == st) begin
		valid_out <= 0;
	end
	else begin
		valid_out <= 1;
	end
end
endmodule
