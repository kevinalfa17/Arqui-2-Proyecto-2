//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    02:10:00 12/03/2018 
//
// Module Name:    mux3
//
// Description:    This module is in charge of addressing the correct data of the three inputs. And use
//					a parameter to change the size of the data manipulated. 
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module mux3 #(parameter WIDTH = 8)(
				  input logic [WIDTH-1:0] d0, d1, d2,
				  input logic [1:0]s,
				  output logic [WIDTH-1:0] y
	);
	
	always_comb
	 case(s)
      2'b00: y = d0;
      2'b01: y = d1;
      2'b10: y = d2;
      2'b11: y = 2'bxx; //undefined
		default: y = 2'bxx; //undefined
    endcase
endmodule

module mux3_testbench;

		  logic [7:0] d0W;
		  logic [7:0] d1W;
		  logic [7:0] d2W;
		  logic [1:0] sW;
		  logic [7:0] yW;

	mux3#(8) mux3_test(
				  .d0(d0W), 
				  .d1(d1W), 
				  .d2(d2W),
				  .s(sW),
				  .y(yW)
	);


initial begin
	d0W <= 6;
	d1W <= 8;
	d2W <= 2;
	sW <= 2'b00;
	#5;
	sW <= 2'b01;
	#5;
	sW <= 2'b10;
	#5;
	sW <= 2'b11;
	#5;

end

endmodule