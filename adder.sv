//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430), Gabriel Barboza Alvarez (2015014425),
// 			  Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    adder
//
// Description:   A combitional Adder of two n-bit operands. 
//
// Reference:		Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//////////////////////////////////////////////////////////////////////////////////
module adder #(parameter WIDTH = 8)
	(input logic [WIDTH-1:0] a, b,
	output logic [WIDTH-1:0] y);
	
	assign y = a+b;
	
	endmodule