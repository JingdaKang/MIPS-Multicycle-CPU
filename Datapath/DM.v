`include "D:/resource/multicycle/DEBUG_Define.v"
`timescale 1ns/1ps

module DM(clk,DMWr,be,addr,din,dout);
  parameter AddrWidth=10;
  
  input clk;
  input DMWr;
  input [3:0] be;
  input [AddrWidth+2-1:2] addr;
  input [31:0] din;
  
  output [31:0] dout;
  reg [31:0] DMem[1023:0];
  integer i;
  
  initial
  begin
    for(i=0;i<1024;i=i+1)
    DMem[i]<=0;
  end
  
  assign dout=DMem[addr];
  
  always@(negedge clk)
  begin
    if(DMWr)
      begin
        case(be)
          4'b1111:
          begin
            DMem[addr]<=din;
          end
          4'b1100:
          begin
            DMem[addr][31:16]<=din[15:0];
          end
          4'b0011:
          begin
            DMem[addr][15:0]<=din[15:0];
          end
          4'b1000:
          begin
            DMem[addr][31:24]<=din[7:0];
          end
          4'b0100:
          begin
            DMem[addr][23:16]<=din[7:0];
          end
          4'b0010:
          begin
            DMem[addr][15:8]<=din[7:0];
          end
          4'b0001:
          begin
            DMem[addr][7:0]<=din[7:0];
          end
        endcase
      `ifdef DM_DEBUG
			#20 $display("DMem  %x  %x", (addr << 2), DMem[addr]);
			`endif
			end
		end
endmodule

