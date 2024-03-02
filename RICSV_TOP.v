module RICSV_TOP(
	input clk, rst_n,
    output[7:0] led,
    input usb_rx,
    output usb_tx
	);

	wire [31:0] instruction_outTop, read_data1Top, read_data2Top, ALUresultTop, toALU, Data_outTop, writeBackTop, im_genTop, jmp_addrTop;
	wire [3:0] ALUControl_outTop; ///??????????????
	wire RegWriteTop, MemWriteTop, MemReadTop, ALUSrcTop, MemtoRegTop, ZeroTop, AndGate_outTop, branch_outTop;
	wire [1:0] ALUOpTop;
	wire [31:0] PCtop, NextToPCtop, Mux3_outTop;
	
	
//	wire [7:0] led_outTop;
	wire [7:0] data_to_LED_Top;
	wire [2:0] read_address_LED;
	reg [2:0] read_address_for_LED;
	wire [2:0] counter_outTop, counter_out_slowerTop;
	integer count;
	wire clkx4;
	
	
	// PC +4
	PCplus4 PCplus4 
	(
	.fromPC(PCtop), 
	.nextToPC(NextToPCtop)
	);
	
	//PC
	program_counter program_counter 
	(.clk(clk), 
	.reset(reset), 
	.pc_in(Mux3_outTop), 
	.pc_out(PCtop)
	);
	
	//Memory of instruction
	instruction_memory instruction_memory 
	(
	.read_addr(PCtop), 
	.instruction(instruction_outTop),
	.clk(clk),
	.reset(reset));
	
	// Register File
	register_file register_file 
	(
	.clk(clk), 
	.reset(reset), 
	.Rs1(instruction_outTop[19:15]), 
	.Rs2(instruction_outTop[24:20]), 
	.Rd(instruction_outTop[11:7]), 
	.Write_data(writeBackTop), // skipped MUX
	.RegWrite(RegWriteTop), 
	.Read_data1(read_data1Top), 
	.Read_data2(read_data2Top) // review again
	);
	
	//ALU
	alu alu
	(
	.A(read_data1Top), 
	.B(toALU), 
	.zero(ZeroTop), 
	.ALUControl_in(ALUControl_outTop), 
	.ALU_result(ALUresultTop)
	);
	
	//Mux1
	Mux1 Mux1
	(
	.Sel(ALUSrcTop) , 
	.A1(read_data2Top), 
	.B1(im_genTop), 
	.Mux1_out(toALU)
	);
	
	// ALU control
	ALUControl ALUControl 
	(
	.ALUOp_in(ALUOpTop), 
	.func7(instruction_outTop[31:25]), 
	.func3(instruction_outTop[14:12]), 
	.ALUControl_out(ALUControl_outTop) //ALUControl_outTop is needed verify 32 or 4 bits
	);
	
	
	data_memory data_memory
	(
	.clk(clk), 
	.reset(reset), 
	.MemWrite(MemWriteTop), 
	.MemRead(MemReadTop), 
	.Address(ALUresultTop), 
	.write_data(), 
	.Read_Data(Data_outTop)
	);
	
	Mux2 Mux2
	(
	.Sel(MemtoRegTop), 
	.A2(ALUresultTop), 
	.B2(Data_outTop), 
	.Mux2_out(writeBackTop)
	);
	

	control control 
	(
	.reset(reset),
	.OPcode(instruction_outTop[6:0]), 
	.branch(branch_outTop), 
	.MemRead(MemReadTop), 
	.MemtoReg(MemtoRegTop), 
	.MemWrite(MemWriteTop), 
	.ALUSrc(ALUSrcTop), 
	.RegWrite(RegWriteTop), 
	.ALUOp_out(ALUOpTop)
	);
	
	// Immediate Generator 32 - 32
	immediate_Generator immediate_Generator
	(
	.reset(reset),
	.instruction(instruction_outTop),
	.im_gen(im_genTop)
	);
	
	// Jump adder
	jmp_adder jmp_adder
	(
    .reset(reset),
    .read_addr(PCtop),
    .im_gen(im_genTop),
    .jmp_addr(jmp_addrTop)
	);
	
	Mux3 Mux3
	(
	.Sel(AndGate_outTop), 
	.A3(NextToPCtop), 
	.B3(jmp_addrTop), 
	.Mux3_out(Mux3_outTop)
	);
	
	AndGate AndGate
	(
	.zero(ZeroTop), 
	.branch(branch_outTop),
	.pc_sel(AndGate_outTop)
	);	
	
	// LED showing RAM
	RAM_for_LEDShowing RAM_for_LEDShowing
	(
	.clk(clk), 
	.reset(reset), 
	.write_signal(RegWriteTop), 
	.read_address(counter_out_slowerTop), 
	.write_address(counter_outTop), 
	.write_data(writeBackTop), 
	.Read_Data(data_to_LED_Top)
	);
	
	Clock_divider Clock_divider
	(
	.clock_in(clk),
	.clock_out(clkx4)
    );
	
	up_counter up_counter
	(
	.clk(clk), 
	.reset(reset), 
	.counter(counter_outTop)
    );
	 
	 up_counter up_counter_slower
	(
	.clk(clkx4), 
	.reset(reset), 
	.counter(counter_out_slowerTop)
    );
    
    assign led = data_to_LED_Top;
 
    assign usb_tx = usb_rx;

