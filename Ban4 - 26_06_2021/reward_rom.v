module reward_rom (i_addr, o_rt, i_valid);
`include "params.sv"

input i_valid;
input [STATES_WIDTH-1:0] i_addr;
output reg [DATA_WIDTH-1:0] o_rt;

reg [DATA_WIDTH-1:0] rom [2**STATES_WIDTH-1:0];

initial begin
	$readmemb(REWARD_FILE, rom);
end

always @(i_addr) begin
	if (i_valid) begin
		o_rt = rom[i_addr];
	end
end
endmodule
