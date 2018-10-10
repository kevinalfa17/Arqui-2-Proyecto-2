//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: David Gomez Vargas (2015028430)
// 
// Create Date:    07:00:00 13/04/2018 
//
// Module Name:    draw_pixel
//
// Description:   This module reads pixels of the vector memory 
//						and send them to the video controller.
//
// Reference:	Own idea.
//////////////////////////////////////////////////////////////////////////////////

module draw_pixel(
		hcount, 
		vcount,
		clk,
		pixel,
		image,
		pixel_r,
		pixel_g,
		pixel_b,
		adr
);
input [9:0] hcount;
input [9:0]  vcount;
input clk;
input image;
input [8:0] pixel;
output logic[31:0] adr;
output logic[7:0] pixel_r;
output logic[7:0] pixel_g;
output logic[7:0] pixel_b;


always @(posedge clk) begin		
		if(hcount<640 && vcount <480) begin
		if(image)begin
		adr = 307210+vcount*640+hcount;
		end else begin
		adr = vcount*640+hcount;
		end
		pixel_r <= pixel[7:0];
		pixel_g <= pixel[7:0];
		pixel_b <= pixel[7:0];
	end else begin
		pixel_r <= 7'b00;
		pixel_g <= 7'h00;
		pixel_b <= 7'h00;
	end
	
end
endmodule