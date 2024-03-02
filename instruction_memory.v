//RISC_V 
module instruction_memory (read_addr, instruction, clk, reset);
	input clk, reset;
	input [31:0] read_addr;
	output [31:0] instruction;
	
	reg [31:0] Memory [63:0];
	integer k;
	
	assign instruction = Memory[read_addr];

	always @(posedge clk)
	begin
		if (reset == 1'b1)
		begin
			for (k=0; k<64; k=k+1) 
			begin// here Ou changes k=0 to k=16
				Memory[k] = 32'h00000000;
			end
		end
		else if (reset == 1'b0)
		begin
			Memory[0] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25
			Memory[4] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25	- ALU result =x10=125
			Memory[8] = 32'b00000000010100001000000100010011; 			//addi x2, x1, 5 -> x2=5
			Memory[12] = 32'b00000000011000010000000000100011;		//sb x6, 0(x2) -> x6 = 5
			Memory[16] = 32'b01000000010100100000001000110011; //sub x4, x4, x5 - ALU result=x4=-3		
			Memory[20] = 32'b0000000_00000_01010_011_01001_0000011; //lw x9, 0(x10)  -> x9 = 125
			Memory[24] = 32'b00000000100101001000001001100011; // beq x9, x9, 4
			Memory[32] = 32'b0000000_11001_01010_000_01010_0110011; // add x10, x10, x25
			
//			Memory[24] = 32'b0000000_11000_01001_001_01100_1100011; //bne x9, x24, exit 
//			Memory[28] = 32'b0000000_00001_10110_000_10110_0010011; // addi x22, x22, 1
//			Memory[32] = 32'b1111111_00000_00000_000_01101_1100011; // beq x0, x0, loop
//			
		end
		
		
	end
endmodule
