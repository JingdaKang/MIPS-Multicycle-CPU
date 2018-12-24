module IM(addr, dout);
  parameter AddrWidth=10;
  input [AddrWidth+2-1:2] addr;
  
  output [31:0] dout;
  
  reg [31:0] IMem[1023:0];
  
  integer i,fp,count,reger;
  
  initial
  begin
    for(i=0;i<1024;i=i+1)
      IMem[i]=0;
    fp = $fopen("D:/resource/multicycle/code.txt", "r");
		i = 0;
		while(!$feof(fp))
			begin
			count = $fscanf(fp, "%h", reger);
			if(count == 1)
				begin
				IMem[i] = reger;
				$display("%x %x", i, reger);
				i = i + 1;
				end
			end
		$fclose(fp);		
		$display("=================================================================");
		
  end
  
  assign dout=IMem[addr];
endmodule
