module  fsm #(
     parameter nkeys = 4   // we can define any length Password sequence
	  )(
	   input [3:0] key, // input push button
	   input	reset,   // reset the process
		input t2in,    // input from timer block, specifically for error block, to display error for 5 secs
		input t1in,    // input from timer block, specifically for wait block
		input enable0,  // enable input of this module
		input clk,      // clock
		input [(nkeys*2)-1:0] ulseq,  // input password sequence coming from password module
		output reg t2out,         // to reset the timer clock
		output reg t1out,         // to reset the timer clock
		output reg enableclk1,    // enable input for timer 
		output reg enableclk2,    // enable input for timer 
		output reg Z,        //output goes high when sequence is right
		output reg [3:0] Led,   // to display the button pressed
		output reg [6:0] hex0,hex1,hex2,hex3,hex4,hex5 // to display the output string
		);
		
localparam initialize = 3'b000, start = 3'b001, button = 3'b010, error = 3'b011, wait1 = 3'b100;

localparam key0 = 4'b1110, key1 = 4'b1101, key2 = 4'b1011, key3 = 4'b0111;

reg [3:0] state, next;

reg [nkeys:0] counter; // used to count upto nkeys

reg [3:0] keyprev; // to check the previous state of the key

reg [(nkeys*2)-1:0] seq; // it needs to store 2 bits data into the register for every press in button 

reg unl; // used to change the display, like UNlock or lock, everytime when user type correct sequence

reg z;

reg [3:0] led;

reg [(nkeys*2)-1:0] width; // used for storing bits in seq reg
	  
reg [3:0] h0,h1,h2,h3,h4,h5; // to display the output string

always @(posedge clk) begin   // Next State logic
 
       if (reset == 1'b1 | enable0 == 1'b0) state <= initialize;   // goes to initialize state
		
	    else state <= next;   // update the states
end

