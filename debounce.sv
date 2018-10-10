module debounce(
    input logic clk,
    input logic button,
    output logic button_out
    );
	 
	logic reset = 1;

	logic st_next = 0;
	logic st_prev = 0;
	logic [19:0] counter = 0;
		
	always @(posedge clk)
	begin
		if(reset) begin
			button_out = 0;
			reset = 0;
		end
		counter = counter + 1;
		st_prev = st_next;
		st_next = button;
		if(counter == 75)
			begin
				counter = 0;
				button_out = st_next & st_prev;
			end
	end
endmodule