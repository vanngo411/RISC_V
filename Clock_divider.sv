module Clock_divider(clock_in,clock_out);
	input clock_in; // input clock on FPGA
	output reg clock_out; // output clock after dividing the input clock by divisor
	reg[5:0] counter=6'd0;
	parameter DIVISOR = 6'd10; // 30'd400000000 for hardware testing
	
	always @(posedge clock_in)
	begin
		counter <= counter + 6'd1;
		if(counter>=(DIVISOR-1))
			counter <= 6'd0;
			clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
		end
endmodule 