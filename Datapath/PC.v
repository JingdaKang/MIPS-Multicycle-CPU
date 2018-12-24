module PC(clk,write_next,pc_i,pc_o);

	input   clk;
	input   write_next;
	input  [31:0] pc_i;

	output reg [31:0] pc_o;

  initial
  begin
    pc_o=32'h0000_3000;
  end
	
	always@(negedge clk)
	begin
		if(write_next)
		  begin
		  pc_o <= pc_i;
	    end
	  else
	    begin
	      pc_o<=pc_o;
	    end
	end
endmodule
	
