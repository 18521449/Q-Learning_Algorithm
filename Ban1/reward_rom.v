module reward_rom (addr, rt);
`include "params.sv"
parameter WIDTH = ACTIONS_WIDTH*STATES_WIDTH;

input [WIDTH-1:0] addr;
output reg [DATA_WIDTH-1:0] rt;

reg [DATA_WIDTH-1:0] rom [2**WIDTH-1:0];

initial begin
	$readmemb(REWARD_FILE, rom);
end

always @(addr) begin
	rt = rom[addr];
end

endmodule
