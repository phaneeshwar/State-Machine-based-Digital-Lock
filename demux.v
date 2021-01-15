module dmux (
  
     input passkey,
	  output wire enable0,
	  output wire enable1
	  );

reg s0 = 1'b1;
assign enable0 = s0 & (~passkey);
assign enable1 = s0 & (passkey);	  

endmodule
	  
	  