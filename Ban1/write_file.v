module write_file (data, valid_in, stop, clk);
`include "params.sv"
input clk;
input valid_in;
input stop;
input [DATA_WIDTH-1:0] data;

integer fd;

initial begin
   fd = $fopen(OUTPUT_FILE, "w");   //Create file for writing value
	// Check progress is completed without errors
	if (!fd == 0) begin
		$display("File is not created!");	
		$finish;     // Break if file cant be created
   end
end

always @(posedge clk) begin
	if (stop)
		$fclose(fd);
	else begin
		if (valid_in) begin
			$fwrite(fd,"%b\n",data);
		end
	end
end
endmodule
