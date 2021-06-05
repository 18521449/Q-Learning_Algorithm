parameter DATA_WIDTH = 32;
parameter STATES = 25;
parameter ACTIONS = 4;
parameter STATES_WIDTH = $clog2(STATES);
parameter ACTIONS_WIDTH = $clog2(ACTIONS);
parameter [31:0] gamma = 32'h3f4ccccc; // gamma = 0.8
parameter [31:0] alpha = 32'h3f4ccccc; // alpha = 0.8
parameter LOOPS = 300;
parameter REWARD_FILE = "reward.txt";
parameter INPUT_FILE = "in.txt";
parameter OUTPUT_FILE = "out.txt";

// function for clog2
function integer clog2;
input integer value;
begin
	value = value-1;
	for (clog2=0; value>0; clog2=clog2+1)
		value = value>>1;
end
endfunction


/*
// function for random action
function [ACTIONS_WIDTH-1:0] random_at;
input [ACTIONS_WIDTH-1:0] at;
begin 
	random_at = $urandom_range(ACTIONS-1);
end
endfunction


// function for next state
function [STATES_WIDTH-1:0] next_state;
input [STATES_WIDTH-1:0] st;
input [ACTIONS_WIDTH-1:0] at;
begin 
	case(at)
		2'b00: begin // Up
			if (st >= 5'd5) begin
				next_state <= st - 5'd5;
			end
			else begin
				next_state <= 5'd0;
			end
		end
		2'b01: begin // Down
			if (st <= 5'd19) begin
				next_state <= st + 5'd5;
			end
			else begin
				next_state <= 5'd0;
			end
		end
		2'b10: begin // Right
			if (st == 5'd4 || st == 5'd9 || st == 5'd14 || st == 5'd19 || st == 5'd24) begin
				next_state <= 5'd0;
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
		default: next_state <= 5'd0;
	endcase
end
endfunction
*/