//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    02:43:00 12/03/2018 
//
// Module Name:    regfile
//
// Description:    This module is in charge of keep the values of data stored and directing the 
//					correct data decided by the inputs of directions.
// 					We use like a basic reference the code of the book specified in the next point
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////

module regfile(
			input logic clk, reset,
			input logic we3,
			input logic [3:0] ra1, ra2, wa3,
			input logic [31:0] wd3, r15, pc4,
			output logic [31:0] rd1, rd2,
			input logic link
	);
	
	logic [31:0] rf[14:0];	

	always_ff@(posedge clk) begin
		if(reset) begin
			rf[0] <= 32'b0;
			rf[1] <= 32'b0;
			rf[2] <= 32'b0;
			rf[3] <= 32'b0;
			rf[4] <= 32'b0;
			rf[5] <= 32'b0;
			rf[6] <= 32'b0;
			rf[7] <= 32'b0;
			rf[8] <= 32'b0;
			rf[9] <= 32'b0;
			rf[10] <= 32'b0;
			rf[11] <= 32'b0;
			rf[12] <= 32'b0;
			rf[13] <= 32'b0;
			rf[14] <= 32'b0;
		end
		else begin
		
			if (we3) rf[wa3] = wd3;
			if (link) rf[14] = pc4;
		end
	end
	
	assign rd1 = (ra1 == 4'b1111) ? r15 : rf[ra1];
	assign rd2 = (ra2 == 4'b1111) ? r15 : rf[ra2];
endmodule

module regFile_testbench;

			logic clkW;
			logic we3W;
			logic [3:0] ra1W;
			logic [3:0] ra2W;
			logic [3:0] wa3W;
			logic [31:0] wd3W;
			logic [31:0] r15W;
			logic [31:0] pc4W;
			logic [31:0] rd1W;
			logic [31:0] rd2W;
			logic linkW;


	regfile regfil_test(
			.clk(clkW),
			.we3(we3W),
			.ra1(ra1W), 
			.ra2(ra2W), 
			.wa3(wa3W),
			.wd3(wd3W), 
			.r15(r15W), 
			.pc4(pc4W),
			.rd1(rd1W), 
			.rd2(rd2W),
			.link(linkW)
	);

initial begin
	pc4W <= 4;
	r15W <= 12;
	we3W <= 1;
	wa3W <= 1;
	wd3W <= 31;
	#5;
	we3W <= 0;
	#5;
	we3W <= 1;
	wa3W <= 2;
	wd3W <= 20;
	#5;
	we3W <= 0;
	#5;
	ra1W <= 1;
	ra2W <= 2;
	#10;
	ra1W <= 2;
	ra2W <= 15;
	#10;
	linkW <= 1;
	#10;
	ra1W <= 14;

	

end

always begin
	clkW <= 1; #5; clkW <= 0; #5;
end

endmodule