module Mux3(Sel , A3, B3, Mux3_out);
	input Sel;
	input [31:0] A3, B3;
	output [31:0] Mux3_out;
	
	assign Mux3_out = (Sel == 1'b1) ? B3: A3;
endmodule 