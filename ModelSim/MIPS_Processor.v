/******************************************************************
* Description
*	This is the top-level of a MIPS processor that can execute the next set of instructions:
*		add
*		addi
*		sub
*		ori
*		or
*		bne
*		beq
*		and
*		nor
* This processor is written Verilog-HDL. Also, it is synthesizable into hardware.
* Parameter MEMORY_DEPTH configures the program memory to allocate the program to
* be execute. If the size of the program changes, thus, MEMORY_DEPTH must change.
* This processor was made for computer organization class at ITESO.
* Version:
*	1.0
* Author:
*	Dr. José Luis Pizano Escalante
* email:
*	luispizano@iteso.mx
* Date:
*	12/06/2016
******************************************************************/


module MIPS_Processor
#(
	parameter MEMORY_DEPTH = 32,
	parameter DATA_WIDTH = 32
)

(
	// Inputs
	input clk,
	input reset,
	input [7:0] PortIn,
	// Output
	output [31:0] ALUResultOut,
	output [31:0] PortOut
);
//******************************************************************/
//******************************************************************/
assign  PortOut = 0;

//******************************************************************/
//******************************************************************/
// Data types to connect modules
wire PCSrc; 
wire BranchNE_true_wire;
wire BranchEQ_true_wire;
wire BranchNE_wire;
wire BranchEQ_wire;
wire MemRead_wire;
wire MemtoReg_wire;
wire MemWrite_wire;
wire RegDst_wire;
wire NotZeroANDBrachNE;
wire ZeroANDBrachEQ;
wire ORForBranch;
wire ALUSrc_wire;
wire RegWrite_wire;
wire Zero_wire;
wire Jal_wire;
wire JR_wire;
wire [2:0] ALUOp_wire;
wire [3:0] ALUOperation_wire;
wire [4:0] WriteRegister_wire;
wire [4:0] Final_WriteRegister_wire;
wire [31:0] PC_wire;
wire [31:0] BranchedPC_wire;
wire [31:0] MUX_RFWrite_wire;
wire [31:0] RAMReadData_wire;
wire [31:0] Instruction_wire;
wire [31:0] ReadData1_wire;
wire [31:0] ReadData2_wire;
wire [31:0] InmmediateExtend_wire;
wire [31:0] ReadData2OrInmmediate_wire;
wire [31:0] ALUResult_wire;
wire [31:0] PC_4_wire;
wire [31:0] PC_8_wire;
wire [31:0] InmmediateExtendAnded_wire;
wire [31:0] PCtoBranch_wire;
wire [31:0] ShiftToBranch_wire;
wire [31:0] ShiftedBranch_wire;
wire [31:0] NewPC_wire;  
wire [31:0] FinalPC_wire; 
wire [31:0] WriteData_wire; 
wire [31:0] AbsolutePC_wire;

integer ALUStatus;


//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
Control
ControlUnit
(
	.OP(Instruction_wire[31:26]),
	.Jump(Jump_wire),
	.Jal(Jal_wire),
	.RegDst(RegDst_wire),
	.BranchNE(BranchNE_wire),
	.BranchEQ(BranchEQ_wire),
	.MemRead(MemRead_wire),
	.MemtoReg(MemtoReg_wire),
	.MemWrite(MemWrite_wire),
	.ALUOp(ALUOp_wire),
	.ALUSrc(ALUSrc_wire),
	.RegWrite(RegWrite_wire)
	
);

PC_Register
#(
	.N(32)
)
program_counter
(
	.clk(clk),
	.reset(reset),
	.NewPC(AbsolutePC_wire),
	.PCValue(PC_wire)
);

DataMemory
#(
	.DATA_WIDTH(DATA_WIDTH)
)
RAMDataMemory
(
	.WriteData(ReadData2_wire),
	.Address(ALUResult_wire),
	.clk(clk),
	.MemWrite(MemWrite_wire),
	.MemRead(MemRead_wire),
	.ReadData(RAMReadData_wire)
);


ProgramMemory
#(
	.MEMORY_DEPTH(300)
)
ROMProgramMemory
(
	.Address(PC_wire),
	.Instruction(Instruction_wire)
);

