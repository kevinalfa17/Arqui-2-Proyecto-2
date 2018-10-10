//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430), Gabriel Barboza Alvarez (2015014425),
// 			  Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    Arm_Processor
//
// Description:   This is the main module where all the modules are instantiated
//						and onnect all the modules between them.
//
// Reference:	
//////////////////////////////////////////////////////////////////////////////////
module ARM_Processor (
	input clk,
	input reset,
	input [3:0] keySWInpP,
	input image,
	output logic [7:0]		VGA_B,
	output logic     		VGA_BLANK_N,
	output logic       		VGA_CLK,
	output logic [7:0]		VGA_G,
	output logic				VGA_HS,
	output logic [7:0]		VGA_R,
	output logic       		VGA_SYNC_N,
	output logic       		VGA_VS,
	output logic ledp,
	output logic ledp2,
	output logic ledp3,
	output logic ledp4,
	output logic ledp5,
	output logic ledp6,
	output logic ledp7
	
	);
	logic clk450;
	logic clk900;
	logic [31:0] PC;

	logic [31:0] Instr; 
	logic [31:0] InstrD;
	
	logic [31:0] ALUResult, WriteData, ReadData;
	
	logic MemWriteM, PCS, RegW, MemW, MemtoReg, ALUSrc, NoWrite, Branch, link;
	
	logic [1:0] ALUControl, FlagW, ImmSrc, RegSrc;
	
	//Hazard
	logic [3:0] RA1E, RA2E, WA3M, WA3W;
	logic RegWriteM, RegWriteW;
	logic [1:0] ForwardAE, ForwardBE;
	
	logic [3:0] RA1D;
	logic [3:0] RA2D;
	logic [3:0] WA3E;
	logic MemtoRegE;
	logic StallF;
	logic StallD;
	logic FlushE;
	
	logic PCSrcE;
	logic PCSrcM;
	logic BranchTakenE;
	logic PCSrcW;
	logic FlushD;
	logic vclk;
	
	logic IndexReg;
	logic isDot;
	logic MemWriteV;
	logic MemWriteVM;
	logic RegWriteV;
	logic RegWriteVV;
	logic RegWriteVVE;
	logic RegWriteVVW;
	logic ForwardBVE;
	
	logic signed [8:0] WriteDataV[8:0];
	logic signed [8:0] ReadDataV[8:0];
	logic [3:0] RA2VD;
	logic [3:0] RA2VE;
	
	
	
logic sync = 0;
logic blank = 1;
logic clkv;
wire [31:0] vaddr;
wire [31:0] ser_addr;
logic [8:0] pix;
logic [8:0] data_out;
logic [8:0] data_in;
wire [7:0] scene_pixel_r;
wire [7:0] scene_pixel_g;
wire [7:0] scene_pixel_b;
wire [9:0]	hcount;
wire [9:0] 	vcount;
assign VGA_SYNC_N = sync;
assign VGA_BLANK_N = blank;
logic signed[8:0] WD [8:0];
logic signed [8:0] RD [8:0];
assign WD = WriteDataV;
assign ReadDataV = RD;
assign VGA_CLK = clkv;
	
	
Control_Unit controller(
		.Op(InstrD[27:26]),
		.Funct(InstrD[25:20]),
		.Rd(InstrD[15:12]),
		.FlagW(FlagW),
		.PCS(PCS),
		.RegW(RegW),
		.MemW(MemW),
		.MemtoReg(MemtoReg),
		.ALUSrc(ALUSrc),
		.ImmSrc(ImmSrc),
		.RegSrc(RegSrc),
		.ALUControl(ALUControl),
		.NoWrite(NoWrite),
		.Branch(Branch),
		.link(link),
		
		//vectorial related
		.IndexSelect(InstrD[4]),
		.IndexReg(IndexReg),
		.isDot(isDot),
		.MemWriteV(MemWriteV),
		.RegWriteV(RegWriteV),
		.RegWriteVV(RegWriteVV)
		
);	

Hazard_Unit hazard_unit(
		.RA1E(RA1E), 
		.RA2E(RA2E),
		.WA3M(WA3M), 
		.WA3W(WA3W),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		.RA1D(RA1D),
		.RA2D(RA2D),
		.WA3E(WA3E),
		.MemtoRegE(MemtoRegE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE),
		.PCSrcD(PCS),
		.PCSrcE(PCSrcE),
		.PCSrcM(PCSrcM),
		.BranchTakenE(BranchTakenE),
		.PCSrcW(PCSrcW),
		.FlushD(FlushD),
		.RA1VD(InstrD[19:16]),
		.RA2VD(RA2VD),
		.RegWriteVVE(RegWriteVVE),
		.RegWriteVVW(RegWriteVVW),
		.ForwardBVE(ForwardBVE),
		.RA2VE(RA2VE)
);
	
