module RF(clk, RegWr, ra0_i,ra1_i,wa_i,wd_i, rd0_o,rd1_o);
	input clk;
	input RegWr;
	input [4:0] ra0_i,ra1_i,wa_i;
	input [31:0] wd_i;
	
	output [31:0] rd0_o,rd1_o;
	
	integer i;
	reg [31:0] regs[31:0];
	
	initial
	     begin
	       for(i=0;i<=31;i=i+1)
	           regs[i]<=0;
	       regs[28]<=32'h00001800;
		     regs[29]<=32'h00002ffe;
	     end
	     
	assign rd0_o=regs[ra0_i];
	assign rd1_o=regs[ra1_i];
	
	
	always@(negedge clk)
	begin
		if(RegWr)
		  begin
		   regs[wa_i] <= (wa_i!=5'd0)?wd_i:32'd0;
			 `ifdef RF_DEBUG
       $display("R[00-07]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", 0, regs[1], regs[2], regs[3], regs[4], regs[5], regs[6], regs[7]);
       $display("R[08-15]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", regs[8], regs[9], regs[10], regs[11], regs[12], regs[13], regs[14], regs[15]);
       $display("R[16-23]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", regs[16], regs[17], regs[18], regs[19], regs[20], regs[21], regs[22], regs[23]);
       $display("R[24-31]=%8X, %8X, %8X, %8X, %8X, %8X, %8X, %8X", regs[24], regs[25], regs[26], regs[27], regs[28], regs[29], regs[30], regs[31]);
       `endif
     end

	end

endmodule