`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:26:29 06/02/2024
// Design Name:   EX_MEM_Register
// Module Name:   D:/NUST/SEMESTER-4/CSA LAB/Xilinx Directory/Processor/Pipelined_Processor/TB_EX_MEM.v
// Project Name:  Pipelined_Processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: EX_MEM_Register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_EX_MEM;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] branch_address;
	reg [31:0] alu_result;
	reg [31:0] read_data_2;
	reg [4:0] write_address;
	reg zero_flag;
	reg [1:0] ID_EX_WB;
	reg [2:3] ID_EX_M;

	// Outputs
	wire [1:0] EX_MEM_WB;
	wire [2:0] EX_MEM_M;
	wire [31:0] EX_MEM_branch_address;
	wire [31:0] EX_MEM_alu_result;
	wire [31:0] EX_MEM_read_data_2;
	wire [4:0] EX_MEM_write_address;
	wire EX_MEM_zero_flag;

	// Instantiate the Unit Under Test (UUT)
	EX_MEM_Register uut (
		.clk(clk), 
		.reset(reset), 
		.branch_address(branch_address), 
		.alu_result(alu_result), 
		.read_data_2(read_data_2), 
		.write_address(write_address), 
		.zero_flag(zero_flag), 
		.ID_EX_WB(ID_EX_WB), 
		.ID_EX_M(ID_EX_M), 
		.EX_MEM_WB(EX_MEM_WB), 
		.EX_MEM_M(EX_MEM_M), 
		.EX_MEM_branch_address(EX_MEM_branch_address), 
		.EX_MEM_alu_result(EX_MEM_alu_result), 
		.EX_MEM_read_data_2(EX_MEM_read_data_2), 
		.EX_MEM_write_address(EX_MEM_write_address), 
		.EX_MEM_zero_flag(EX_MEM_zero_flag)
	);

	initial begin
		// Initialize Inputs
		clk = 1;
		reset = 0;
		branch_address = 0;
		alu_result = 0;
		read_data_2 = 0;
		write_address = 0;
		zero_flag = 0;
		ID_EX_WB = 0;
		ID_EX_M = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

