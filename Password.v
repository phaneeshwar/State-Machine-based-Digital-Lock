module Password #(
    parameter nkeys = 4 // we can define any length Password sequence
    ) (

    input [3:0] key, // input push button
	 input enable1,   // this signal would enable the module
	 input reset,     // reset the process
	 input clk,       // internal clock input
	 output reg [(nkeys*2)-1:0] ulseq,  // to output the stored sequence fsm module
	 output reg [3:0] Led,      // to display the button pressed
	 output reg [6:0] Hex0, Hex1, Hex2 // to display the output string
	 );


reg [7:0] counter;  // used to count upto nkeys

reg [3:0] keyprev;  // to check the previous state of the key

reg [10:0] width;   // used for storing bits in pb reg

reg [(nkeys*2)-1:0] pb; // it needs to store 2 bits data into the register for every press in button 

reg [6:0] hex0,hex1,hex2;  // to display the output string

reg [3:0] led; 

parameter key0 = 4'b1110, key1 = 4'b1101, key2 = 4'b1011, key3 = 4'b0111;

parameter initialize = 2'b00,idlestate = 2'b01, checkstate = 2'b10;

reg [1:0] state, next;

always @(posedge clk) begin
       if (reset == 1'b1) state <= initialize;
		 if (enable1 == 1'b0) state <= idlestate;
		 else state <= next;
end

always @(posedge clk) begin
       case(state) 
		 
		 initialize : begin                    // begins with initialize state                 
		              
						  next <= idlestate;       // transit to idlestate
		 end 
		 
		 idlestate : begin
		 
		             if (keyprev != 4'b1111 && key [3:0] == 4'b1111) next <= idlestate;
						                        
						 if ((key [3:0] == key0 || key [3:0] == key1 || key [3:0] == key2 || key [3:0] == key3) && keyprev == 4'b1111) next <= checkstate;
						  // transit for every push of the button   
		 end
		 
		 checkstate : begin    // respective state transition after execution of instruction
		             if (counter == nkeys) next <= idlestate;
						 if (counter < nkeys && key [3:0] == key0 && keyprev == 4'b1111) next <= checkstate;
		             if (counter < nkeys && key [3:0] == key1 && keyprev == 4'b1111) next <= checkstate;
		             if (counter < nkeys && key [3:0] == key2 && keyprev == 4'b1111) next <= checkstate;
		             if (counter < nkeys && key [3:0] == key3 && keyprev == 4'b1111) next <= checkstate;
		             if (key [3:0] == 4'b1111) next <= idlestate;
		 end
		 
		 default: begin 
		        state <= initialize; // default state
		 end
		 endcase
end

always @(*) begin
       if (reset == 1'b1) begin    // initializes all the regs when reset signal goes high
		    
			 
			 led <= 4'd0;
			 counter <= 0;
			 hex0 <= 0;
			 hex1 <= 15;
			 hex2 <= 15;
			 width <= 1;
			 pb <= 0;
			 keyprev <= 4'b1111;
			 
	    end
		 
else begin
  
       case(state)
		 
		 initialize: begin                   // at the begining of the state execute all the instructions
		 
		             led <= 4'd0;
			          counter <= 0;
			          hex0 <= 0;
			          hex1 <= 15;
			          hex2 <= 15;
			          width <= 1;
						 keyprev <= 4'b1111;
			          pb <= 0;
		 end
		 
		 idlestate : begin
		        
				       if (keyprev != 4'b1111 ) begin     // to update the state of the push button
						     keyprev <= 4'b1111;
							  
						 end
                   
						 if ((key [3:0] == key0 || key [3:0] == key1 || key [3:0] == key2 || key [3:0] == key3) && keyprev == 4'b1111) begin
						  // for any key press ,change of state   
							  led <= counter;
							  hex0 <= counter;

						 end
						 
		 end
		 
		 checkstate : begin
	  
	              if (counter == nkeys) begin    // if counter = nkeys then display set on hex led and output the whole sequence to Fsm module
		                led <= counter;
					       hex0 <= 5;
					       hex1 <= 6;
					       hex2 <= 7;
							 ulseq[(nkeys*2)-1:0] <= pb [(nkeys*2)-1:0];
		            end  

		           if (counter < nkeys && key [3:0] == key0 && keyprev == 4'b1111) begin
		     
			             pb[width -:1] <= 2'b00;   // store 2'b00 when key zero is pressed
			             width <= width + 2;       // increment the bits, ex pb[1:0] = 2'b00, next process pb[3:2] = 2'b01. In this way each key is assigned 
			             counter <= counter + 1;   // to one set of bits,   // to increment counter value to check if it has reached the maximum length of sequenc
			             led <= counter;           
			             hex0 <= counter;         
			             keyprev <= key0;  
		 
		           end
		    // Similarly like above steps, i have defined for other keys
		 		 
		           if (counter < nkeys && key [3:0] == key1 && keyprev == 4'b1111) begin
		     
			             pb[width -:1] <= 2'b01; // store 2'b01 when key 1 is pressed
			             width <= width + 2;  
			             counter <= counter + 1; 
							 led <= counter;
			             hex0 <= counter;
			             keyprev <= key1; 
		 
		           end
		 
		          if (counter < nkeys && key [3:0] == key2 && keyprev == 4'b1111) begin
		     
			            
			            pb[width -:1] <= 2'b10; // store 2'b10 when key 1 is pressed
			            width <= width + 2;  
			            counter <= counter + 1; 
							led <= counter;
			            hex0 <= counter;
			            keyprev <= key2;  
		 
		           end
		 
		          if (counter < nkeys && key [3:0] == key3 && keyprev == 4'b1111) begin
		     
			            pb[width -:1] <= 2'b11; // store 2'b11 when key 1 is pressed
			            width <= width + 2;  
			            counter <= counter + 1; 
							led <= counter;
			            hex0 <= counter;
			            keyprev <= key3;
		          end
		 
		          if (key [3:0] == 4'b1111) begin
					      led <= counter;
							hex0 <= counter;
					 end
					 
			end
			
			default: begin 
		        state <= initialize;
			end
			
		 endcase
		 
end

Hex0 <= hex0;
Hex1 <= hex1;
Hex2 <= hex2;
Led  = led;
end		 
 
endmodule 