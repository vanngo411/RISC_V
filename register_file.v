//RICS_V
module register_file (clk, reset, Rs1, Rs2, Rd, Write_data, RegWrite, Read_data1, Read_data2);
	input clk, reset, RegWrite; //single bit
	input [4:0] Rs1, Rs2, Rd; //5bits - Read register
	input [31:0] Write_data; // 32 bits
	
	output [31:0] Read_data1, Read_data2;
	
	reg [31:0] Registers [31:0]; //32 register each of 32 bit wide
	
	initial 
	begin
		Registers[0] = 32'd0;
		Registers[1] = 32'd0;
		Registers[2] = 6;
		Registers[3] = 34;
		Registers[4] = 5;
		Registers[5] = 8;
		Registers[6] = 2;
		Registers[7] = 67;
		Registers[8] = 56;
		Registers[9] = 45;
		Registers[10] = 50;
		Registers[11] = 41;
		Registers[12] = 24;
		Registers[13] = 23;
		Registers[14] = 24;
		Registers[15] = 35;
		Registers[16] = 46;
		Registers[17] = 57;
		Registers[18] = 68;
		Registers[19] = 29;
		Registers[20] = 30;
		Registers[21] = 41;
		Registers[22] = 52;
		Registers[23] = 53;
		Registers[24] = 44;
		Registers[25] = 75;
		Registers[26] = 56;
		Registers[27] = 57;
		Registers[28] = 48;
		Registers[29] = 39;
		Registers[30] = 80;
		Registers[31] = 91;
	end
	integer k;
	
	always @(posedge clk)
	begin
			if (reset == 1'b1)
			begin
				for (k=0; k<32; k=k+1)
				begin
					Registers[k]=32'h0;
				end
					
			end
			else if (RegWrite == 1'b1)
			begin
				Registers[Rd] = Write_data;
			end
	end
	
	assign Read_data1 = Registers[Rs1];
	assign Read_data2 = Registers[Rs2];
	
endmodule


//module register_file (clk, reset, Rs1, Rs2, Rd, Write_data, RegWrite, Read_data1, Read_data2);
//	input clk, reset, RegWrite; //single bit
//	input [19:15] Rs1; //5bits - Read register
//	input [24:20] Rs2; //5bits - Read register
//	input [11:7] Rd; // 5bits - Write register
//	input [31:0] Write_data; // 32 bits
//	
//	output [31:0] Read_data1, Read_data2;
//	
//	reg [31:0] Registers [31:0]; //32 register each of 32 bit wide
//	integer k;
//	
//	assign Read_data1 = Registers[Rs1];
//	assign Read_data2 = Registers[Rs2];
//	
//	always @(posedge clk or posedge reset)
//	begin
//			if (reset == 1'b1)
//			begin
//				for (k=0; k<32; k=k+1)
//				begin
//					Registers[k]=32'h0;
//				end
//					
//			end
//			else if (RegWrite == 1'b1)
//			begin
//				Registers[Rd] = Write_data;
//			end
//	end
//	
//endmodule 