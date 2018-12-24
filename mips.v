`include "D:/resource/multicycle/Fragment_Define.v"
`include "D:/resource/multicycle/ALU.v"
`include "D:/resource/multicycle/BE.v"
`include "D:/resource/multicycle/DM.v"
`include "D:/resource/multicycle/IM.v"
`include "D:/resource/multicycle/Load.v"
`include "D:/resource/multicycle/PC.v"
`include "D:/resource/multicycle/RF.v"
`include "D:/resource/multicycle/PC_Jump.v"
`include "D:/resource/multicycle/WriteNext.v"
`include "D:/resource/multicycle/EXT.v"
`include "D:/resource/multicycle/flopr.v"
`include "D:/resource/multicycle/Mux.v"
`include "D:/resource/multicycle/REVERSE.v"
`include "D:/resource/multicycle/Ctrl.v"

module mips(clk,rst);
  input clk;
  input rst;
  
  //PC
  wire [31:0] pc_i;
	wire [31:0] pc_o;
	wire write_next;
	PC m_PC(.clk(clk), .write_next(write_next), .pc_i(pc_i), .pc_o(pc_o));
	
	//IM
	wire [31:0] Instruction_i;
	IM m_IM(.addr(pc_o[11:2]), .dout(Instruction_i));
	
	//IR
	wire IRWr;
	wire [31:0] Instruction_o;
	flopr m_IR(.clk(clk), .update(IRWr), .d(Instruction_i), .q(Instruction_o));
	
	//RegDst_Mux
  wire [4:0] Write_register;
	wire [1:0] RegDst;
	Mux #(5, 2) m_RegDst_Mux(.s(RegDst), .y(Write_register), .d0(Instruction_o[20:16]), .d1(Instruction_o[15:11]), .d2(5'b11111), .d3(5'b0), .d4(5'b0), .d5(5'b0), .d6(5'b0), .d7(5'b0), .d8(5'b0), .d9(5'b0), .d10(5'b0), .d11(5'b0), .d12(5'b0), .d13(5'b0), .d14(5'b0), .d15(5'b0));
	
	//RF
	wire [31:0] Write_data;
	wire [31:0] Read_data1;
	wire [31:0] Read_data2;
	wire RegWr;
	RF m_RF(.clk(clk), .RegWr(RegWr), .ra0_i(Instruction_o[25:21]), .ra1_i(Instruction_o[20:16]), .wa_i(Write_register), .wd_i(Write_data), .rd0_o(Read_data1), .rd1_o(Read_data2));
	
	//A
	wire [31:0] A_data;
	flopr m_A(.clk(clk), .update(1'b1), .d(Read_data1), .q(A_data));
	
	//B
	wire [31:0] B_data;
	flopr m_B(.clk(clk), .update(1'b1), .d(Read_data2), .q(B_data));
	
	//ALUSrcA_Mux
	wire [1:0] ALUSrcA;
	wire [31:0] src0;
	Mux #(32, 2) m_ALUSrcA_Mux(.s(ALUSrcA), .y(src0), .d0(pc_o), .d1(A_data), .d2({27'b0, Instruction_o[10:6]}), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//Sign_Extend
	wire [31:0] signExtended;
	EXT m_Sign_Extend(.EXTOp(`ArithmeticEXT), .Imm16(Instruction_o[15:0]), .Imm32(signExtended));
	
	//Logic_Extend
	wire [31:0] logicExtended;
	EXT m_Logic_Extend(.EXTOp(`LogicEXT), .Imm16(Instruction_o[15:0]), .Imm32(logicExtended));
	
	//ALUSrcB_Mux
	wire [2:0] ALUSrcB;
	wire [31:0] src1;
	Mux #(32, 3) m_ALUSrcB_Mux(.s(ALUSrcB), .y(src1), .d0(B_data), .d1(32'd4), .d2(signExtended), .d3((signExtended << 2)), .d4(logicExtended), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//ALU
	wire [5:0] ALUOp;
	wire Zero;
	wire [31:0] ALU_result;
	ALU m_ALU(.ALU_ctrl(ALUOp), .src0(src0), .src1(src1), .Zero(Zero), .ALU_result(ALU_result));
	
	//ALUOut
	wire [31:0] ALUOut_data;
	flopr m_ALUOut(.clk(clk), .update(1'b1), .d(ALU_result), .q(ALUOut_data));
	
	//BE
	wire [1:0] StoreType;
	wire [3:0] be;
	BE m_BE(.StoreType(StoreType), .ALUOut(ALUOut_data[1:0]), .be(be));
	
	//DM
	wire MemWr;
	wire [31:0] MemData;
	DM m_DM(.clk(clk), .DMWr(MemWr), .be(be), .addr(ALUOut_data[11:2]), .din(B_data), .dout(MemData));
	
	//DR
	wire [31:0] Memory_data_register_data;
	flopr m_DR(.clk(clk), .update(1'b1), .d(MemData), .q(Memory_data_register_data));
	
	//Load
	wire [2:0] LoadType;
	wire [31:0] Load_data;
	Load m_Load(.LoadType(LoadType), .ALUOut(ALUOut_data[1:0]), .MemData_i(Memory_data_register_data), .MemData_o(Load_data));
	
	//MemtoReg_Mux
	wire [1:0] MemtoReg;
	Mux #(32, 2) m_MemtoReg_Mux(.s(MemtoReg), .y(Write_data), .d0(ALUOut_data), .d1(Load_data), .d2(pc_o), .d3(32'b0), .d4(32'b0), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//Ctrl
	wire [2:0] PCSource;
	wire PCWriteCond;
	wire PCWr;
	wire Reverse;
	Ctrl m_Ctrl(.clk(clk), .rst(rst), .Op(Instruction_o[31:26]), .Funct(Instruction_o[5:0]), .Rt(Instruction_o[20:16]), .RegDst(RegDst), .RegWr(RegWr), .ALUSrcA(ALUSrcA), .ALUSrcB(ALUSrcB), .ALUOp(ALUOp), .PCSource(PCSource), .PCWriteCond(PCWriteCond), .PCWr(PCWr), .MemWr(MemWr), .MemtoReg(MemtoReg), .IRWr(IRWr), .StoreType(StoreType), .LoadType(LoadType), .Reverse(Reverse));
	
	//PC_Jump
	wire [31:0] targetPC;
	PC_Jump m_PC_Jump(.nextPC(pc_o), .target(Instruction_o[25:0]), .targetPC(targetPC));
	
	//PCSource_Mux
	Mux #(32, 3) m_PCSource_Mux(.s(PCSource), .y(pc_i), .d0(ALU_result), .d1(ALUOut_data), .d2(targetPC), .d3(32'h8000_0180), .d4(A_data), .d5(32'b0), .d6(32'b0), .d7(32'b0), .d8(32'b0), .d9(32'b0), .d10(32'b0), .d11(32'b0), .d12(32'b0), .d13(32'b0), .d14(32'b0), .d15(32'b0));
	
	//WriteNext
	WriteNext m_WriteNext(.Reverse(Reverse), .Zero(Zero), .PCWriteCond(PCWriteCond), .PCWr(PCWr), .write_next(write_next));
endmodule
	