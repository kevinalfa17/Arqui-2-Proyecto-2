//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    02:10:00 12/03/2018 
//
// Module Name:    mux2
//
// Description:    This module is in charge of addressing the correct data of the two inputs. And use
//					a parameter to change the size of the data manipulated
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module mux2 #(parameter WIDTH = 8)(
				  input logic [WIDTH-1:0] d0, d1,
				  input logic s,
				  output logic [WIDTH-1:0] y
	);
	assign y = s ? d1 : d0;
endmodule