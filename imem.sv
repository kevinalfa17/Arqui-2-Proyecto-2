//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    02:15:00 12/03/2018 
//
// Module Name:    imem
//
// Description:    This module is in charge of go to the file with the instructions and take the 
//					correct instruction by the necessary address of the input.  
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module imem(
		input logic [31:0] a,
		output logic [31:0] rd
	);
	logic [31:0] RAM[200:0];
	
	initial
		$readmemb("C:/Users/Daedgomez/Documents/Proyecto_Arqui/codigo3.txt",RAM);
	
	assign rd = RAM[a[31:2]]; // word aligned

endmodule

module imem_testbench;

		logic [31:0] aW;
		logic [31:0] rdW;

	imem imem_test(
		.a(aW),
		.rd(rdW)
	);


initial begin
	aW = 0;
	#5;
	aW = 4;
	#5;
	aW = 8;
	#5;
end

endmodule