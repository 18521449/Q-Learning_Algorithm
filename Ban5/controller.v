module controller
	(	clk,
		rst_n,
		i_valid,
		i_start,
		i_first_st,
		i_at_max,
		o_st,
		o_next_st,
		o_at,
		o_rt,
		o_write_file_en,
		o_valid
	);
`include "params.sv"
//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 										i_start;
input			[STATES_WIDTH-1:0]		i_first_st;
input		 	[ACTIONS_WIDTH-1:0] 		i_at_max;
output reg	[STATES_WIDTH-1:0] 		o_st;
output reg	[STATES_WIDTH-1:0] 		o_next_st;
output reg	[ACTIONS_WIDTH-1:0] 		o_at;
output reg	[DATA_WIDTH-1:0] 			o_rt;
output reg									o_write_file_en;
output reg 									o_valid;
//------------------------------------------------//

//--------------------------------------------------------//
reg [DATA_WIDTH-1:0] reward_rom 	[2**STATES_WIDTH-1:0];
//--------------------------------------------------------//

//-------------------register-------------------//
reg 		[STATES_WIDTH-1:0]			st;
reg		[STATES_WIDTH-1:0]			next_st;
reg 		[ACTIONS_WIDTH-1:0]			at;
reg		[DATA_WIDTH-1:0]  			rt;
//----------------------------------------------//

//-------------------valid-------------------//
reg valid_out_delay;
//-------------------------------------------//

//-----------------control valid---------------------//
integer count;
always @(posedge clk) begin
	if (i_start) begin
		st <= i_first_st;
		valid_out_delay <= 1;
		count = 0;
	end
	else begin
		if (i_valid) begin
			st <= next_st;
			valid_out_delay <= 1;
		end
		else begin
			if (valid_out_delay) begin
				o_valid <= 1;	
				valid_out_delay <= 0;
			end
			if (count < NUMBER_OF_LOOP) begin
				o_st <= st;
				o_next_st <= next_st;
				o_at <= at;
				o_rt <= rt;
				o_write_file_en <= 0;
				count = count + 1;
			end
			else begin
				o_st <= 'dz;
				o_next_st <= 'dz;
				o_at <= 'dz;
				o_rt <= 'dz;
				o_write_file_en <= 1;
				count = 0;
			end
		end
	end
end
//---------------------------------------------------//

//----------load reward from rom----------//
initial begin
	$readmemb(REWARD_FILE, reward_rom);
end

always @(next_st) begin
	rt <= reward_rom[next_st];
end
//----------------------------------------//

//------------------------------------find next state---------------------------------------//
integer i;
always @(at or st) begin
	if (i_valid) begin
		if (count > NUMBER_OF_LOOP/2) begin
			at = i_at_max;
		end
		else at = 2'b00;
	end
	for (i=0; i<ACTIONS; i=i+1) begin
		case(at)
			2'b00: begin // Up
				if (st >= 5'd5) begin
					next_st = st - 5'd5;
				end
				else begin
					at = at + 1;
				end
			end
			2'b01: begin // Down
				if (st <= 5'd19) begin
					next_st = st + 5'd5;
				end
				else begin
					at = at + 1;
				end
			end
			2'b10: begin // Right
				if (st == 5'd4 || st == 5'd9 || st == 5'd14 || st == 5'd19 || st == 5'd24) begin
					at = at + 1;
				end
				else begin
					next_st = st + 5'd1;
				end
			end
			2'b11: begin // Left
				if (st == 5'd0 || st == 5'd5 || st == 5'd10 || st == 5'd15 || st == 5'd20) begin
					at = at + 1;
				end
				else begin
					next_st = st - 5'd1;
				end
			end
			default: at = at + 1;
		endcase
	end
end
//------------------------------------------------------------------------------------------//
endmodule
