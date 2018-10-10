//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    01:56:00 12/03/2018 
//
// Module Name:    flopr
//
// Description:    This module is in charge of keep the information of the input in the past clock cycle, also
// 					depends of the enable flag to reset all. It's created with params for change o the size of 
//					the inputs and outputs. We use like a basic reference the code of the book specified in the next point.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module flopenr #(parameter WIDTH = 8)(
					  input logic clk, reset, en,
					  input logic [WIDTH-1:0] d,
					  output logic [WIDTH-1:0] q
		);
		
		always_ff @(posedge clk, posedge reset)
			if (reset) q <= 0;
			else if (en) q <= d;
endmodule

module flopenr_testbench;

		  logic clkW; 
		  logic resetW; 
		  logic enW;
		  logic [7:0] dW;
		  logic [7:0] qW;

	flopenr#(8) flipen_test(
				.clk(clkW), 
				.reset(resetW), 
				.en(enW),
				.d(dW),
				.q(qW)
		);


initial begin
	resetW <= 1;
	#2;
	resetW <= 0;
	#8;
	enW <= 1;
	dW <= 4;
	#10;
	enW <= 1;
	dW <= 8;
	#10;
	enW <= 0;
	dW <= 12;
	#10;
	enW <= 1;
	dW <= 16;
	#10;
	enW <= 0;
	#10;
	resetW <= 1;
	#2;
	resetW <= 0;
	#8;
	
	

end

always begin
	clkW <= 1; #5; clkW <= 0; #5;
end

endmodule