always @(posedge clk) begin    // designed the whole logic as combinational block,  State Memory

        case(state)
		       
				 initialize: begin
				       next = start;   
				 end
				 
		       start: begin
				
			           	if ( (key[3:0] == key0 || key[3:0] == key1 || key[3:0] == key2 || key[3:0] == key3) && keyprev == 4'b1111) next = button;
							else     next <= start;
	          end
				 
				 button: begin
				  
				        if(key [3:0] == key0 && keyprev == 4'b1111 && counter < nkeys)         next <= button;
	                 if(key [3:0] == key1 && keyprev == 4'b1111 && counter < nkeys)         next <= button;
						  if(key [3:0] == key2 && keyprev == 4'b1111 && counter < nkeys)         next <= button;
						  if(key [3:0] == key3 && keyprev == 4'b1111 && counter < nkeys)         next <= button;
						  if (counter == nkeys && ulseq == seq && key [3:0] == 4'b1111)          next <= start;
						  if ((counter == nkeys) && (ulseq != seq) && key [3:0] == 4'b1111)      next <= error;
	                 if (key [3:0] == 4'b1111 && counter < nkeys)                           next <= wait1;
	          end
				 
				 wait1: begin
				 
				        if ((key[3:0] == key0  || key[3:0] == key1  || key[3:0] == key2  || key[3:0] == key3 ) && keyprev == 4'b1111) next <= button;
	                 if (t1in == 1'b1)                               next <= error;
						  if (keyprev != 4'b1111 && key [3:0] == 4'b1111) next <= wait1;
						  else                                            next <= wait1;
						  
				 end
				 
				 error: begin
				 
				        if (t2in == 1'b1) next <= start;
						  else              next <= error;
						  
				 end
				 
				 			 
				 default : next <= initialize;
				 
				 endcase
end

always @(*) begin       // Output Logic , Sequential block using non-blocking statements

if (reset == 1'b1 | enable0 == 1'b0) begin
    z <= 1'b0;
	 width <= 1;
	 counter <= 0;
	 led <= 0;
	 enableclk2 <= 1'b0;
    enableclk1 <= 1'b0;
	 h0 <= 15;
	 h1 <= 15;
	 h2 <= 15;
	 h3 <= 15;
	 h4 <= 15;
	 h5 <= 15;
	 unl <= 0;
	 seq <= 0;
end

else begin 

     case(state)
	        
			 initialize: begin             // initialize all the variables
			        z <= 1'b0;
	              width <= 1;
	              counter <= 0;
	              led <= 0;
	              enableclk2 <= 1'b0;
                 enableclk1 <= 1'b0;
	              h0 <= 15;
	              h1 <= 15;
	              h2 <= 15;
	              h3 <= 15;
	              h4 <= 15;
	              h5 <= 15;
	              unl <= 0;
	              keyprev <= 4'b1111;
					  seq <= 0;
		    end	
			  
		    start: begin
			 
			      if ((key[3:0] == key0 || key[3:0] == key1 || key[3:0] == key2 || key[3:0] == key3) && keyprev == 4'b1111) begin
						z <= 1'b0;
						enableclk1 <= 1'b1;
					end
					
					if(unl == 1'b0) begin    // to display unlock
					  
						counter <= 0;
						keyprev <= 4'b1111;
						led <= 4'b1111;
						width <= 1; 
						h0 <= 8;
						h1 <= 9;
						h2 <= 10;
						h3 <= 11;
						h4 <= 12;
						h5 <= 13;
					end
					
					if(unl == 1'b1) begin  // to display lock
					  
						counter <= 0;
						led <= 4'b1111;
						keyprev <= 4'b1111;
						width <= 1; 
						h0 <= 8;
						h1 <= 9;
						h2 <= 10;
						h3 <= 11;
						h4 <= 15;
						h5 <= 15;
				  end
					 				 
	      end
			
			button: begin
				  
				        if(key [3:0] == key0 && keyprev == 4'b1111 && counter < nkeys) begin
						     
							  
							  seq [width -:1] <= 2'b00;
							  width <= width + 2;
							  counter <= counter + 1;
							  led <= 4'b0001;
							  keyprev <= key0;
						  
						  end
						  
	                 if(key [3:0] == key1 && keyprev == 4'b1111 && counter < nkeys) begin
						     
							  keyprev <= key1;
							  seq [width -:1] <= 2'b01;
							  width <= width + 2;
							  counter <= counter + 1;
							  led <= 4'b0010;
							  
							  
						  end
						  
						  if(key [3:0] == key2 && keyprev == 4'b1111 && counter < nkeys) begin
						     
							  keyprev <= key2;
							  seq [width -:1] <= 2'b10;
							  width <= width + 2;
							  counter <= counter + 1;
							  led <= 4'b0011;
							  
								
						  end
						  
						  if(key [3:0] == key3 && keyprev == 4'b1111 && counter < nkeys) begin
						     
							  keyprev <= key3; 
							  seq [width -:1] <= 2'b11;
							  width <= width + 2;
							  counter <= counter + 1;
							  led <= 4'b0100;
							  
							   	
								
						  end
						  
						  if (counter == nkeys && ulseq == seq ) begin // to check if the sequence is right display either lock or unlock
						                             // && key [3:0] == 4'b1111
							  unl <= ~unl;
							  enableclk2 <= 1'b0;
							  enableclk1 <= 1'b0;
							  z <= 1'b1;
							  
						  end
						  
						  if ((counter == nkeys) && (ulseq != seq) ) begin // to check if the sequence is wrong ,go to erro state
						    
							  enableclk2 <= 1'b1;
							  
						  end
						  
						  if (key [3:0] == 4'b1111 && counter < nkeys) begin
						      z <= 1'b0;
						  end 
	                 
	          end
				
			wait1: begin
				 
				        if ((key[3:0] == key0  || key[3:0] == key1  || key[3:0] == key2  || key[3:0] == key3 ) && keyprev == 4'b1111) begin
						     t1out <= 1'b1;  // reset the timer
						  end
						  
	                 if (t1in == 1'b1) begin   // if timer expiers then go to error state
						     enableclk1 <= 1'b0;
							  enableclk2 <= 1'b1;
						  end
						  
						  if (keyprev != 4'b1111 && key [3:0] == 4'b1111) begin  
						      keyprev = 4'b1111;
						  end 
						  
						  else begin
						     t1out <= 1'b0;  
						  end						  
						  
			 end
				 
		  error: begin
				 
				        if (t2in == 1'b1) begin   // wait till the timer expires till 5 sec, then ges to start state
						  
						     enableclk2 <= 1'b0;
							  enableclk1 <= 1'b0;
						  
						  end
						  
						  else begin              // display error
						  
						     t2out <= 1'b0;
							  z <= 1'b0;
							  led <= 4'b1111;
							  h0 <= 14;
						     h1 <= 10;
						     h2 <= 14;
						     h3 <= 14;
						     h4 <= 6;
						     h5 <= 15;
							  keyprev <= 4'b1111;
							  
						  end
						  
				 end
				 
				 default : next <= initialize;
				 
endcase
end	

hex0 <= h0;
hex1 <= h1;
hex2 <= h2;
hex3 <= h3;
hex4 <= h4;
hex5 <= h5;
Led <= led;
Z <= z;

end

endmodule

				 
			