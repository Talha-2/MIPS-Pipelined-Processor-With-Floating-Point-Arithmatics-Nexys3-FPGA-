`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:42:00 05/15/2024
// Design Name:   Control_unit
// Module Name:   D:/NUST/SEMESTER-4/CSA LAB/Xilinx Directory/Processor/Pipelined_Processor/TB_CU.v
// Project Name:  Pipelined_Processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: Control_unit
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_CU;

	// Inputs
	reg clk;
	reg [5:0] instruction_nibble;

	// Outputs
	wire reg_dst;
	wire branch;
	wire mem_read;
	wire mem_to_reg;
	wire alu_src;
	wire reg_write;
	wire mem_write;
	wire [1:0] alu_op;
	wire jump;
	wire pc_src;
	wire [0:1] WB;
	wire [0:2] M;
	wire [0:1] EX;
	wire [1:0] EX_alu_op;

	// Instantiate the Unit Under Test (UUT)
	Control_unit uut (
		.clk(clk), 
		.instruction_nibble(instruction_nibble), 
		.reg_dst(reg_dst), 
		.branch(branch), 
		.mem_read(mem_read), 
		.mem_to_reg(mem_to_reg), 
		.alu_src(alu_src), 
		.reg_write(reg_write), 
		.mem_write(mem_write), 
		.alu_op(alu_op), 
		.jump(jump), 
		.pc_src(pc_src), 
		.WB(WB), 
		.M(M), 
		.EX(EX), 
		.EX_alu_op(EX_alu_op)
	);
	
	always #100 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		instruction_nibble = 6'd0;

		// Wait 100 ns for global reset to finish
		#100;
		instruction_nibble = 6'd8;

        
		// Add stimulus here

	end
      
endmodule

