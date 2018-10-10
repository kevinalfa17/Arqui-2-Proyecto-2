//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    DecoExePipe  
//
// Description:    This module is a pipe register used to keep pipeline control signals and 
	           data, this pipe have a stall and flush signals for hazards control.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////



module DecoExePipe(
	input logic clk, reset,
	input logic PCSrcD, RegWriteD, MemtoRegD, MemWriteD, ALUSrcD, NoWriteD, BranchD, linkD,
	input logic [1:0] ALUControlD, FlagWriteD,
	input logic [31:0] RD1D, RD2D, ExtImmD, PCPlus4D,
	input logic [3:0] WA3D, FlagsD, CondD,
	input logic [3:0] RA1D, RA2D,
	input logic FlushE,
	output logic [3:0] RA1E, RA2E,
	output logic PCSrcE, RegWriteE, MemtoRegE, MemWriteE, ALUSrcE, NoWriteE, BranchE, linkE,
	output logic [1:0] ALUControlE, FlagWriteE,
	output logic [31:0] RD1E, RD2E, ExtImmE, PCPlus4E,
	output logic [3:0] WA3E, FlagsE, CondE,
	//vector related
	input logic IndexRegD,
	input logic isDotD,
	input logic	MemWriteVD,
	input logic RegWriteVD,
	input logic RegWriteVVD,
	output logic IndexRegE,
	output logic isDotE,
	output logic MemWriteVE,
	output logic RegWriteVE,
	output logic RegWriteVVE,
	
	
	input logic signed [8:0] RD1VD[8:0], RD2VD[8:0],
	input logic [3:0] RA1VD, RA2VD,
	input logic [3:0] IndexD,
	output logic signed [8:0] RD1VE[8:0], RD2VE[8:0],
	output logic [3:0] RA1VE, RA2VE,
	output logic [3:0] IndexE0,
	
	input logic [4:0] shift_amountD,
	input logic [1:0] type_opD,
	output logic [4:0] shift_amountE,
	output logic [1:0] type_opE	
	);
	
	always_ff @(posedge clk) begin
		if(reset) begin
			PCSrcE <= 0;
					RegWriteE <= 0;
					MemtoRegE <= 0;
					MemWriteE <= 0;
					ALUControlE <= 0;
					FlagWriteE <= 0;
					ALUSrcE <= 0;
					CondE <= 0;
					linkE <= 0;
					FlagsE <= 0;
					RD1E <= 0;
					RD2E <= 0;
					RA1E <= 0;
					RA2E <= 0;
					ExtImmE <= 0;
					WA3E <= 0;
					NoWriteE <= 0; 
					BranchE <= 0;
					PCPlus4E <= 0;
					
					IndexRegE <= 0;
					isDotE <= 0;
					MemWriteVE <= 0;
					RegWriteVE <= 0;
					RegWriteVVE <= 0;
					
					RD1VE[0] <= 0;
					RD1VE[1] <= 0;
					RD1VE[2] <= 0;
					RD1VE[3] <= 0;
					RD1VE[4] <= 0;
					RD1VE[5] <= 0;
					RD1VE[6] <= 0;
					RD1VE[7] <= 0;
					RD1VE[8] <= 0;
					
					
					RD2VE[0] <= 0;
					RD2VE[1] <= 0;
					RD2VE[2] <= 0;
					RD2VE[3] <= 0;
					RD2VE[4] <= 0;
					RD2VE[5] <= 0;
					RD2VE[6] <= 0;
					RD2VE[7] <= 0;
					RD2VE[8] <= 0;
					
					RA1VE <= 0;
					RA2VE <= 0;
					IndexE0 <= 0;
					
					shift_amountE <= 0;
					type_opE <= 0;
		end
		else begin
			if(!FlushE)
				begin
					PCSrcE <= PCSrcD;
					RegWriteE <= RegWriteD;
					MemtoRegE <= MemtoRegD;
					MemWriteE <= MemWriteD;
					ALUControlE <= ALUControlD;
					FlagWriteE <= FlagWriteD;
					ALUSrcE <= ALUSrcD;
					CondE <= CondD;
					linkE <= linkD;
					FlagsE <= FlagsD;
					RD1E <= RD1D;
					RD2E <= RD2D;
					RA1E <= RA1D;
					RA2E <= RA2D;
					ExtImmE <= ExtImmD;
					WA3E <= WA3D;
					NoWriteE <= NoWriteD; 
					BranchE <= BranchD;
					PCPlus4E <= PCPlus4D;
					
					IndexRegE <= IndexRegD;
					isDotE <= isDotD;
					MemWriteVE <= MemWriteVD;
					RegWriteVE <= RegWriteVD;
					RegWriteVVE <= RegWriteVVD;
					
					RD1VE <= RD1VD;
					RD2VE <= RD2VD;
					RA1VE <= RA1VD;
					RA2VE <= RA2VD;
					IndexE0 <= IndexD;
					
					shift_amountE <= shift_amountD;
					type_opE <= type_opD;
				end
			else
				begin
					PCSrcE <= 0;
					RegWriteE <= 0;
					MemtoRegE <= 0;
					MemWriteE <= 0;
					ALUControlE <= 0;
					FlagWriteE <= 0;
					ALUSrcE <= 0;
					CondE <= 0;
					linkE <= 0;
					FlagsE <= 0;
					RD1E <= 0;
					RD2E <= 0;
					RA1E <= 0;
					RA2E <= 0;
					ExtImmE <= 0;
					WA3E <= 0;
					NoWriteE <= 0; 
					BranchE <= 0;
					PCPlus4E <= 0;
					
					IndexRegE <= 0;
					isDotE <= 0;
					MemWriteVE <= 0;
					RegWriteVE <= 0;
					RegWriteVVE <= 0;
					
					RD1VE[0] <= 0;
					RD1VE[1] <= 0;
					RD1VE[2] <= 0;
					RD1VE[3] <= 0;
					RD1VE[4] <= 0;
					RD1VE[5] <= 0;
					RD1VE[6] <= 0;
					RD1VE[7] <= 0;
					RD1VE[8] <= 0;
					
					
					RD2VE[0] <= 0;
					RD2VE[1] <= 0;
					RD2VE[2] <= 0;
					RD2VE[3] <= 0;
					RD2VE[4] <= 0;
					RD2VE[5] <= 0;
					RD2VE[6] <= 0;
					RD2VE[7] <= 0;
					RD2VE[8] <= 0;
					
					RA1VE <= 0;
					RA2VE <= 0;
					IndexE0 <= 0;
					
					shift_amountE <= 0;
					type_opE <= 0;
				end
			end//end else
		end
	endmodule
			
			