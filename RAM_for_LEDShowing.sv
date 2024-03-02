module RAM_for_LEDShowing(clk, reset, write_signal, read_address,  write_address, write_data, Read_Data);
	input clk, reset, write_signal;
	input [31:0]  write_data;
	input [2:0] write_address, read_address;
	
	
	output [7:0] Read_Data;
	
	reg [31:0] memory [63:0];
	integer k;
	
	assign Read_Data = memory[read_address];
	
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1'b1) 
		begin
			for (k=0; k<64; k=k+1)
			begin
				memory[k] = 32'h0;
			end
		end
		else if (write_signal)
		begin
			memory[write_address] = write_data;
		end
	end
endmodule  
	