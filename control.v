// async control signal generation unit based on mem_writecode
// input: 6 bits mem_writecode
// output: all 1 bit except alu_mem_write which is 2-bits wide
//module control (opcode, reg_dest, jump, branch, mem_read, mem_to_reg, aluop, mem_write, alusrc, reg_write);
//	input [5:0] opcode;
//	output reg_dest, jump, branch, mem_read, mem_to_reg, mem_write, alusrc, reg_write;
//	output [1:0] aluop;
//
//	assign reg_dest=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]);//000000
//	assign jump=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(~opcode[0]);//000010
//	assign branch=(~opcode[5])&(~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]);//000100
//	assign mem_read=(opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//100011
//	assign mem_to_reg=(opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//100011
//	assign mem_write=(opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]);//101011
//	assign alusrc=((~opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0])) | ((opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0])) | (((opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]))); //001000,001100,100011,101011
//	assign reg_write=(~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0])) | ((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0])) | ((opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(opcode[1])&(opcode[0]));//000000,001000,001100,100011
//	assign aluop[1]=((~opcode[5])&(~opcode[4])&(~opcode[3])&(~opcode[2])&(~opcode[1])&(~opcode[0]))|((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]));//000000, 001100(andi)
//	assign aluop[0]= ((~opcode[5])&(~opcode[4])&(~opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]))|((~opcode[5])&(~opcode[4])&(opcode[3])&(opcode[2])&(~opcode[1])&(~opcode[0]));//000100,001100(andi)
//endmodule


module control (reset, OPcode, branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp_out);
	input reset;
	input [6:0] OPcode;
	output reg branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite;
	output reg [1:0] ALUOp_out;
	
	always @(*) 
	begin
		if (reset)
		begin
			{branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, ALUOp_out} <= 7'b0000000;
		end
		else
		case (OPcode)
			7'b0110011: // For  R_Type instruction
			begin
				branch <= 0;
				MemRead <=0;
				MemtoReg <=0;
				MemWrite <=0;
				ALUSrc <=0;
				RegWrite <= 1;
				ALUOp_out <= 2'b10;
			end
			7'b0000011: // Load instruction
			begin
				ALUSrc <=1;
				MemtoReg <=0;    //FIxed 1->0 for lw
				RegWrite <= 1;
				MemRead <=1;
				MemWrite <=0;
				branch <= 0;											
				ALUOp_out <= 2'b00;
			end
			7'b0010011: // Use for Immediate Addi, 
			begin
				ALUSrc <=1;
				MemtoReg <=0;
				RegWrite <= 1;
				MemRead <=0;
				MemWrite <=0;
				branch <= 0;											
				ALUOp_out <= 2'b10;
			end
			7'b0100011: // Store instruction
			begin
				ALUSrc <=1;
				MemtoReg <=0;
				RegWrite <= 0;
				MemRead <=0;
				MemWrite <=1;
				branch <= 0;											
				ALUOp_out <= 2'b00;
			end
			7'b1100011: // Branch-equal instruction
			begin
				ALUSrc <=0;
				MemtoReg <=0;
				RegWrite <= 0;
				MemRead <=0;
				MemWrite <=0;
				branch <= 1;											
				ALUOp_out <= 2'b01;
			end
			default: // same R-type
			begin
				ALUSrc <=0;
				MemtoReg <=0;
				RegWrite <= 0;
				MemRead <=0;
				MemWrite <=0;
				branch <= 0;											
				ALUOp_out <= 2'b10;
			end
		endcase
	end
	
endmodule  