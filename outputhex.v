module outputhex (
      input [6:0] hex00,hex01,hex02,
		input [6:0] hex10,hex11,hex12,hex13,hex14,hex15,
		input [3:0] led0,led1,
		input password,
		input clk,
		output reg [3:0] Led,
		output reg [6:0] Hex0,Hex1,Hex2,Hex3,Hex4,Hex5
		);
		
localparam empty = 15;

function [6:0] display;   // display function is used to convert the decimal input to required Bcd value

input [3:0] disp;

case (disp)
   
	 4'd0: display = 7'b1000000; // 0
    4'd1: display = 7'b1111001; // 1
	 4'd2: display = 7'b0100100; // 2
	 4'd3: display = 7'b0110000; // 3
	 4'd4: display = 7'b0011001; // 4
	 4'd5: display = 7'b0000111; // T
	 4'd6: display = 7'b0000111; // E
	 4'd7: display = 7'b0010010; // S
	 4'd8: display = 7'b0001001; // K
	 4'd9: display = 7'b0100111; // C
	 4'd10:display = 7'b0100011; // O
	 4'd11:display = 7'b1000111; // L
	 4'd12:display = 7'b0101011; // N
	 4'd13:display = 7'b1000001; // U
	 4'd14:display = 7'b0101111; // R
	 4'd15:display = 7'b1111111; // Empty
	
    default: display = 7'bx;
	
endcase

endfunction	


always @(posedge clk) begin
  
       
		if (password == 1'b0) begin   // if password switch is low connect outputlines to fsm module
		
		    Hex0 <= display(hex10);
			 Hex1 <= display(hex11);
			 Hex2 <= display(hex12);
			 Hex3 <= display(hex13);
			 Hex4 <= display(hex14);
			 Hex5 <= display(hex15);
			 Led  <= led1;
		end
		
		if (password == 1'b1) begin  // if password switch is high connect outputlines to password module
		    
			 Hex0 <= display(hex00);
			 Hex1 <= display(hex01);
			 Hex2 <= display(hex02);
			 Hex3 <= display(empty);
			 Hex4 <= display(empty);
			 Hex5 <= display(empty);
			 Led  <= led0;
		end
		
end

endmodule    