endmodule 

module PCplus4 (fromPC, nextToPC);
	input [31:0] fromPC;
	output [31:0] nextToPC;
	
	assign nextToPC = fromPC +32'h00000004;
endmodule 

module program_counter (clk, reset, pc_in, pc_out);
	input clk, reset;
	input [31:0] pc_in;
	output [31:0] pc_out;
	
	reg [31:0] pc_out;
	always @ (posedge clk or posedge reset)
	
	begin
		if(reset==1'b1)
			pc_out<=32'h00000000;
		else
			pc_out<=pc_in;
	end
endmodule

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

//RISC_V
module alu(A, B, zero, ALUControl_in, ALU_result);
	input [31:0] A,B;
	input [3:0] ALUControl_in;
	output reg [31:0] ALU_result;
	output reg zero;
	
	always @ (ALUControl_in or A or B)
	begin
		case (ALUControl_in)
			4'b0000: begin zero<=0; ALU_result <= A & B; end
			4'b0001: begin zero<=0; ALU_result <= A | B; end
			4'b0010: begin zero<=0; ALU_result <= A + B; end
			4'b0110: begin if (A==B) zero<= 1; else zero<=0; ALU_result <= A - B; end
			default: begin zero<=0; ALU_result <= A; end
		endcase
		
	end

endmodule 

module Mux1(Sel , A1, B1, Mux1_out);
	input Sel;
	input [31:0] A1, B1;
	output [31:0] Mux1_out;
	
	assign Mux1_out = (Sel == 1'b0) ? A1: B1;
endmodule 

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

module data_memory(clk, reset, MemWrite, MemRead, Address, write_data, Read_Data);
	input clk, reset, MemWrite, MemRead;
	input [31:0] Address, write_data;
	
	
	output [31:0] Read_Data;
	
	reg [31:0] Dmemory [63:0];
	integer k;
	
	assign Read_Data = (MemRead) ? Dmemory[Address] : 32'h0;
	always @ (posedge clk or posedge reset)
	begin
		if (reset == 1'b1) 
		begin
			for (k=0; k<64; k=k+1)
			begin
				Dmemory[k] = 32'h0;
			end
		end
		else if (MemWrite)
		begin
			Dmemory[Address] = write_data;
		end
	end
endmodule

module Mux2(Sel , A2, B2, Mux2_out);
	input Sel;
	input [31:0] A2, B2;
	output [31:0] Mux2_out;
	
	assign Mux2_out = (Sel == 1'b0) ? A2: B2;
endmodule 

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

`define RTYPE 51
`define ITYPE 3
`define STYPE 35
`define SBTYPE 99

module immediate_Generator(
  input wire reset,
  input wire [31:0] instruction,
  output reg [31:0] im_gen
);
  reg [19:0] pad;

  always @(reset, instruction) begin
    if(reset == 1) begin
      im_gen<=0;
    end
    if (reset == 0) begin
      if (instruction[6:0] == `ITYPE) begin
        im_gen[12-1:0] <= instruction[31:20];
		end else if (instruction[6:0] == 19) begin
        im_gen[12-1:0] <= instruction[31:20];
      end else if (instruction[6:0] == `STYPE) begin
        im_gen[11:5] <= instruction[31:25];
        im_gen[4:0] <= instruction[11:7];
      end else if (instruction[6:0] == `SBTYPE) begin // shift left 1 bit here
        im_gen[13] <= instruction[31];
        im_gen[11:6] <= instruction[30:25];
        im_gen[12] <= instruction[7];
        im_gen[6-1:2] <= instruction[11:8];
        im_gen[1] <= 0;
		  im_gen[0] <= 0;
		  
//		  im_gen[12] <= instruction[31]; 	//without shift left 1 bit
//        im_gen[10:5] <= instruction[30:25];
//        im_gen[11] <= instruction[7];
//        im_gen[5-1:1] <= instruction[11:8];
//        im_gen[0] <= 0;
      end
      if (instruction[31] == 0) begin
        pad <= 0;
        im_gen[31:12] <= pad;
      end else begin
        pad = 20'hfffff;
        im_gen[31:12] <= pad;
      end
    end
  end
endmodule 

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

module Mux3(Sel , A3, B3, Mux3_out);
	input Sel;
	input [31:0] A3, B3;
	output [31:0] Mux3_out;
	
	assign Mux3_out = (Sel == 1'b1) ? B3: A3;
endmodule 

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
	
module up_counter(input clk, reset, output[2:0] counter
    );
	reg [2:0] counter_up;

// up counter
	always @(posedge clk or posedge reset)
	begin
		if(reset)
			counter_up <= 3'd0;
		else
			counter_up <= counter_up + 3'd1;
	end 
	assign counter = counter_up;
endmodule 	

module Clock_divider(clock_in,clock_out);
	input clock_in; // input clock on FPGA
	output reg clock_out; // output clock after dividing the input clock by divisor
	reg[29:0] counter=30'd0;
	parameter DIVISOR = 30'd400000000;
	
	always @(posedge clock_in)
	begin
		counter <= counter + 6'd1;
		if(counter>=(DIVISOR-1))
			counter <= 6'd0;
			clock_out <= (counter<DIVISOR/2)?1'b1:1'b0;
		end
endmodule 





