//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425) and David Gomez Vargas (2015028430)
// 
// Create Date:    05:00:00 13/04/2018 
//
// Module Name:    serialized_RAM
//
// Description:    This module is responsible to put several data in RAM of the FPGA, 
//					it 's a type of module of merge or match between the data manipulation 
//					of the bits in vectors from registers to memory. Put all in the same clock. 
//
// Reference: TMDS Encoding Protocol give the idea of how to serialize and deserialize data.	   
//
//////////////////////////////////////////////////////////////////////////////////

module serialized_RAM #(parameter WIDTH = 9, COUNT = 18)(
		input logic clk,
		input logic [31:0] addressIn,
		input logic W_E,
		input logic signed [8:0] dataIn [8:0],
		output logic [8:0] dataOut,
		output logic [31:0] addressOut
	);

	int times = 0;

	logic [31:0] contAdd = 614450;

	always_ff @(posedge clk)
	begin
			if ( times == COUNT ) begin
				times = 0;
			end
			if ( W_E ) begin
					if (times<=8) begin
					dataOut = dataIn[times];	
					addressOut = addressIn[31:2] + (times);
					end else begin
					dataOut = 0;	
					addressOut = contAdd;
					end
				end else begin
					case(times)
						0:
						begin
							if ( ((addressIn[31:2]) <= 639) || ((addressIn[31:2])%640 == 0) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] - (641); // add -641
							end
						end
						1:
						begin
							if ( ((addressIn[31:2]) <= 639) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] - (640); // add -640
							end
						end
						2:
						begin
							if ( ((addressIn[31:2])<=639) || (((addressIn[31:2])-639)%640==0) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] - (639); // add -639
							end
						end
						3:
						begin
							if ( ((addressIn[31:2])%640==0) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] - (1); // add -1
							end
						end
						4:
							addressOut = addressIn[31:2] ;  // add 
						5:
						begin
							if ( (((addressIn[31:2])-639)%640==0) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] + (1); // add +1
							end
						end
						6:
						begin
							if ( ((addressIn[31:2])%640==0) || ((addressIn[31:2])>=306560) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] + (639); // add +639
							end
						end
						7:
						begin
							if ( ((addressIn[31:2])>=306560) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] + (640); // add +640
							end
						end
						8:
						begin
							if ( (((addressIn[31:2])-639)%640==0) || ((addressIn[31:2])>=306560) ) begin
								addressOut = contAdd;	
							end else begin
								addressOut = addressIn[31:2] + (641); // add +641
							end
						end
						default:
							addressOut = 0;
					endcase
				end
			times = times + 1;
	end

endmodule

module serialized_RAM_testbench;

logic clock;
logic reset;
logic [31:0] add1;
logic we;
logic signed [8:0] di [8:0];
logic [8:0] dou;
logic [31:0] add2;


serialized_RAM#(9,9) ser(
		.clk(clock), 
		.addressIn(add1),
		.W_E(we),
		.dataIn(di), 
		.dataOut(dou),
		.addressOut(add2)
		);

initial begin
	add1 <= 1000;
	we <= 1;
	di[0] <= 1;
	di[1] <= 2;
	di[2] <= 3;
	di[3] <= 4;
	di[4] <= 5;
	di[5] <= 6;
	di[6] <= 7;
	di[7] <= 8;
	di[8] <= 9;
	reset <= 1;
	#5;
	reset <= 0;

end

always begin
	clock <= 1; #5; clock <= 0; #5;
end

endmodule



