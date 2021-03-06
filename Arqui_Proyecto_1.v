//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430), Gabriel Barboza Alvarez (2015014425),
// 			  Dennis Porras Barrantes (2015084004) and Kelvin Alfaro Vega (2015027603)
// 
//	Create Date:    07:00:00 13/04/2018 
//
// Module Name:    Arqui_Proyecto_1
//
// Description:   This is the top module of the project, it has the input 
//						and output pins, and call the ARM processor.
//
// Reference:	Generated by top builder.
//////////////////////////////////////////////////////////////////////////////////
module Arqui_Proyecto_1(

	//////////// CLOCK //////////
	input 		          		CLOCK_50,
	input 		          		CLOCK2_50,
	input 		          		CLOCK3_50,

	//////////// LED //////////
	output		     [8:0]		LEDG,
	output		    [17:0]		LEDR,

	//////////// KEY //////////
	input 		     [3:0]		KEY,

	//////////// SW //////////
	input 		    [17:0]		SW,

	//////////// VGA //////////
	output		     [7:0]		VGA_B,
	output		          		VGA_BLANK_N,
	output		          		VGA_CLK,
	output		     [7:0]		VGA_G,
	output		          		VGA_HS,
	output		     [7:0]		VGA_R,
	output		          		VGA_SYNC_N,
	output		          		VGA_VS
);



//=======================================================
//  REG/WIRE declarations
//=======================================================


reg [32:0] counter;
reg state, led, ledb;
assign LEDG[0] = state;
assign LEDR[0] = led;
assign LEDG[1] = ledb;
wire [3:0] button;
wire reset;


//=======================================================
//  Structural coding
//=======================================================

/*debounce debounce_mod(
	.clk(CLOCK_50),
   .button(),
   .button_out(reset)
);*/

ARM_Processor arm_vectorial(
		.clk(CLOCK_50),
		.reset(SW[17]),
		//.keySWInpP(button),
		.keySWInpP(0),
		.image(led),
		.VGA_B(VGA_B),
		.VGA_BLANK_N(VGA_BLANK_N),
		.VGA_CLK(VGA_CLK),
		.VGA_G(VGA_G),
		.VGA_HS(VGA_HS),
		.VGA_R(VGA_R),
		.VGA_SYNC_N(VGA_SYNC_N),
		.VGA_VS(VGA_VS),
		.ledp(LEDR[1]),
		.ledp2(LEDR[2]),
		.ledp3(LEDR[3]),
		.ledp4(LEDR[4]),
		.ledp5(LEDR[5]),
		.ledp6(LEDR[6]),
		.ledp7(LEDR[7]));

		always @ (posedge CLOCK_50) begin
		  counter <= counter + 1;
		  state <= counter[24]; // <------ data to change
		  if(SW[0])begin
			led = 1;
		  end else begin
		  led = 0;
		  end
end

endmodule
