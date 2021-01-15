module frequencydivider #(
        parameter required_clk_frequency = 1,
		  parameter clk_frequency = 50000000
		  )(     
		   input clk,  // input clock
			output reg clkdiv  // outptut the required frequency
			);
			
localparam integer clkcycle = clk_frequency / required_clk_frequency; // calculate number of clock cycles required 
reg[10:0] counter = 0;

always @(posedge clk) begin
       
		 if (counter < (clkcycle / 2)) begin // set high for first half of the calculated value
           counter <= counter + 1;
		     clkdiv <= 1;
		  end
		 
		 
		 if (counter >= (clkcycle / 2) && counter < clkcycle) begin    // set low for next half of the calculated value, to obtain required frequency
			      counter <= counter + 1;
					clkdiv <= 0;
		 end
		 
		 else begin
		      counter <= 0;
		 end
		 
end
endmodule			

