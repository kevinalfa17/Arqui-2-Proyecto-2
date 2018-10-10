//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Dennis Porras Barrantes (2015084004)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    shift  
//
// Description:    This module is shift registers to left and right.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////
module shift(
	input logic [31:0] input_shift,
	input logic [4:0] shift_amount,
	input logic [1:0] type_op,
	output logic [31:0] output_shift);
	
always_comb
	if(type_op == 0) begin
		case(shift_amount) 
			5'b00000: output_shift = input_shift;
			5'b00001: output_shift = input_shift << 1;
			5'b00010: output_shift = input_shift << 2;
			5'b00011: output_shift = input_shift << 3;
			5'b00100: output_shift = input_shift << 4;
			5'b00101: output_shift = input_shift << 5;
			5'b00110: output_shift = input_shift << 6;
			5'b00111: output_shift = input_shift << 7;
			5'b01000: output_shift = input_shift << 8;
			5'b01001: output_shift = input_shift << 9;
			5'b01010: output_shift = input_shift << 10;
			5'b01011: output_shift = input_shift << 11;
			5'b01100: output_shift = input_shift << 12;
			5'b01101: output_shift = input_shift << 13;
			5'b01110: output_shift = input_shift << 14;
			5'b01111: output_shift = input_shift << 15;
			5'b10000: output_shift = input_shift << 16;
			5'b10001: output_shift = input_shift << 17;
			5'b10010: output_shift = input_shift << 18;
			5'b10011: output_shift = input_shift << 19;
			5'b10100: output_shift = input_shift << 20;
			5'b10101: output_shift = input_shift << 21;
			5'b10110: output_shift = input_shift << 22;
			5'b10111: output_shift = input_shift << 23;
			5'b11000: output_shift = input_shift << 24;
			5'b11001: output_shift = input_shift << 25;
			5'b11010: output_shift = input_shift << 26;
			5'b11011: output_shift = input_shift << 27;
			5'b11100: output_shift = input_shift << 28;
			5'b11101: output_shift = input_shift << 29;
			5'b11110: output_shift = input_shift << 30;
			5'b11111: output_shift = input_shift << 31;
		endcase
	end
	else begin
		case(shift_amount) 
			5'b00000: output_shift = input_shift;
			5'b00001: output_shift = input_shift >> 1;
			5'b00010: output_shift = input_shift >> 2;
			5'b00011: output_shift = input_shift >> 3;
			5'b00100: output_shift = input_shift >> 4;
			5'b00101: output_shift = input_shift >> 5;
			5'b00110: output_shift = input_shift >> 6;
			5'b00111: output_shift = input_shift >> 7;
			5'b01000: output_shift = input_shift >> 8;
			5'b01001: output_shift = input_shift >> 9;
			5'b01010: output_shift = input_shift >> 10;
			5'b01011: output_shift = input_shift >> 11;
			5'b01100: output_shift = input_shift >> 12;
			5'b01101: output_shift = input_shift >> 13;
			5'b01110: output_shift = input_shift >> 14;
			5'b01111: output_shift = input_shift >> 15;
			5'b10000: output_shift = input_shift >> 16;
			5'b10001: output_shift = input_shift >> 17;
			5'b10010: output_shift = input_shift >> 18;
			5'b10011: output_shift = input_shift >> 19;
			5'b10100: output_shift = input_shift >> 20;
			5'b10101: output_shift = input_shift >> 21;
			5'b10110: output_shift = input_shift >> 22;
			5'b10111: output_shift = input_shift >> 23;
			5'b11000: output_shift = input_shift >> 24;
			5'b11001: output_shift = input_shift >> 25;
			5'b11010: output_shift = input_shift >> 26;
			5'b11011: output_shift = input_shift >> 27;
			5'b11100: output_shift = input_shift >> 28;
			5'b11101: output_shift = input_shift >> 29;
			5'b11110: output_shift = input_shift >> 30;
			5'b11111: output_shift = input_shift >> 31;
		endcase
end

endmodule
