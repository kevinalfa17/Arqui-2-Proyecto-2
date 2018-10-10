//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015014425),
// 			  Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    datapath
//
// Description:   Datapath of the ARM Processor with all the combinational and 
//						secuential elements that make posible the excecution of intructions.
//						It also controls the condition unit.
//
// Reference:		Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//////////////////////////////////////////////////////////////////////////////////
module datapath (
	input logic clk,
	input logic reset,
	input logic [1:0] RegSrc,
	input logic RegWrite,
	input logic [1:0] ImmSrc,
	input logic ALUSrc,
	input logic [1:0] ALUControl,
	input logic MemtoReg,
	input logic PCSrc,
	input logic [1:0] Flagwrite,
	output logic [31:0] PC, InstrD,
	input logic [31:0] Instr,
	output logic [31:0] ALUResultM,
	output logic [31:0] WriteData,
	input logic[31:0] ReadData,
	input logic NoWrite,
	input logic link,
	input logic MemWriteD,
	output logic MemWriteM,
	input logic Branch,

	//Hazard unit inputs/outputs
	output logic [3:0] RA1E, 
	output logic [3:0] RA2E,
	output logic [3:0] WA3M, 
	output logic [3:0] WA3W,
	output logic RegWriteM,
	output logic RegWriteW,
	input	logic [1:0] ForwardAE,
	input	logic [1:0] ForwardBE,

	output logic [3:0] RA1D, 
	output logic [3:0] RA2D,
	output logic [3:0] WA3E,
	output logic MemtoRegE,
	input logic StallF,
	input logic StallD,
	input logic FlushE,

	output logic PCSrcE,
	output logic PCSrcM,
	output logic BranchTakenE,
	output logic PCSrcW,
	input logic FlushD,
	input [3:0] keySWInpDP,
	
	//Vectorial related
	input logic IndexRegD,
	input logic isDotD,
	input logic MemWriteVD,
	output logic MemWriteVM,
	input logic RegWriteVD,
	input logic RegWriteVVD,
	
	output logic signed [8:0] WriteDataV[8:0],
	input logic signed [8:0] ReadDataV[8:0],
	
	output logic [3:0] RA2D0,
	output logic RegWriteVVE,
	output logic RegWriteVVW,
	input logic ForwardBVE,
	output logic [3:0] RA2VE,
	
	output logic led1,
	output logic led2,
	output logic led3
	);
	
 	//Control signal
  logic [31:0] PCPlus4F;
  logic [31:0] ResultW;
  logic [31:0] PCnext, PCnext1;
  
  logic [31:0] PCPlus4D;
  logic [31:0] RD1, RD2, ExtImmD;
  logic [3:0] Flags;
  
  logic RegWriteE, MemWriteE, ALUSrcE, NoWriteE, BranchE, linkE;
  logic [1:0] ALUControlE, FlagWriteE;
  logic [31:0] RD1E, RD2E,ExtImmE, PCPlus4E;
  logic [3:0] CondE, FlagsE;
  
  logic [31:0] SrcAE, SrcBE, RegBData;
  logic [3:0] ALUFlagsE;
  logic [31:0] ALUResultE;
  logic [31:0] ALUResultSE;
  logic [31:0] PCPlus4M;
  logic  MemtoRegM;
  logic linkM;
  
  logic MemtoRegW, linkW;
  logic [31:0] RDW, ALUOutW, PCPlus4W;
  
  logic link_cond, PCSrc_cond, Regwrite_cond, MemWrite_cond;
  
  logic [31:0] FWDRESULTB;

  logic [1:0] FlagInterrupt;

  logic [31:0] muxBraTomuxInterr;
  logic [31:0] interrTomuxBraTomuxInterr; // desde interrupciones al mux que deja o no el pc actual
    
	
	//Vectorial logics Datapath
	logic signed [8:0] RD1VD[8:0], RD2VD[8:0];
	
	logic signed [8:0] RD1VE[8:0], RD2VE[8:0], SrcBVE[8:0];
	logic [3:0] IndexE0;
	logic [3:0] IndexE;
	logic [3:0] IndexM;
	logic [3:0] IndexW;
		
	logic signed [8:0] ReadDataVM[8:0];
	logic signed [8:0] ReadDataVW[8:0];
	
	
	logic [31:0] ALUResultVE;
	
	logic [4:0] shift_amountE;
	logic [1:0] type_opE;
	
	logic [3:0] RA1VE;
	
	
	logic isDotE;
	logic IndexRegE;
	logic MemWriteVE;
	logic RegWriteVE;
	logic RegWriteVM;
	logic RegWriteVW;
	logic RegWriteVVM;
	
	logic MemWriteVE2;
	logic RegWriteVE2;
	logic RegWriteVVE2;
	
	
  //FETCH
  mux2#(32) pc_mux(
			.s(PCSrcW),
			.d0(PCPlus4F),
			.d1(ResultW),
			.y(PCnext1)
  );
  
  mux2#(32) pc_mux2(
			.s(BranchTakenE),
			.d0(PCnext1),
			.d1(ALUResultE),
			.y(muxBraTomuxInterr)
  );
  
  mux2#(32) pc_interruptionPC(
			.s(0),
			.d0(muxBraTomuxInterr),
			.d1(interrTomuxBraTomuxInterr),
			.y(PCnext)
  );

  pc#(32) pc_reg(
			.clk(clk),
			.reset(reset),
			.d(PCnext),
			.q(PC),
			.StallF(StallF),
			.led1(led1),
			.led2(led2),
			.led3(led3)
			
  );

  //(Instruction memory is outside)
  
  adder#(32) pc_add_4(
			.a(PC),
			.b(4),
			.y(PCPlus4F)
	);
	
  FetchDecoPipe FDPipe(
			.clk(clk), .reset(reset),
			.InstrF(Instr),
			.InstrD(InstrD),
			.PCPlus4F(PCPlus4F),
			.PCPlus4D(PCPlus4D),
			.StallD(StallD),
			.FlushD(FlushD)
  );
  
  
  //DECO
  
  mux2#(4) RA1_MUX(
			.s(RegSrc[0]),
			.d0(InstrD[19:16]),
			.d1(15),
			.y(RA1D)
	);
  
  mux2#(4) RA2_MUX0(
			.s(RegSrc[1]),
			.d0(InstrD[3:0]),
			.d1(InstrD[15:12]),
			.y(RA2D0)
	);
	
	//Mux used in vectorial index with register
	mux2#(4) RA2_MUX(
			.s(IndexRegD),
			.d0(RA2D0),
			.d1(InstrD[10:7]),
			.y(RA2D)
	);
  
  regfile registerFile(
			.clk(~clk),
			.reset(reset),
			.we3(RegWriteW),
			.ra1(RA1D),
			.ra2(RA2D),
			.wa3(WA3W),
			.rd1(RD1),
			.rd2(RD2),
			.pc4(PCPlus4W),
			.wd3(ResultW),
			.r15(PCPlus4F),
			.link(linkW)
	);
  
  extend extendImmediate(
			.Instr(InstrD[23:0]),
			.ImmSrc(ImmSrc),
			.ExtImm(ExtImmD)
	);
  
  DecoExePipe DEPipe(
			.clk(clk), .reset(reset),
			.PCSrcD(PCSrc), .RegWriteD(RegWrite), .MemtoRegD(MemtoReg), .MemWriteD(MemWriteD), .ALUControlD(ALUControl), .FlagWriteD(Flagwrite), .ALUSrcD(ALUSrc), .CondD(InstrD[31:28]), .NoWriteD(NoWrite), .BranchD(Branch), .linkD(link),
			.RD1D(RD1), .RD2D(RD2), .ExtImmD(ExtImmD), .PCPlus4D(PCPlus4D),
			.WA3D(InstrD[15:12]), .FlagsD(Flags),
			.PCSrcE(PCSrcE), .RegWriteE(RegWriteE), .MemtoRegE(MemtoRegE), .MemWriteE(MemWriteE), .ALUControlE(ALUControlE), .FlagWriteE(FlagWriteE), .ALUSrcE(ALUSrcE), .CondE(CondE), .NoWriteE(NoWriteE), .BranchE(BranchE), .linkE(linkE),
			.RD1E(RD1E), .RD2E(RD2E), .ExtImmE(ExtImmE), .PCPlus4E(PCPlus4E),
			.WA3E(WA3E), .FlagsE(FlagsE), .RA1D(RA1D), .RA2D(RA2D), .RA1E(RA1E), .RA2E(RA2E),
			.FlushE(FlushE),
			
			.IndexRegD(IndexRegD),
			.isDotD(isDotD),
			.MemWriteVD(MemWriteVD),
			.RegWriteVD(RegWriteVD),
			.RegWriteVVD(RegWriteVVD),
			.IndexRegE(IndexRegE),
			.isDotE(isDotE),
			.MemWriteVE(MemWriteVE),
			.RegWriteVE(RegWriteVE),
			.RegWriteVVE(RegWriteVVE),
			
			.RD1VD(RD1VD), .RD2VD(RD2VD),
			.RA1VD(InstrD[19:16]), .RA2VD(RA2D0), 
			.IndexD(InstrD[11:8]), 
			.RD1VE(RD1VE), .RD2VE(RD2VE), 
			.RA1VE(RA1VE), .RA2VE(RA2VE), 
			.IndexE0(IndexE0),
			.shift_amountD(InstrD[11:7]),
			.type_opD(InstrD[6:5]),
			.shift_amountE(shift_amountE),
			.type_opE(type_opE)
	);
	
	
