module read_input (state, next_state, action, reward, valid_in, valid_out, stop, clk);
`include "params.sv"

input valid_in, stop, clk;
output reg [STATES_WIDTH-1:0] state;
output reg [STATES_WIDTH-1:0] next_state;
output reg [ACTIONS_WIDTH-1:0] action;
output reg [DATA_WIDTH-1:0] reward;
output reg valid_out;

integer fd;
initial begin
	fd = $fopen(INPUT_FILE, "r");
	if (!fd) begin
		$display("File is not found!");	
		$finish;     // Break if file cant be created
   end
end

always @(posedge clk) begin 
	if (stop) begin
		$fclose(fd);
	end
	else begin
		if (valid_in) begin
			$fgets(state, fd);
			$fgets(next_state, fd);
			$fgets(action, fd);
			$fgets(reward, fd);
			valid_out <= 1;
		end
	end
end

endmodule
