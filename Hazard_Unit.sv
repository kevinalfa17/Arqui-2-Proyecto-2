//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    Hazard Unit  
//
// Description:    This module is used to solve data and control hazards. It check some control
		   signals to determine when a instruction will need a data when that one is
	           not ready (still in mem or writeback stage), in this case the module make a
		   forwarding process between Mem/Exe and WB/Exe. For the LDR and LDRV instruccion
		   the module make a stall to solve the hazard. For branch hazards it makes branch
		   prediction with stalls and flush.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////


module Hazard_Unit(
		//Forwarding input/output
		input logic [3:0] RA1E,
		input logic [3:0] RA2E,
		input logic [3:0] RA2VE,
		input logic [3:0] WA3M,
		input logic [3:0] WA3W,
		input logic RegWriteM,
		input logic RegWriteW,
		input logic RegWriteVVE,
		input logic RegWriteVVW,
		output logic [1:0] ForwardAE,
		output logic [1:0] ForwardBE,
		output logic ForwardBVE,
		//Stall input/output LDR
		input logic [3:0] RA1D,
		input logic [3:0] RA2D,
		input logic [3:0] RA1VD,
		input logic [3:0] RA2VD,
		input logic [3:0] WA3E,
		input logic MemtoRegE,
		output logic StallF,
		output logic StallD,
		output logic FlushE,
		//Stall input/output B
		input logic PCSrcD,
		input logic PCSrcE,
		input logic PCSrcM,
		input logic BranchTakenE,
		input logic PCSrcW,
		output logic FlushD
		
		/*PCSrcD
		PCSrcE
		PCSrcM
		BranchTakenE
		PCSrcW
		FlushD*/
		
);

logic LDRStall = 0;
logic LDRStallV = 0;
logic PCWrPendingF = 0;

//Forwarding SrcA
always_comb
	if((RA1E == WA3M) && RegWriteM) 
		ForwardAE = 2'b10; // SrcAE = ALUOutM
		
	else if ((RA1E == WA3W) && RegWriteW) 
		ForwardAE = 2'b01; // SrcAE = ResultW
		
	else
		ForwardAE = 2'b00; // SrcAE from regfile

//Forwarding SrcB
always_comb
	if((RA2E == WA3M) && RegWriteM) 
		ForwardBE = 2'b10; // SrcBE = ALUOutM
		
	else if ((RA2E == WA3W) && RegWriteW) 
		ForwardBE = 2'b01; // SrcBE = ResultW
		
	else
		ForwardBE = 2'b00; // SrcBE from regfile
		
//Forwarding vectorial B
always_comb
	if((RA2VE == WA3W) && RegWriteVVW) 
		ForwardBVE = 1; // SrcBVE = ReadDataVW
	else
		ForwardBVE = 0; // SrcBVE = RD2VE 
		
//Stalling
always_comb begin

	LDRStall = (((RA1D == WA3E) || (RA2D == WA3E)) && MemtoRegE);
	LDRStallV = ((((RA1VD == WA3E) || (RA2VD == WA3E)) && RegWriteVVE));
	
	PCWrPendingF = (PCSrcD || PCSrcE || PCSrcM);
	StallF = (LDRStall || PCWrPendingF) || LDRStallV;
	StallD = LDRStall || LDRStallV;
	FlushE = LDRStall || BranchTakenE || LDRStallV;
	FlushD = PCWrPendingF || PCSrcW || BranchTakenE;
	
	end
	
endmodule