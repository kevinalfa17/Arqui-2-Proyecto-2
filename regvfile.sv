//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430)
// 
// Create Date:    07:00:00 13/04/2018 
//
// Module Name:    regvfile
//
// Description:   This module stores the vector data temporaly to be easy to access
//						in operations.
//
// Reference:	Own idea.
//////////////////////////////////////////////////////////////////////////////////
module regvfile(
			input logic clk,
			input logic wee, wev,
			input logic [3:0] ra1, ra2, wa,
			input logic [3:0] index,
			input logic signed [8:0] wdv[8:0],
			input logic [8:0] wde,
			output logic signed [8:0] rd1[8:0], rd2[8:0]
	);
	
	logic [8:0] rf[7:0][8:0];
	always_ff @(posedge clk)
		if (wev) begin
		rf[wa][0] <= wdv[0];
		rf[wa][1] <= wdv[1];
		rf[wa][2] <= wdv[2];
		rf[wa][3] <= wdv[3];
		rf[wa][4] <= wdv[4];
		rf[wa][5] <= wdv[5];
		rf[wa][6] <= wdv[6];
		rf[wa][7] <= wdv[7];
		rf[wa][8] <= wdv[8];
		end
		else if (wee) begin
		rf[wa][index] <= wde;
		end
		
		assign rd1[0] = rf[ra1][0];
		assign rd1[1] = rf[ra1][1];
		assign rd1[2] = rf[ra1][2];
		assign rd1[3] = rf[ra1][3];
		assign rd1[4] = rf[ra1][4];
		assign rd1[5] = rf[ra1][5];
		assign rd1[6] = rf[ra1][6];
		assign rd1[7] = rf[ra1][7];
		assign rd1[8] = rf[ra1][8];
		assign rd2[0] = rf[ra2][0];
		assign rd2[1] = rf[ra2][1];
		assign rd2[2] = rf[ra2][2];
		assign rd2[3] = rf[ra2][3];
		assign rd2[4] = rf[ra2][4];
		assign rd2[5] = rf[ra2][5];
		assign rd2[6] = rf[ra2][6];
		assign rd2[7] = rf[ra2][7];
		assign rd2[8] = rf[ra2][8];
endmodule

module regvfile_testbench;
logic clk;
logic wee, wev;
logic [4:0] index;
logic [3:0] ra1, ra2, wa;
logic [8:0] wdv[8:0];
logic [8:0] wde;
logic [8:0] rd1[8:0], rd2[8:0];
regvfile regv(clk, wee, wev, ra1, ra2, wa, index, wdv, wde, rd1, rd2);
initial begin
wa=0;
wdv[0]=1;
wdv[1]=2;
wdv[2]=3;
wdv[3]=4;
wdv[4]=5;
wdv[5]=6;
wdv[6]=7;
wdv[7]=8;
wdv[8]=9;
#20;
wev=1;
#50; //Let simulation finish
wev=0;
ra1=0;
wee=1;
wa=1;
wde=-5;
index=5;
#20;
ra2=1;
end
always begin
		clk <= 1; # 10; clk <= 0; # 10;
end
endmodule