datapath d_p(
		.clk(clk),
		.reset(reset),
		.RegSrc(RegSrc),
		.RegWrite(RegW),
		.ImmSrc(ImmSrc),
		.ALUSrc(ALUSrc),
		.ALUControl(ALUControl),
		.MemtoReg(MemtoReg),
		.PCSrc(PCS),
		.Flagwrite(FlagW),
		.PC(PC),
		.InstrD(InstrD),
		.Instr(Instr),
		.ALUResultM(ALUResult),
		.WriteData(WriteData),
		.ReadData(ReadData),
		.NoWrite(NoWrite),
		.link(link),
		.MemWriteD(MemW),
		.MemWriteM(MemWriteM),
		.Branch(Branch),
		.RA1E(RA1E), 
		.RA2E(RA2E),
		.WA3M(WA3M), 
		.WA3W(WA3W),
		.RegWriteM(RegWriteM),
		.RegWriteW(RegWriteW),
		.ForwardAE(ForwardAE),
		.ForwardBE(ForwardBE),
		
		.RA1D(RA1D),
		.RA2D(RA2D),
		.WA3E(WA3E),
		.MemtoRegE(MemtoRegE),
		.StallF(StallF),
		.StallD(StallD),
		.FlushE(FlushE),
		
		.PCSrcE(PCSrcE),
		.PCSrcM(PCSrcM),
		.BranchTakenE(BranchTakenE),
		.PCSrcW(PCSrcW),
		.FlushD(FlushD),
		.keySWInpDP(keySWInpP),
		
		//Vector related
		.IndexRegD(IndexReg),
		.isDotD(isDot),
		.MemWriteVD(MemWriteV),
		.MemWriteVM(MemWriteVM),
		.RegWriteVD(RegWriteV),
		.RegWriteVVD(RegWriteVV),
		.WriteDataV(WriteDataV),
		.ReadDataV(ReadDataV),
		.RA2D0(RA2VD),
		.RegWriteVVE(RegWriteVVE),
		.RegWriteVVW(RegWriteVVW),
		.ForwardBVE(ForwardBVE),
		.RA2VE(RA2VE),
		.led1(ledp),
		.led2(ledp2),
		.led3(ledp3)
	);
	
	
	ram_mem_i	ram_mem_i_inst (
	.address ( PC[31:2] ),
	.clock ( clk900 ),
	.q ( Instr )
	);


	
dmem data_memory(
		.clk(clk), .we(MemWriteM),
		.a(ALUResult), .wd(WriteData),
		.rd(ReadData)
);


pll	div25MHz (
	.inclk0 ( clk ),
	.c0 ( clkv ));
	
	pll_900	pll_900_inst (
	.inclk0 ( clk ),
	.c0 ( clk900 )
	);
	
	pll450MHz	pll450MHz_inst (
	.inclk0 ( clk ),
	.c0 ( clk450 )
	);



	
vga_controller vcontroller(
	.clk(VGA_CLK),
	.final_pixel_r(scene_pixel_r),
	.final_pixel_g(scene_pixel_g),
	.final_pixel_b(scene_pixel_b),
	.hcount(hcount),
	.vcount(vcount),
	.vsync(VGA_VS),
	.hsync(VGA_HS),
	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B)
	);

draw_pixel dp(
		.hcount(hcount), 
		.vcount(vcount),
		//.clk(c),
		.clk(VGA_CLK),
		.pixel(pix),
		.image(image),
		.pixel_r(scene_pixel_r),
		.pixel_g(scene_pixel_g),
		.pixel_b(scene_pixel_b),
		.adr(vaddr)
);


ram_mem_v	ram_mem_v_inst (
	.address_a (ser_addr),
	.address_b (vaddr),
	.clock_a (clk900),
	.clock_b (VGA_CLK),
	.data_a (data_in),
	.data_b (0),
	.wren_a (MemWriteVM),
	.wren_b (0),
	.q_a (data_out),
	.q_b (pix)
	);	


	serialized_RAM ser(
		.clk(clk900),
		.addressIn(ALUResult),
		.W_E(MemWriteVM),
		.dataIn(WD),
		.dataOut(data_in),
		.addressOut(ser_addr)
	);
	
	deserialized_RAM des(
		.clk(clk900),
		.dataIn(data_out),
		.dataOut(RD)
	);
	
	
endmodule
`timescale 1ns / 1ps
module ARM_Processor_testbench;

logic clk, VGA_VS, VGA_SYNC_N, VGA_HS, VGA_CLK, VGA_BLANK_N,c;
logic reset,led;
logic [3:0] keySW;
logic [7:0] VGA_B;
logic [7:0] VGA_G;
logic [7:0] VGA_R;


ARM_Processor arm_vectorial(
		//.c(c),
		.clk(clk), 
		.reset(reset), 
		.keySWInpP(keySW),
		.image(1),
		.VGA_B(VGA_B),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_CLK(VGA_CLK),
		.VGA_G(VGA_G),
		.VGA_HS(VGA_HS),
		.VGA_R(VGA_R),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_VS(VGA_VS),
		.ledp(led));

initial begin
	reset <= 1; #50; reset <= 0; keySW <= 4'b0000; #3; keySW <= 4'b0000; #2; keySW <= 4'b0000;
	//reset <= 1; #22; reset <= 0; keySW <= 4'b0000;

	end

always begin
	clk <= 1; #10; clk <= 0; #10;
end

always begin
	c <= 1; #20; c <= 0; #20;
end

endmodule

