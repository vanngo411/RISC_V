module AndGate(
	input zero, 
	input branch,
	output reg pc_sel);

	always @(branch, zero) 
	begin
		if (zero && branch)
        pc_sel <= 1;
		else
        pc_sel <= 0;
	end

endmodule 