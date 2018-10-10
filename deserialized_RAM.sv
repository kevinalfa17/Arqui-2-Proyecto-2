//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425) and David Gomez Vargas (2015028430)
// 
// Create Date:    07:00:00 13/04/2018 
//
// Module Name:    deserialized_RAM
//
// Description:    This module is responsible to get several data of RAM of the FPGA 
//					in an temporal memory, when all the data is in the vector, we could 
//					take these, it 's a type of module of match between the data manipulation 
//					of the bits in memory to the registers. Put all in the same clock. 
//
// Reference:	TMDS Encoding Protocol give the idea of how to serialize and deserialize data. 	   
//
//////////////////////////////////////////////////////////////////////////////////

module deserialized_RAM #(parameter WIDTH = 9, COUNT = 18)(

		input logic clk,
		input logic [7:0] dataIn,
		output logic signed [8:0] dataOut [8:0]
	);

	int times = 0;
	logic signed[8:0] dataTem [8:0];

	always_ff @(posedge clk) begin
		
				if ( times == COUNT ) begin
					times = 0;
				end else begin
					if(times == 3) begin
						dataTem[0] = dataIn;
					end else if(times == 4) begin
						dataTem[1] = dataIn;
					end else if(times == 5) begin
						dataTem[2] = dataIn;
					end else if(times == 6) begin
						dataTem[3] = dataIn;
					end else if(times == 7) begin
						dataTem[4] = dataIn;
					end else if(times == 8) begin
						dataTem[5] = dataIn;
					end else if(times == 9) begin
						dataTem[6] = dataIn;
					end else if(times == 10) begin
						dataTem[7] = dataIn;
					end else if(times == 11) begin
						dataTem[8] = dataIn;
					end else if (times == 12) begin
						dataOut = dataTem;
					end
				end
					times = times + 1;
		end
	
endmodule

module deserialized_RAM_testbench;

logic clock;
logic reset;
logic [8:0] di;
logic [8:0] dou [8:0];


deserialized_RAM#(9,9) deser(
		.clk(clock),  
		.dataIn(di), 
		.dataOut(dou) 
		);

initial begin
	reset <= 1;
	#10;
	reset <= 0;

	di <= 1;
	#10;
	di <= 2;
	#10;
	di <= 3;
	#10;
	di <= 4;
	#10;
	di <= 5;
	#10;
	di <= 6;
	#10;
	di <= 7;
	#10;
	di <= 8;
	#10;
	di <= 9;
	#10;
	di <= 10;
	#10;
	di <= 11;
	#10;
	di <= 12;
	#10;

end

always begin
	clock <= 1; #5; clock <= 0; #5;
end

endmodule

