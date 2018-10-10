`timescale 1 ps / 1 ps
module testSerialize(
		input logic clk50,
		input logic clk450,
		input logic [31:0] ALUResult,
		input logic MemWriteVM,
		input logic signed [8:0] WriteDatav [8:0],
		output logic signed [8:0] ReadDatav [8:0]
	);
	

logic [31:0] vaddr;
logic [8:0] pix;


logic [31:0] ser_addr;
logic [8:0] data_in;


logic [8:0] data_out;

logic signed [8:0] WD [8:0];
logic signed [8:0] RD [8:0];
assign WD = WriteDatav;
assign ReadDatav = RD;

		
	serialized_RAM ser(
		.clk(clk450),
		.addressIn(ALUResult),
		.W_E(MemWriteVM),
		.dataIn(WD),
		.dataOut(data_in),
		.addressOut(ser_addr)
	);
	
	ram_mem_v	ram_mem_v_inst (
	.address_a (ser_addr),
	.address_b (vaddr),
	.clock_a (clk450),
	.clock_b (VGA_CLK),
	.data_a (data_in),
	.data_b (0),
	.wren_a (MemWriteVM),
	.wren_b (0),
	.q_a (data_out),
	.q_b (pix)
	);	


	
	deserialized_RAM des(
		.clk(clk450),
		.dataIn(data_out),
		.dataOut(RD)
	);
	
endmodule
`timescale 1 ps / 1 ps
	module testSerialize_testbench;

logic clock50;
logic clock450;



logic [31:0] add;
logic we;
logic signed [8:0] data [8:0];
logic signed [8:0] out [8:0];

testSerialize ser(
		.clk50(clock50),
		.clk450(clock450),
		.ALUResult(add),
		.MemWriteVM(we),
		.WriteDatav(data),
		.ReadDatav(out)
	);
initial begin
	add <= 4;
	we <= 0;
	data[0] <= 21;
	data[1] <= 22;
	data[2] <= 23;
	data[3] <= 24;
	data[4] <= 25;
	data[5] <= 26;
	data[6] <= 27;
	data[7] <= 28;
	data[8] <= 29;
	#180
	we = 1;
	#180
	add <= 2564;
	we = 0;
	data[0] <= 10;
	data[1] <= 20;
	data[2] <= 30;
	data[3] <= 40;
	data[4] <= 50;
	data[5] <= 60;
	data[6] <= 70;
	data[7] <= 80;
	data[8] <= 90;
	#180
	we = 1;
	#180
	we = 0;
	add <= 8;
	#180
	add <= 2568;
end

always begin
	clock50 <= 1; #90; clock50 <= 0; #90;
end

always begin
	clock450 <= 1; #5; clock450 <= 0; #5;
end

endmodule