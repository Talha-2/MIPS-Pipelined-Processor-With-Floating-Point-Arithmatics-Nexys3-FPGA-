`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:26:50 05/07/2024 
// Design Name: 
// Module Name:    ID_EX_Register 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module ID_EX_Register (
    input clk,
    input reset,
    input [31:0] pc_input,
    input [31:0] read_data_1,
    input [31:0] read_data_2,
    input [31:0] sign_ext_const,
    input [5:0] instruction_nibble_1,
    input [5:0] instruction_nibble_2,
    input [5:0] IF_ID_rs,
    input [5:0] IF_ID_rt,
    input [1:0] WB,
    input [2:0] M,
    input [3:0] EX,
	 input fp_istr_check,
	 
    output reg [1:0] ID_EX_WB,
    output reg [2:0] ID_EX_M,
    output reg [3:0] ID_EX_EX,
    output reg [31:0] ID_EX_pc,
    output reg [31:0] ID_EX_read_data_1,
    output reg [31:0] ID_EX_read_data_2,
    output reg [31:0] ID_EX_sign_ext_const,
    output reg [5:0] ID_EX_instruction_nibble_1,
    output reg [5:0] ID_EX_instruction_nibble_2,
    output reg [5:0] ID_EX_rs,
    output reg [5:0] ID_EX_rt,
	 output reg ID_EX_fp_istr_check
);

reg [161:0] ID_EX;

always @(posedge clk or posedge reset) begin
    if (reset)
        ID_EX <= 162'b0;
    else begin
        ID_EX[1:0] <= WB;
        ID_EX[4:2] <= M;
        ID_EX[8:5] <= EX;
        ID_EX[40:9] <= pc_input;
        ID_EX[72:41] <= read_data_1;
        ID_EX[104:73] <= read_data_2;
        ID_EX[136:105] <= sign_ext_const;
        ID_EX[142:137] <= instruction_nibble_1;
        ID_EX[148:143] <= instruction_nibble_2;
        ID_EX[154:149] <= IF_ID_rs;
        ID_EX[160:155] <= IF_ID_rt;
		  ID_EX[161]<=fp_istr_check;
    end
end

always @(*) begin
    ID_EX_WB = ID_EX[1:0];
    ID_EX_M = ID_EX[4:2];
    ID_EX_EX = ID_EX[8:5];
    ID_EX_pc = ID_EX[40:9];
    ID_EX_read_data_1 = ID_EX[72:41];
    ID_EX_read_data_2 = ID_EX[104:73];
    ID_EX_sign_ext_const = ID_EX[136:105];
    ID_EX_instruction_nibble_1 = ID_EX[142:137];
    ID_EX_instruction_nibble_2 = ID_EX[148:143];
    ID_EX_rs = ID_EX[154:149];
    ID_EX_rt = ID_EX[160:155];
	 ID_EX_fp_istr_check= ID_EX[161];
end

endmodule
