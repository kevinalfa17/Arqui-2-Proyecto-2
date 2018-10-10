//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430)
// 
// Create Date:    07:00:00 13/04/2018 
//
// Module Name:    vga_controller
//
// Description:   This module is responsible to produce the control signals 
//						to synchronize the DAC, screen and the FPGA. 
//
// Reference:	This controller is the same that we used in the course CE3201,
// 				is based on Xilinx VGA Controller Tutorial.
//////////////////////////////////////////////////////////////////////////////////

module vga_controller(
	clk,
	final_pixel_r,
	final_pixel_g,
	final_pixel_b,
	hcount,
	vcount,
	vsync,
	hsync,
	VGA_R,
	VGA_G,
	VGA_B
    );
	 
	input [7:0] final_pixel_r;
	input [7:0] final_pixel_g;
	input [7:0] final_pixel_b;
	input clk;
	output	vsync;
	output	hsync;
	output [7:0] VGA_R;
	output [7:0] VGA_G;
	output [7:0] VGA_B;
	output [9:0]	hcount;
	output [9:0] 	vcount;
	reg [9:0] hcount = 0;
	reg [9:0] vcount = 0;
   reg	hblank = 0;
	reg	vblank = 0;
	reg	vs = 1;
	reg	hs = 1;
	wire	hsyncon;
	wire	hsyncoff;
	wire	hreset;
	wire	hblankon;
	wire	next_hblank;
	wire	next_vblank;
	wire [7:0] pixel_r;
	wire [7:0] pixel_g;
	wire [7:0] pixel_b;


		// horizontal: 799 pixels total
		// display 640 pixels per line
		assign hblankon = (hcount == 639);    
		assign hsyncon = (hcount == 655);
		assign hsyncoff = (hcount == 751);
		assign hreset = (hcount == 799);

		// vertical: 523 lines total
		// display 480 lines
		wire vsyncon,vsyncoff,vreset,vblankon;
		assign vblankon = hreset & (vcount == 479);    
		assign vsyncon = hreset & (vcount == 489);
		assign vsyncoff = hreset & (vcount == 491);
		assign vreset = hreset & (vcount == 524);


		// sync and blanking
		assign next_hblank = hreset ? 0 : hblankon ? 1 : hblank;
		assign next_vblank = vreset ? 0 : vblankon ? 1 : vblank;
  	
		always @(posedge clk) 
		begin
					hcount <= hreset ? 0 : hcount + 1;
					hblank <= next_hblank;
					hs <= hsyncon ? 0 : hsyncoff ? 1 : hs;  // active low
					vcount <= hreset ? (vreset ? 0 : vcount + 1) : vcount;
					vblank <= next_vblank;
					vs <= vsyncon ? 0 : vsyncoff ? 1 : vs;  // active low
	end


		assign pixel_r = final_pixel_r;
		assign pixel_g = final_pixel_g;
		assign pixel_b = final_pixel_b;
		assign VGA_R = pixel_r;
		assign VGA_G = pixel_g;
		assign VGA_B = pixel_b;
		assign vsync = ~vs;
		assign hsync = ~hs;
		
endmodule
