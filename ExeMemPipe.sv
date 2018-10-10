//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Dennis Porras Barrantes (2015084004) 
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    ExeMemPipe
//
// Description:   Pipe of excution and memory stage (signals and data), it has 
//						a reset to set all the signals in low.
//
// Reference:		Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//////////////////////////////////////////////////////////////////////////////////
module ExeMemPipe(

	input logic clk, reset,
	
	//Input Control Signals
	input logic PCSrcE,
	input logic RegWriteE,
	input logic MemtoRegE,
	input logic MemWriteE,
	input logic linkE,
	//Inputs
	input logic [31:0] ALUResultE,
	input logic [31:0] WriteDataE,
	input logic [31:0] PCPlus4E,
	input logic [3:0]  WA3E,
	
	//Output Control Signals
	output logic PCSrcM,
	output logic RegWriteM,
	output logic MemtoRegM,
	output logic MemWriteM,
	output logic linkM,
	//Outputs
	output logic [31:0] ALUResultM,
	output logic [31:0] WriteDataM,
	output logic [31:0] PCPlus4M,
	output logic [3:0] WA3M,
	
	//vector related
	input logic MemWriteVE,
	input logic RegWriteVE,
	input logic RegWriteVVE,
	output logic MemWriteVM,
	output logic RegWriteVM,
	output logic RegWriteVVM,
	
	input logic signed [8:0] WriteDataVE [8:0],
	output logic signed [8:0] WriteDataVM [8:0],
	input logic [3:0] IndexE,
	output logic [3:0] IndexM

	);

always_ff@(posedge clk) begin 
	if(reset) begin
		PCSrcM		<= 0;
		RegWriteM	<= 0;
		MemtoRegM	<= 0;
		MemWriteM	<= 0;
		linkM <= 0;
		
		MemWriteVM <= 0;
		RegWriteVM <= 0;
		RegWriteVVM <= 0;

	end
	else begin
		PCSrcM		<= PCSrcE;
		RegWriteM	<= RegWriteE;
		MemtoRegM	<= MemtoRegE;
		MemWriteM	<= MemWriteE;
		linkM <= linkE;
		
		ALUResultM	<= ALUResultE;
		WriteDataM	<= WriteDataE;
		PCPlus4M <= PCPlus4E;
		WA3M			<= WA3E;
		
		MemWriteVM <= MemWriteVE;
		RegWriteVM <= RegWriteVE;
		RegWriteVVM <= RegWriteVVE;
		
		WriteDataVM <= WriteDataVE;
		IndexM <= IndexE;
	end//end else
end
	
endmodule

