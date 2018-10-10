//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    condition_unit
//
// Description:   This module checks if the flags of every instruction it true, so
//						it can be executed in the following stages. Also i verify if a branch
//						is taken and enable the PC to that address.
//						
// Reference:		Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//////////////////////////////////////////////////////////////////////////////////
module condition_unit (
	input clk, reset,
	input logic [1:0] FlagWriteE,
	input logic [3:0] FlagsE, CondE, ALUFlagsE,
	input logic BranchE, MemWriteE, RegWriteE, PCSrcE, linkE, NoWrite,
	output logic [3:0] Flags,
	output logic MemWrite, RegWrite, PCSrc, link, BranchTakenE,
	//vectorial
	input logic MemWriteVE, RegWriteVE, RegWriteVVE,
	output logic MemWriteVE2, RegWriteVE2, RegWriteVVE2
);

logic neg, zero, _carry, overflow, ge, CondEx, Branch;
logic [1:0] FlagWrite;

flopenr#(2) Flag_Reg1(
		.clk(clk), .reset(reset), .en(FlagWrite[1]),
		.d(ALUFlagsE[3:2]),
		.q(Flags[3:2])
);

flopenr#(2) Flag_Reg2(
		.clk(clk), .reset(reset), .en(FlagWrite[0]),
		.d(ALUFlagsE[1:0]),
		.q(Flags[1:0])
);

always_comb begin
	{overflow, _carry, zero, neg } = Flags;
	ge = (neg == overflow);
	case(CondE)
		4'b0000: CondEx = zero; //EQ
		4'b0001: CondEx = ~zero; //NE
		4'b0010: CondEx = _carry; //CS
		4'b0011: CondEx = ~_carry; //CC
		4'b0100: CondEx = neg; //MI
		4'b0101: CondEx = ~neg; //PL
		4'b0110: CondEx = overflow; //VS
		4'b0111: CondEx = ~overflow;//VC
		4'b1000: CondEx = _carry & ~zero;//HI
		4'b1001: CondEx = ~(_carry & ~zero);//LS
		4'b1010: CondEx = ge; //GE
		4'b1011: CondEx = ~ge; //LT
		4'b1100: CondEx = ~zero & ge;//GT
		4'b1101: CondEx = ~(~zero & ge);//LE
		4'b1110: CondEx = 1;//ALways
		default: CondEx = 0;//undifined
	endcase
end

assign FlagWrite = FlagWriteE & {2{CondEx}};

assign RegWrite = RegWriteE & CondEx & ~NoWrite;
assign MemWrite = MemWriteE & CondEx;
assign PCSrc = (PCSrcE & CondEx) | (BranchE & CondEx);
assign link = linkE & CondEx;
assign BranchTakenE = BranchE && CondEx;

assign RegWriteVE2 = RegWriteVE & CondEx;
assign RegWriteVVE2 = RegWriteVVE & CondEx;
assign MemWriteVE2 = MemWriteVE & CondEx;

endmodule
