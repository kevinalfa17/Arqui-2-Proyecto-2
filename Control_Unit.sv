//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    Control_Unit
//
// Description:   Control Unit of the ARM Processor, it creates the controls signals 
//						that go to the datapath and control the diferent elements
//
// Reference:		Digital Design and Computer Architecture - ARM Edition (Sarah L. Harris & David Money Harris)
//////////////////////////////////////////////////////////////////////////////////
module Control_Unit(

		 input logic [1:0] Op,
		 input logic [5:0] Funct,
		 input logic [3:0] Rd,
		 input logic IndexSelect,
		 output logic [1:0] FlagW,
		 output logic PCS,
		 output logic RegW,
		 output logic MemW,
		 output logic MemtoReg,
		 output logic ALUSrc,
		 output logic [1:0] ImmSrc,
		 output logic [1:0] RegSrc,
		 output logic [1:0] ALUControl,
		 output logic NoWrite,
		 output logic Branch,
		 output logic link,
	
		 //vectorial control signals
		 output logic IndexReg,
		 output logic isDot,
		 output logic MemWriteV,
		 output logic RegWriteV,
		 output logic RegWriteVV
);

logic [15:0] controls;
logic ALUOp;

//Main Decoder
always_comb 
	casex(Op)
		//Data processing
		2'b00: 	if (Funct[5]) 		controls = 16'b0000101001000000; //Immediate
					else 					controls = 16'b0000001001000000; //Register
		//Memory
		2'b01:	if (Funct[0])		controls = 16'b0001111000000000; //LDR
					else					controls = 16'b1001110100000000; //STR
		//Branch
		2'b10:	if (Funct[4])		controls = 16'b0110100010100000;
					else					controls = 16'b0110100010000000;
					
		//Vectorial
		2'b11:	if (Funct[4:1] == 1 && IndexSelect)			controls = 16'b0000000000011010; //DOT Index reg
					else if (Funct[4:1] == 1 && !IndexSelect)	controls = 16'b0000000000001010; //DOT Index Imm
					else if (Funct[4:1] == 2 && Funct[5])		controls = 16'b0011100000000010; //MUV Imm
					else if (Funct[4:1] == 2 && !Funct[5])		controls = 16'b0011000000000010; //MUV Reg
					else if (Funct[4:1] == 3)						controls = 16'b0001100000000001; //LDV
					else 													controls = 16'b1001100000000100; //STV
		
		default: 						controls = 16'b0;
	endcase
	

assign {RegSrc, ImmSrc, ALUSrc, MemtoReg, RegW, MemW, Branch, ALUOp, link, IndexReg, isDot, MemWriteV, RegWriteV, RegWriteVV} = controls;

//ALU Decoder
always_comb
	if (ALUOp) begin
		case(Funct[4:1])
			4'b0100: 						begin
													ALUControl = 2'b00; // ADD
													NoWrite = 0;
												end
			
			4'b0010: 						begin	
													ALUControl = 2'b01; // SUB
													NoWrite = 0;
												end
			
			4'b0000: 						begin	
													ALUControl = 2'b10; // AND
													NoWrite = 0;
												end
			
			4'b1100: 						begin	
													ALUControl = 2'b11; // ORR
													NoWrite = 0;
												end
												
			4'b1010 : 						begin
													ALUControl = 2'b01; // CMP
													NoWrite = 1;
												end
			4'b1101 : 						begin
													ALUControl = 0; //MOV //Shift
													NoWrite = 0;
												end
												
			default: 						begin
													ALUControl = 2'b0; // unimplemented
													NoWrite = 0;
												end 
		endcase
		
		FlagW[1] = Funct[0];
		FlagW[0] = Funct[0] & (ALUControl == 2'b00 | ALUControl == 2'b01);
	end
	else begin
		ALUControl = 0;
		FlagW = 0;
		NoWrite = 0;
	end

	assign PCS = ((Rd == 4'b1111) & RegW);

endmodule

	