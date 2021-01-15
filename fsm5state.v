module fsm5state #(
    parameter nkeys = 4, // we can define any length Password sequence
	 parameter timer1 = 10, // to set clock, when the user doesnot enter the key for certain duration
	 parameter timer2 = 10, // to set clock when the state machine in FSM module, is in error state
	 parameter required_clk_frequency = 1,  // to set frequency of 1 hz
	 parameter clk_frequency = 50000000 // Input clock frequency
	      )(
	 input [3:0] key,  // input push button
	 input passkey,   // to control between password module and fsm module
	 input reset,    // reset the process
	 input clk,      // internal clock input
	 output wire Z,    //output goes high when sequence is right
	 output wire [3:0] Led,  // to display the button pressed
	 output wire [6:0] Hex0,Hex1,Hex2,Hex3,Hex4,Hex5 // to display the output string
	 );
	 
localparam req_clk_freq = 4;
wire clkdiv_t1;
wire enable0,enable1;
wire t1out,t1in,t2out,t2in;
wire enableclk1, enableclk2;
wire [(nkeys*2)-1:0] ulseq;
wire [6:0] h10,h11,h12,h13,h14,h15,h00,h01,h02,h03,h04,h05;
wire [3:0] led0,led1;

// Respective connections are made for other modules

dmux a1 (
    .passkey (passkey),
	 .enable0 (enable0),
	 .enable1 (enable1)
	 );
	 
frequencydivider #(
        .required_clk_frequency (required_clk_frequency) ,
		  .clk_frequency (clk_frequency)
		  ) t1 (
		   .clk (clk),
			.clkdiv (clkdiv_t1)
);



timer1 #(
          .timer1 (timer1)
		 ) a7(
		 .t1out (t1out) ,
		 .enable (enableclk1),
		 .reset (reset),
		 .clkdiv (clkdiv_t1),
		 .t1in (t1in)
		 
		 );
		 
timer1 #(
          .timer1 (timer2)
		 ) a8(
		 .t1out (t2out) ,
		 .enable (enableclk2),
		 .reset (reset),
		 .clkdiv (clkdiv_t1),
		 .t1in (t2in)
		 
		 );

outputhex a2 (
      .hex00 (h00),
		.hex01 (h01),
		.hex02 (h02),
		.hex10 (h10),
		.hex11 (h11),
		.hex12 (h12),
		.hex13 (h13),
		.hex14 (h14),
		.hex15 (h15),
		.led0 (led0),
		.led1 (led1),
		.password (passkey),
		.clk (clk),
		.Led (Led),
		.Hex0 (Hex0),
		.Hex1 (Hex1),
		.Hex2 (Hex2),
		.Hex3 (Hex3),
		.Hex4 (Hex4),
		.Hex5 (Hex5)
		);
	
Password #(
    .nkeys (nkeys)
    ) a3 (

    .key (key),
	 .enable1 (enable1),
	 .reset (reset),
	 .clk (clk),
	 .ulseq (ulseq),
	 .Led (led0),
	 .Hex0 (h00), 
	 .Hex1 (h01),
	 .Hex2 (h02)
	 );


fsm #(
       .nkeys (nkeys)
	 ) f1 (
	 .key (key),
	 .enable0 (enable0),
	 .reset (reset),
	 .t1in (t1in),
	 .t2in (t2in),
	 .clk (clk),
	 .ulseq (ulseq),
	 .t1out (t1out),
	 .t2out (t2out),
	 .enableclk1 (enableclk1),
	 .enableclk2 (enableclk2),
	 .Z(Z),
	 .Led(led1),
	 .hex0 (h10),
	 .hex1 (h11),
	 .hex2 (h12),
	 .hex3 (h13),
	 .hex4 (h14),
	 .hex5 (h15)
	 );

		

endmodule