regvfile RegVectorial(
			.clk(~clk),
			.wee(RegWriteVW), .wev(RegWriteVVW),
			.ra1(InstrD[19:16]), .ra2(RA2D0), .wa(WA3W),
			.index(IndexW),
			.wdv(ReadDataVW),
			.wde(ResultW[8:0]),
			.rd1(RD1VD), .rd2(RD2VD)
	);
	
	
	
  //EXE 
  
  /***mux2#(32) OperA_MUX(//Este hp va a cambiar el cero se borra
			.s(1),
			.d0(RD1E),
			.d1(0),
			.y(SrcAE)
	);***/
  
   /***mux2#(32) OperB_MUX(
			.s(ALUSrcE),
			.d0(RD2E),
			.d1(ExtImmE),
			.y(SrcBE)
   );***/
  
  
  mux3#(32) OperA_MUX(//Forward mux
			.s(ForwardAE),
			.d0(RD1E),
			.d1(ResultW),
			.d2(ALUResultM),
			.y(SrcAE)
	);
	
	mux3#(32) FowardB_MUX(
			.s(ForwardBE),
			.d0(RD2E),
			.d1(ResultW),
			.d2(ALUResultM),
			.y(FWDRESULTB)
	);
	
	shift shift_data(
		.input_shift(FWDRESULTB),
		.shift_amount(shift_amountE),
		.type_op(type_opE),
		.output_shift(RegBData));
  
   mux2#(32) OperB_MUX(
			.s(ALUSrcE),
			.d0(RegBData),
			.d1(ExtImmE),
			.y(SrcBE)
   );
	
  
  alu alu_arm(
			.SrcAE(SrcAE),
			.SrcBE(SrcBE),
			.ALUControlE(ALUControlE),
			.ALUFlags(ALUFlagsE),
			.ALUResult(ALUResultSE)
  );
  
  condition_unit cond_unit(
			.clk(clk), .reset(reset),
			.FlagWriteE(FlagWriteE),
			.FlagsE(FlagsE), .CondE(CondE), .ALUFlagsE(ALUFlagsE),
			.BranchE(BranchE), .MemWriteE(MemWriteE), 
			.RegWriteE(RegWriteE), .PCSrcE(PCSrcE), .linkE(linkE), .NoWrite(NoWriteE),
			.Flags(Flags),
			.MemWrite(MemWrite_cond), .RegWrite(Regwrite_cond), 
			.PCSrc(PCSrc_cond), .link(link_cond),
			.BranchTakenE(BranchTakenE),
			.MemWriteVE(MemWriteVE),.RegWriteVE(RegWriteVE),.RegWriteVVE(RegWriteVVE),
			.MemWriteVE2(MemWriteVE2),.RegWriteVE2(RegWriteVE2),.RegWriteVVE2(RegWriteVVE2)
);

  
  ExeMemPipe EMPipe(
			.clk(clk), .reset(reset),
			.PCSrcE(PCSrc_cond),
			.RegWriteE(Regwrite_cond),
			.MemtoRegE(MemtoRegE),
			.MemWriteE(MemWrite_cond),
			.linkE(link_cond),
			 
			.ALUResultE(ALUResultE),
			.WriteDataE(FWDRESULTB), //Aqui estaba RD2E en lugar de FWDRESULTB y no se si estaba mal
			.PCPlus4E(PCPlus4E),
			.WA3E(WA3E),
			 
			.PCSrcM(PCSrcM),
			.RegWriteM(RegWriteM),
			.MemtoRegM(MemtoRegM),
			.MemWriteM(MemWriteM),
			.linkM(linkM),
			
			.ALUResultM(ALUResultM),
			.WriteDataM(WriteData),
			.PCPlus4M(PCPlus4M),
			.WA3M(WA3M),
			
			
			.MemWriteVE(MemWriteVE2),
			.RegWriteVE(RegWriteVE2),
			.RegWriteVVE(RegWriteVVE2),
			
			.MemWriteVM(MemWriteVM),
			.RegWriteVM(RegWriteVM),
			.RegWriteVVM(RegWriteVVM),
			
			.WriteDataVE(RD2VE),
			.WriteDataVM(WriteDataV),
			.IndexE(IndexE),
			.IndexM(IndexM)
  );


 mux2V FowardBV_MUX(
			.s(ForwardBVE),
			.d0(RD2VE),
			.d1(ReadDataVW),
			.y(SrcBVE)
   );
	
 alu_v alu_vectorial(
			.SrcAVE(RD1VE),
			.SrcBVE(SrcBVE),
			.ALUResultVE(ALUResultVE)
  );
 
