// async control to generate alu input signal
// input: 2-bit alu_mem_write control signal and 6-bit funct field from instruction
// output: 4-bit alu control input
//module alucontrol (aluop, funct, out_to_alu);
//	input [1:0] aluop;
//	input [5:0] funct;
//	output [3:0] out_to_alu;
//
//	assign out_to_alu[3]=0;
//	assign out_to_alu[2]=((~aluop[1])&(aluop[0])) | ((aluop[1])&(~aluop[0])&(~funct[3])&(~funct[2])&(funct[1])&(~funct[0])) | ((aluop[1])&(~aluop[0])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0]));
//	assign out_to_alu[1]=((~aluop[1])&(~aluop[0]))|((~aluop[1])&(aluop[0])) | ((aluop[1])&(~aluop[0])&(~funct[3])&(~funct[2])&(~funct[1])&(~funct[0])) | ((aluop[1])&(~aluop[0])&(~funct[3])&(~funct[2])&(funct[1])&(~funct[0]))|((aluop[1])&(~aluop[0])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0]));
//	assign out_to_alu[0]=((aluop[1])&(~aluop[0])&(~funct[3])&(funct[2])&(~funct[1])&(funct[0]))|((aluop[1])&(~aluop[0])&(funct[3])&(~funct[2])&(funct[1])&(~funct[0]));	
//endmodule


module ALUControl (ALUOp_in, func7, func3, ALUControl_out);
	input [1:0] ALUOp_in;
	input [31:25] func7;
	input [14:12] func3;
	
	output reg [3:0] ALUControl_out;
	
	always @ (*) 
	begin
		case ({ALUOp_in, func7, func3})
			12'b00_xxxxxxx_xxx : ALUControl_out = 4'b0010; //12'b00_xxxxxxx_xxx
			12'b01_0000000_000 : ALUControl_out = 4'b0110; //12'b01_xxxxxxx_xxx
			12'b10_0000000_000 : ALUControl_out = 4'b0010; 
			12'b10_0100000_000 : ALUControl_out = 4'b0110; // not the same with book
			12'b10_0000000_111 : ALUControl_out = 4'b0000;
			12'b10_0000000_110 : ALUControl_out = 4'b0001;
			default 				: ALUControl_out = 4'bxxxx; 
		endcase
	end

endmodule 