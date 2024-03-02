module jmp_adder
	(
    input reset,
    input [31:0] read_addr,
    input [31:0] im_gen,
    output reg [31:0] jmp_addr
	);

	always @(read_addr, reset, im_gen) 
	begin
		if (reset == 1) 
		begin
			jmp_addr<=0;
		end   
		if (reset == 0) 
		begin
			jmp_addr <= (read_addr + im_gen);
		end
  end
endmodule 