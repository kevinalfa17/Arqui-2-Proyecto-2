//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    mux2v  
//
// Description:    Vectorial mux which changes between V0 and V1 depending on s signal.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////


module mux2V(
				input logic signed [8:0] d0[8:0], d1[8:0],
				input logic s,
				output logic signed [8:0] y[8:0]
	);
	assign y = s ? d1 : d0;
endmodule