`include "D:/resource/multicycle/mips.v"
`timescale  1ns/1ps
module mips_tb();
	reg clk, rst;
	
	mips m_mips(.clk(clk), .rst(rst));
	
	initial
		begin
		//$readmemh("code.txt", m_mips.m_IM.IMem);
		$monitor("PC = 0x%8X, IR = 0x%8X", m_mips.m_PC.pc_o, m_mips.m_IR.q);
		clk = 1;
		rst = 1;
		#5;
		rst = 0;
		#20;
		rst = 1;
		end
		
	always
		#(50) clk = ~clk;
endmodule
