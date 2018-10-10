//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Kevin Alfaro Vega (2015027603)
// 
// Create Date:    01:26:17 12/03/2018 
//
// Module Name:    alu_v  
//
// Description:    This module takes two 9x9 vectors and multiplicate every Ni element 
		   of the first vector with the Mi element of the second vector, then
		   add all the 9 results into one unique scalar.
//
// Reference: 	   Harris, S. L., & Harris, D. M. (2015). Digital design and computer 
// 					architecture. Amsterdam : Elsevier/Morgan Kaufmann.
//
//////////////////////////////////////////////////////////////////////////////////



module alu_v(
		input logic signed [8:0] SrcAVE[8:0], SrcBVE[8:0],
		output logic signed [31:0] ALUResultVE
	);
	
logic signed [31:0] temp[8:0];
logic signed [31:0] tempResult;
logic productReady;

	always_comb
	begin
	
		//Multiplication
		temp[0] = SrcAVE[0]*SrcBVE[0];
		temp[1] = SrcAVE[1]*SrcBVE[1];
		temp[2] = SrcAVE[2]*SrcBVE[2];
		temp[3] = SrcAVE[3]*SrcBVE[3];
		temp[4] = SrcAVE[4]*SrcBVE[4];
		temp[5] = SrcAVE[5]*SrcBVE[5];
		temp[6] = SrcAVE[6]*SrcBVE[6];
		temp[7] = SrcAVE[7]*SrcBVE[7];
		temp[8] = SrcAVE[8]*SrcBVE[8];
		
		//Addition
		tempResult = temp[0]+temp[1]+temp[2]+temp[3]+temp[4]+temp[5]+temp[6]+temp[7]+temp[8];
			
			
		//Handle limits [-256:255]
		if(tempResult > 255)
			tempResult = 255;
		else if (tempResult < 0)
			tempResult = 0;
			
		ALUResultVE = tempResult;
		
	
	end
	
	
				
endmodule


module alu_v_testbench;

logic signed [8:0] SrcAVE[8:0], SrcBVE[8:0];

alu_v alu_vector (.SrcAVE(SrcAVE), .SrcBVE(SrcBVE));

initial begin
	SrcAVE[0] <= 1;
	SrcAVE[1] <= 2;
	SrcAVE[2] <= 3;
	SrcAVE[3] <= 4;
	SrcAVE[4] <= 5;
	SrcAVE[5] <= 6;
	SrcAVE[6] <= 7;
	SrcAVE[7] <= 8;
	SrcAVE[8] <= 9;
	
	SrcBVE[0] <= 2;
	SrcBVE[1] <= 2;
	SrcBVE[2] <= 2;
	SrcBVE[3] <= 2;
	SrcBVE[4] <= 2;
	SrcBVE[5] <= 1;
	SrcBVE[6] <= 1;
	SrcBVE[7] <= 1;
	SrcBVE[8] <= 1;
end


endmodule