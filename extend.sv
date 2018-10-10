//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    01:46:00 12/03/2018 
//
// Module Name:    extend
//
// Description:    This module is in charge of the manipulation to the immediates, to extend sign 
//					or extend to 32 bits the value of the input.  
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module extend(
			input logic [23:0] Instr,
			input logic [1:0] ImmSrc,
			output logic [31:0] ExtImm
	);
				
	always_comb
		case(ImmSrc)
			// 8-bit unsigned immediate
			2'b00: ExtImm = {20'b0, Instr[11:0]};
			// 12-bit unsigned immediate
			2'b01: ExtImm = {20'b0, Instr[11:0]};
			// 24-bit two's complement shifted branch
			2'b10: ExtImm = {{6{Instr[23]}}, Instr[23:0], 2'b00};
			// 7-bit signed immediate
			2'b11: ExtImm = {{25{Instr[7]}}, Instr[6:0]};
			default: ExtImm = 32'bx; // undefined
		endcase
endmodule

module extend_testbench;

	logic [23:0] InstrW;
	logic [1:0] ImmSrcW;
	logic [31:0] ExtImmW;


	extend extend_test(
			.Instr(InstrW),
			.ImmSrc(ImmSrcW),
			.ExtImm(ExtImmW)
	);


initial begin
	ImmSrcW <= 2'b00;
	InstrW <= 24'b000000000000000000001011;
	#10;
	InstrW <= 24'b111111111111100000000001;
	#10;

	ImmSrcW <= 2'b01;
	InstrW <= 24'b000000000000000000001011;
	#10;
	InstrW <= 24'b111111111111100000000001;
	#10;

	ImmSrcW <= 2'b10;
	InstrW <= 24'b000000000000000000001110;
	#10;
	InstrW <= 24'b111111111111100000000001;
	#10;
	
	ImmSrcW <= 2'b11;
	InstrW <= 24'b000000000000000000001001;
	#10;
	InstrW <= 24'b111111111100110111111111;

end

endmodule