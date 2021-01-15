module timer1 #(
       parameter timer1 = 7    // delay
		 )(
		 input t1out,    // it is basically used as reset the counter to 0
		 input enable,   // enable signal of the clock
		 input reset,    // main reset signal
		 input clkdiv,   // clk coming from frequency divider
		 output reg t1in   // output goes high if timer reaches to a value of timer1
		 
		 );
		 
reg [3:0] counter = 0;


always @(clkdiv or reset or t1out) begin
     
	    if (reset == 1'b1 | t1out == 1'b1) begin
		    
			 counter <= 0;
			 t1in <= 0;
			 
			 
		 end
		 
		 if (enable == 1'b1 && t1out == 1'b0 && counter < timer1) begin
		
	        counter <= counter + 1;  // increment the counter value till it reaches to timer 1
			  t1in <= 0;
		 end
		
	    if (enable == 1'b1 && t1out == 1'b0 && counter == timer1) begin
		
	        t1in <= 1;  // set high output when timer expires
			  
		 end
		 
				  
end

endmodule	 

		 