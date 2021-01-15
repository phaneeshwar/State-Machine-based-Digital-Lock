`timescale 1 ns / 100 ps

module fsm5state_tb;

localparam nkeys = 4;
localparam timer1 = 10;
localparam timer2 = 5;
localparam required_clk_frequency = 1;
localparam clk_frequency = 50000000;
reg [3:0] key;
reg passkey;
reg reset;
reg clk;
reg [3:0] control;
wire Z;
wire [3:0] Led;
wire [6:0] Hex0;
wire [6:0] Hex1;
wire [6:0] Hex2;
wire [6:0] Hex3;
wire [6:0] Hex4;
wire [6:0] Hex5;

fsm5state #(
  .nkeys (nkeys),
  .timer1 (timer1),
  .timer2 (timer2),
  .required_clk_frequency (required_clk_frequency),
  .clk_frequency (clk_frequency)
  ) a1 (
  
  .key (key),
  .passkey (passkey),
  .reset (reset),
  .clk (clk),
  .Z (Z),
  .Led (Led),
  .Hex0 (Hex0),
  .Hex1 (Hex1),
  .Hex2 (Hex2),
  .Hex3 (Hex3),
  .Hex4 (Hex4),
  .Hex5 (Hex5)
  );
  

localparam clockfrequency = 50_000_000;
localparam clockPeriod = (1_000_000_000.0 / clockfrequency);
localparam halfPeriod = clockPeriod / 2;

always #(halfPeriod) clk = ~clk;


initial begin

       clk = 0;
		 key = 4'b1111;
		 passkey = 0;
		 reset = 1;
			
    # 10;
		reset = 0;
		passkey = 1;
		key = 4'b1111;
		@(posedge clk);
      key = 4'b1111;

    # 30;
		reset = 0;
		passkey = 1;
		key = 4'b1110;
		@(posedge clk);
      key = 4'b1111;
		

    # 30;
		reset = 0;
		passkey = 1;
		key = 4'b1101;
		@(posedge clk);
      key = 4'b1111;
		
   
    # 30;
		reset = 0;
		passkey = 1;
		key = 4'b1011;
		@(posedge clk);
      key = 4'b1111;
		  
	# 30;
		reset = 0;
		passkey = 1;
		key = 4'b0111;
		@(posedge clk);
      key = 4'b1111;

    
    
    # 30;
		reset = 0;
		passkey = 0;
		key = 4'b1111;
		@(posedge clk);
      key = 4'b1111;

	# 30;
		reset = 0;
		passkey = 0;
		key = 4'b1110;
		@(posedge clk);
      key = 4'b1111;
		
	# 30;
		reset = 0;
		passkey = 0;
		key = 4'b1101;
		@(posedge clk);
      key = 4'b1111;
		
	# 30;
		reset = 0;
		passkey = 0;
		key = 4'b1011;
		@(posedge clk);
      key = 4'b1111;
		  
     # 30;
		reset = 0;
		passkey = 0;
		key = 4'b0111;
		@(posedge clk);
      key = 4'b1111;
		

    # 30;
		reset = 0;
		passkey = 0;
		key = 4'b1111;
		@(posedge clk);
      key = 4'b1111;
		
    $display("%b ns\tsimulation Finished",$time);
	 
end
endmodule





