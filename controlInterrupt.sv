//////////////////////////////////////////////////////////////////////////////////
// Group: Grupo Maravilla 
//
// Developer: Gabriel Barboza Alvarez (2015104425)
// 
// Create Date:    01:00:00 9/04/2018 
//
// Module Name:    controlInterrupt
//
// Description:    This module is responsible for obtain an interruption of the buttons, 
//					complete the actual instructions, after that going to the code created 
//					to manage the specific interruption and returning to the interrupted 
//					instruction when this code is finished.
//
// Reference: 	   
//
//////////////////////////////////////////////////////////////////////////////////

module controlInterrupt#(parameter code = 8)(
				  input logic clock,
				  input logic [3:0] interruptSWInKey,
				  input logic [31:0] pcPrevState,

				  output logic [1:0]onInterrupt,
				  output logic [31:0] pcNextState

	);
	logic FlagInt;
	logic FlagInt2;
	logic FlagInt3;
	logic FlagInt4;
	logic [31:0] pcSaved;
	logic [3:0] interruptCode;

	initial begin
		FlagInt3 = 0;
		FlagInt4 = 0;
	end

	always @(posedge clock || (interruptSWInKey != 4'b0000) )
	begin
		if((FlagInt == 1'b1) && (FlagInt2 == 1'b0))
		begin 
			onInterrupt = 2'b01;
		end
		else if((FlagInt == 1'b1) && (FlagInt2 == 1'b1))
		begin 
			onInterrupt = 2'b11;
		end
		else if((FlagInt == 1'b0) && (FlagInt2 == 1'b1))
		begin 
			onInterrupt = 2'b10;
		end
		else if( ((interruptSWInKey != 4'b0000) && (FlagInt == 1'b0) && (FlagInt2 == 1'b0)) || ( (FlagInt3 == 1)  ) )
		begin
			if( FlagInt3 == 0 )
			begin
				interruptCode[3:0] = interruptSWInKey;
			end
			FlagInt = 1;
			FlagInt2 = 1;
			FlagInt3 = 0;

			if(FlagInt4 == 0)
			begin
				pcSaved = pcPrevState;
				FlagInt4 = 1;
			end
					
			onInterrupt = 2'b11;

			case(interruptCode)
						4'b0000:
							pcNextState = pcPrevState; // direccion para caso 
						4'b0001:
							pcNextState = (code)*4;
						4'b0010:
							pcNextState = (code + 15)*4;
						4'b0011:
							pcNextState = (code + 16)*4;
						default:
							pcNextState = 32'bx;
			endcase

		end
		else
		begin
			FlagInt = 0;
			FlagInt2 = 0;
			pcNextState = pcPrevState;
			onInterrupt = 2'b00;
		end

		if((clock == 1) && (clock == 1) )
		begin
				if( (pcPrevState == (code-1)*4) && (onInterrupt == 2'b01) )
				begin
					FlagInt = 0;
					FlagInt2 = 1;
				end
				else if( (onInterrupt == 2'b11) )
				begin 
					if(FlagInt4 == 0)
					begin
						pcSaved = pcPrevState;
						FlagInt4 = 1;
					end
					FlagInt2 = 0;
					case(interruptCode)
						4'b0000:
							pcNextState = pcPrevState; // direccion para caso 
						4'b0001:
							pcNextState = (code)*4;
						4'b0010:
							pcNextState = (code + 15)*4;
						4'b0011:
							pcNextState = (code + 16)*4;
						default:
							pcNextState = 32'bx;
					endcase
				end

				else if(onInterrupt == 2'b10)
				begin
					pcNextState = pcSaved;
					interruptCode = 0;
					FlagInt = 0;
					FlagInt2 = 0;
					FlagInt4 = 0;
				end
				else if( (onInterrupt == 2'b01) )
				begin
					case(interruptCode)
						4'b0000:
							pcNextState = pcPrevState; // direccion para caso 
						4'b0001:
							pcNextState = (code)*4;
						4'b0010:
							pcNextState = (code + 15)*4;
						4'b0011:
							pcNextState = (code + 16)*4;
						default:
							pcNextState = 32'bx;
					endcase
				end
		end
	end
endmodule

module control_interrupt_testbench;


logic clock;
logic [3:0] interruptSWInKeyWire;
logic [31:0] pcPrevStateWire = 0;

logic [1:0] onInterruptWire;
logic [31:0] pcNextStateWire;

	controlInterrupt#(8) testnterrupciones(
				  .clock(clock),
				  .interruptSWInKey(interruptSWInKeyWire),
				  .pcPrevState(pcPrevStateWire),
				  .onInterrupt(onInterruptWire),
				  .pcNextState(pcNextStateWire)

	);

initial begin
	//pcPrevStateWire <= 0; interruptSWInKeyWire <= 0; #10; pcPrevStateWire <= 4; interruptSWInKeyWire <=1; #10;
	interruptSWInKeyWire <= 0; #10; interruptSWInKeyWire <=1; #2; interruptSWInKeyWire <=0;
end

always begin
	pcPrevStateWire <= 0; #10;
	pcPrevStateWire <= 4; #10;
	pcPrevStateWire <= 8; #10;
	pcPrevStateWire <= 12; #10;
end

always begin
	clock <= 1; #5; clock <= 0; #5;
end

endmodule