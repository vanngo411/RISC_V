//module immediate_Generator (
//	input signed [31:0] instruction,
//	output reg signed [31:0] I, S, SB
//);
//
//	always @* 
//	begin
//		I = {{20{instruction[11]}},instruction[31:20]}; //immediate
//		S = {{20{instruction[11]}},instruction[30:25]}; //store
//		SB = {{12{instruction[31]}},instruction[7],instruction[30:25], instruction[11:8], 1'b0}; //branch
//	end
//endmodule 

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


