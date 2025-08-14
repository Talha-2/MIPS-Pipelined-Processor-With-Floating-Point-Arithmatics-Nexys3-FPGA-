`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   16:13:15 05/18/2024
// Design Name:   ID_EX_Register
// Module Name:   D:/NUST/SEMESTER-4/CSA LAB/Xilinx Directory/Processor/Pipelined_Processor/TB_ID_EX.v
// Project Name:  Pipelined_Processor
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ID_EX_Register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_ID_EX;

	// Inputs
	reg clk;
	reg reset;
	reg [31:0] pc_input;
	reg [31:0] read_data_1;
	reg [31:0] read_data_2;
	reg [31:0] sign_ext_const;
	reg [4:0] write_address;
	reg [0:1] WB;
	reg [0:2] M;
	reg [0:1] EX;

	// Outputs
	wire [166:0] ID_EX;

	// Instantiate the Unit Under Test (UUT)
	ID_EX_Register uut (
		.clk(clk), 
		.reset(reset), 
		.pc_input(pc_input), 
		.read_data_1(read_data_1), 
		.read_data_2(read_data_2), 
		.sign_ext_const(sign_ext_const), 
		.write_address(write_address), 
		.ID_EX(ID_EX), 
		.WB(WB), 
		.M(M), 
		.EX(EX)
	);
	always #100 clk=~clk;

	initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		pc_input = 0;
		read_data_1 = 0;
		read_data_2 = 0;
		sign_ext_const = 0;
		write_address = 0;
		WB = 0;
		M = 0;
		EX = 0;

		// Wait 100 ns for global reset to finish
		#100;
		
		pc_input = 0;
		read_data_1 = 20;
		read_data_2 = 50;
		sign_ext_const = 60;
		write_address = 30;
		WB = 10;
		M = 111;
		EX = 00;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here

	end
      
endmodule

