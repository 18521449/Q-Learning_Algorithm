module controller
	(	clk,
		rst_n,
		i_start,
		i_valid,
		o_count,
		o_step,
		o_write_file_en,
		o_valid
	);
`include "params.sv"

//----------------Input and output port-----------//
input 										clk;
input 										rst_n;
input 										i_valid;
input 										i_start;
output reg 	[COUNTER_WIDTH-1:0]		o_count;
output reg 	[COUNTER_WIDTH-1:0]		o_step;
output reg							 		o_write_file_en;
output reg									o_valid;
//------------------------------------------------//

always @(posedge clk) begin
	if (i_start) begin
		o_count <= 'd0;
		o_step <= 'd0;
		o_write_file_en <= 0;
		o_valid <= 1;
	end
	else begin
		if (o_count < NUMBER_OF_LOOP) begin
			if (i_valid) begin
				if (o_step < NUMBER_OF_STEP-1)
					o_step <= o_step + 1;
				else begin
					o_step <= 'd0;
					o_count <= o_count + 1;
				end
				o_valid <= 1;
			end
			else o_valid <= 0;
		end 
		else if (o_count == NUMBER_OF_LOOP) begin
			o_write_file_en <= 1;
		end
	end
end

endmodule

