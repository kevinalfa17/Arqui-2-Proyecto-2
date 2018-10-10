//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Dennis Porras Barrantes (2015084004)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    MemWbPipe
//
// Description:   Pipe of memory and writeback stage (signals and data), it has 
//						a reset to set all the signals in low.
//
// Reference:		Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//////////////////////////////////////////////////////////////////////////////////
module MemWbPipe (
	input logic clk,
	input logic PCSrcM, RegWriteM, MemtoRegM, linkM,
	input logic [31:0] RDM, ALUOutM, PCPlus4M,
	input logic [3:0] WA3M,
	output logic PCSrcW, RegWriteW, MemtoRegW, linkW,
	output logic [31:0] RDW, ALUOutW, PCPlus4W,
	output logic [3:0] WA3W,
	//vector related
	output logic RegWriteVW,
	output logic RegWriteVVW,
	input logic RegWriteVM,
	input logic RegWriteVVM,
	
	input logic signed [8:0] ReadDataVM[8:0],
	output logic signed [8:0] ReadDataVW[8:0],
	
	input logic [3:0] IndexM,
	output logic [3:0] IndexW,
	input logic reset
	);
	
	
	
	always_ff @(posedge clk) begin
			if(reset) begin
					PCSrcW <= 0;
					RegWriteW <= 0;
					MemtoRegW <= 0;
					RDW <= 0;
					ALUOutW <= 0;
					WA3W <= 0;
					linkW <= 0;
		
					
					RegWriteVW <= 0;
					RegWriteVVW <= 0;
					
			end
			else begin
				PCSrcW <= PCSrcM;
				RegWriteW <= RegWriteM;
				MemtoRegW <= MemtoRegM;
				RDW <= RDM;
				ALUOutW <= ALUOutM;
				WA3W <= WA3M;
				linkW <= linkM;
				PCPlus4W <= PCPlus4M;
				
				RegWriteVW <= RegWriteVM;
				RegWriteVVW <= RegWriteVVM;
				
				ReadDataVW <= ReadDataVM;
				IndexW <= IndexM;
			end
		end
	endmodule
	