//Este mux selecciona entre resultado de la alu vectorial y escalar
 mux2#(32) ALUResult_MUX(
			.s(isDotE),
			.d0(ALUResultSE),
			.d1(ALUResultVE),
			.y(ALUResultE)
   );

//Mux para seleccionar index imm o reg
mux2#(4) Index_MUX(
			.s(IndexRegE),
			.d0(IndexE0),
			.d1(FWDRESULTB[3:0]),
			.y(IndexE)
   );
  
  //MEM
  
  
  MemWbPipe MWPipe(
			.clk(clk), .reset(reset),
			.PCSrcM(PCSrcM), .RegWriteM(RegWriteM), .MemtoRegM(MemtoRegM), .linkM(linkM),
			.RDM(ReadData), .ALUOutM(ALUResultM), .PCPlus4M(PCPlus4M),
			.WA3M(WA3M),
			.PCSrcW(PCSrcW), .RegWriteW(RegWriteW), .MemtoRegW(MemtoRegW), .linkW(linkW),
			.RDW(RDW), .ALUOutW(ALUOutW), .PCPlus4W(PCPlus4W),
			.WA3W(WA3W),
			
			.RegWriteVM(RegWriteVM),
			.RegWriteVVM(RegWriteVVM),
			.RegWriteVW(RegWriteVW),
			.RegWriteVVW(RegWriteVVW),
			
			.ReadDataVM(ReadDataV),
			.ReadDataVW(ReadDataVW),
	
			.IndexM(IndexM),
			.IndexW(IndexW)
		
  );
  
  //WB
  
  mux2#(32) WriteBack_MUX(
			.s(MemtoRegW),
			.d0(ALUOutW),
			.d1(RDW),
			.y(ResultW)
   );
  
  controlInterrupt#(148) cont_inte(
		.clock(clk),
		.interruptSWInKey(keySWInpDP),
		.pcPrevState(PC),
		//out
		.onInterrupt(FlagInterrupt),
		.pcNextState(interrTomuxBraTomuxInterr)
	);
  
  
	
endmodule