Adder32bits
PC_Plus_4
(
	.Data0(PC_wire),
	.Data1(4),
	
	.Result(PC_4_wire)
);
//****************

//******************
Adder32bits
Branch_Adder
(
	.Data0(ShiftedBranch_wire),
	.Data1(PC_4_wire),
	
	.Result(NewPC_wire)
);

//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
//******************************************************************/
ShiftLeft2 
Shift_For_Branch
(   
	.DataInput(InmmediateExtend_wire),
	.DataOutput(ShiftedBranch_wire)

);


Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForRTypeAndIType
(
	.Selector(RegDst_wire),
	.MUX_Data0(Instruction_wire[20:16]),
	.MUX_Data1(Instruction_wire[15:11]),
	
	.MUX_Output(WriteRegister_wire)

);
//*******
Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForBranch
(
	.Selector(PCSrc),
	.MUX_Data0(PC_4_wire),
	.MUX_Data1(NewPC_wire),
	
	.MUX_Output(BranchedPC_wire)

);


Multiplexer2to1
#(
	.NBits(DATA_WIDTH)
)
MUX_ForWriteDataToFR
(
	.Selector(MemtoReg_wire),
	.MUX_Data0(ALUResult_wire),
	.MUX_Data1(RAMReadData_wire),
	
	.MUX_Output(MUX_RFWrite_wire)

);

RegisterFile
Register_File
(
	.clk(clk),
	.reset(reset),
	.RegWrite(RegWrite_wire),
	.WriteRegister(Final_WriteRegister_wire),
	.ReadRegister1(Instruction_wire[25:21]),
	.ReadRegister2(Instruction_wire[20:16]),
	.WriteData(WriteData_wire),
	.ReadData1(ReadData1_wire),
	.ReadData2(ReadData2_wire)

);

SignExtend
SignExtendForConstants
(   
	.DataInput(Instruction_wire[15:0]),
   .SignExtendOutput(InmmediateExtend_wire)
);



Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForReadDataAndInmediate
(
	.Selector(ALUSrc_wire),
	.MUX_Data0(ReadData2_wire),
	.MUX_Data1(InmmediateExtend_wire),
	
	.MUX_Output(ReadData2OrInmmediate_wire)

);


ALUControl
ArithmeticLogicUnitControl
(
	.ALUOp(ALUOp_wire),
	.ALUFunction(Instruction_wire[5:0]),
	.ALUOperation(ALUOperation_wire),
	.JRsel(JR_wire)
	

);



ALU
ArithmeticLogicUnit 
(
	.ALUOperation(ALUOperation_wire),
	.A(ReadData1_wire),
	.B(ReadData2OrInmmediate_wire),
	.Zero(Zero_wire),
	.ALUResult(ALUResult_wire),
	.shamt(Instruction_wire[10:6])
);



//******************************************************************/
//******************************************************************/
//**************************J U M P*********************************/
//******************************************************************/
//******************************************************************/

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJump
(
	.Selector(Jump_wire),
	.MUX_Data0(BranchedPC_wire),
	.MUX_Data1({PC_4_wire[31:28], Instruction_wire[25:0], 2'b0}),
	
	.MUX_Output(FinalPC_wire)

);

Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJal
(
	.Selector(Jal_wire),
	.MUX_Data0(MUX_RFWrite_wire),
	.MUX_Data1(PC_4_wire),
	
	.MUX_Output(WriteData_wire)

);



Multiplexer2to1
#(
	.NBits(5)
)
MUX_ForWriteRegister
(
	.Selector(Jal_wire),
	.MUX_Data0(WriteRegister_wire),
	.MUX_Data1(5'b11111),
	
	.MUX_Output(Final_WriteRegister_wire)

);



Multiplexer2to1
#(
	.NBits(32)
)
MUX_ForJR
(
	.Selector(JR_wire),
	.MUX_Data0(FinalPC_wire),
	.MUX_Data1(ReadData1_wire),
	
	.MUX_Output(AbsolutePC_wire)

);

assign ALUResultOut = ALUResult_wire;

assign BranchNE_true_wire = BranchNE_wire & ~(Zero_wire);
assign BranchEQ_true_wire = BranchEQ_wire&Zero_wire;
assign PCSrc = BranchNE_true_wire|BranchEQ_true_wire;

endmodule

