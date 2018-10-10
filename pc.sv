//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    pc  
//
// Description:    PC register used as a flip flop to handle program counter.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////


module pc #(parameter WIDTH = 8)(
					input logic clk, reset,
					input logic [WIDTH-1:0] d,
					input logic StallF,
					output logic [WIDTH-1:0] q,
					output logic led1,
					output logic led2,
					output logic led3
		);

		always_ff @(posedge clk)begin
					if (reset) begin 
						q <= -4;
						led1 <= 0;
						led2 <= 1;
						led3 <= 0;
					end
					else begin
						if(!StallF)
							q <= d;
							if(d == 4)
								led1 <= 1;
							if(d == 1)
								led3 <= 1;
					end
		end
			
endmodule