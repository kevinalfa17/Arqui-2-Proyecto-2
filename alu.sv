//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    alu  
//
// Description:    This module is in charge of do the logic and arithmetic operations 
// 					between the inputs and create the flags of the result (Zero, Carry, Overflow, Negative).
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module alu(
				  input logic [31:0] SrcAE,  SrcBE,
				  input logic [1:0] ALUControlE,
				  output logic [3:0] ALUFlags, //Negative (LSB), Zero, Carry, oVerflow (MSB)
				  output logic [31:0] ALUResult
	);
	
	
	logic [32:0] temResult;
	logic x,y;
	
	always_comb
	begin
	 case(ALUControlE)
      2'b00: temResult = SrcAE + SrcBE;
		2'b01: temResult = SrcAE - SrcBE;
		2'b10: temResult = SrcAE & SrcBE;
		2'b11: temResult = SrcAE | SrcBE;
		default: temResult = 33'bx; //undefined
    endcase
	
	ALUResult = temResult[31:0];
	
	ALUFlags[0] = temResult[31];
	ALUFlags[2] = temResult[32];
	
	x = SrcAE[31] & SrcBE[31];
	y = SrcBE[31] & temResult[31];
	
	if(x)
	begin
		ALUFlags[3] = 0;
	end
	else
	begin
		if(!y)
			ALUFlags[3] = 0;
		else
			ALUFlags[3] = 1;
	end
	
	if(temResult == 0)
	begin
		ALUFlags[1] = 1;
	end
	else
	begin
		ALUFlags[1] = 0;
	end
	end
				
endmodule

module alu_testbench;

logic [31:0] SrcAEWire,  SrcBEWire;
logic [1:0] ALUControlEWire;
logic [3:0] ALUFlagsWire;
logic [31:0] ALUResultWire;


	alu Aluex(
				  .SrcAE(SrcAEWire),  
				  .SrcBE(SrcBEWire),
				  .ALUControlE(ALUControlEWire),
				  .ALUFlags(ALUFlagsWire), //Negative (LSB), Zero, Carry, oVerflow (MSB)
				  .ALUResult(ALUResultWire)
	);

initial begin
	ALUControlEWire <= 0; SrcAEWire <= -32; SrcBEWire <= 15; #10; 
	ALUControlEWire <= 1; SrcAEWire <= 1; SrcBEWire <= 1; #10; 
	ALUControlEWire <= 0; SrcAEWire <= 32'b11111111111111111111111111111111; SrcBEWire <= 1; #10; 
	ALUControlEWire <= 0; SrcAEWire <= 32'b11111111111111111111111111111111; SrcBEWire <= 32'b11111111111111111111111111111111; #10; 
	ALUControlEWire <= 2'bx; SrcAEWire <= 32'bx; SrcBEWire <= 32'bx; #10; 
end

endmodule