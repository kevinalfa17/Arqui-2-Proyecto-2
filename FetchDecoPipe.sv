//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    FetchDecoPipe  
//
// Description:    This module is a pipe register used to keep pipeline control signals and 
	           data, this pipe have a stall and flush signals for hazards control.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////


module FetchDecoPipe (
		input logic clk, reset,
		input logic [31:0] InstrF, PCPlus4F,
		input logic StallD,
		input logic FlushD,
		output logic [31:0] InstrD, PCPlus4D
		);
		
		always_ff @(posedge clk) begin
			if(reset) begin
				InstrD <= 0;
				PCPlus4D <= 0;
			end
			else begin
			
				if(!StallD) begin
						InstrD <= InstrF;
						PCPlus4D <= PCPlus4F;
				end
				if(FlushD) begin
					InstrD <= 0;
					PCPlus4D <= 0;
				end
			end//end else
		end
endmodule