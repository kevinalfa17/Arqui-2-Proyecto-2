//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    02:56:00 12/03/2018 
//
// Module Name:    dmem
//
// Description:    This module is in charge of keep the values of data stored by the procesador 
//					and also of addressing the correct values of data solicited.
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module dmem(
		input logic clk, we,
		input logic [31:0] a, wd,
		output logic [31:0] rd
	);

	logic reset = 1;

	logic [31:0] RAM[63:0];
	assign rd = RAM[a[31:2]]; // word aligned

	always_ff @(posedge clk) begin
		if(reset) begin
			reset <= 0;
			for(int i = 0; i < 64; i++)
				RAM[i] <= 0;
		end
		if (we) RAM[a[31:2]] <= wd;
	end
endmodule

module dmem_testbench;

		logic clkW;
		logic weW;
		logic [31:0] aW;
		logic [31:0] wdW;
		logic [31:0] rdW;


	dmem memoria_dat(
		.clk(clkW), 
		.we(weW),
		.a(aW), 
		.wd(wdW),
		.rd(rdW)
	);


initial begin
	weW <=1; aW <= 4; wdW <= 123; #10; aW <= 8; wdW <= 80; #10 weW <=0; #5; wdW<=0; aW <=4; #10;
end

always begin
	clkW <= 1; #5; clkW <= 0; #5;
end

endmodule