
// rising edge sync-write, async-read D-MEM
// height: 64, width: 32 bits (from document "Project Two Specification (V3)")
// address input: 6 bits (64 == 2^6)
// data input/output: 32 bits
// write: on rising edge, when (mem_write == 1)
// read: asynchronous, when (mem_read == 1)
//module data_memory (addr, write_data, read_data, clk, reset, mem_read, mem_write);
//	input [7:0] addr;
//	input [31:0] write_data;
//	output [31:0] read_data;
//	input clk, reset, mem_read, mem_write;
//	reg [31:0] dmemory [63:0];
//	integer k;
//	wire [5:0] shifted_addr;
//	assign shifted_addr=addr[7:2];
//	assign read_data = (mem_read) ? dmemory[addr] : 32'bx;
//
//	always @(posedge clk or posedge reset)// Ou modifies reset to posedge
//	begin
//		if (reset == 1'b1) 
//			begin
//				for (k=0; k<64; k=k+1) begin
//					dmemory[k] = 32'b0;
//				end
//			end
//		else
//			if (mem_write) dmemory[addr] = write_data;
//	end
//endmodule


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
