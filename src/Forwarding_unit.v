`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:15:57 06/02/2024 
// Design Name: 
// Module Name:    Forwarding_unit 
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
module Forwarding_Unit(
    input [4:0] ID_EX_rs,     // Source register 1 from ID/EX pipeline register
    input [4:0] ID_EX_rt,     // Source register 2 from ID/EX pipeline register
    input [4:0] EX_MEM_rd,    // Destination register from EX/MEM pipeline register
    input [4:0] MEM_WB_rd,    // Destination register from MEM/WB pipeline register
    input EX_MEM_RegWrite,    // Register write flag from EX/MEM pipeline register
    input MEM_WB_RegWrite,    // Register write flag from MEM/WB pipeline register
    output reg [1:0] ForwardA, // Forwarding control signal for operand 1
    output reg [1:0] ForwardB  // Forwarding control signal for operand 2
);

always @(*) begin
    // Default values
    ForwardA = 2'b00;
    ForwardB = 2'b00;

    // Check for forwarding to operand 1 (rs)
    if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rs))
        ForwardA = 2'b10;
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rs))
        ForwardA = 2'b01;

    // Check for forwarding to operand 2 (rt)
    if (EX_MEM_RegWrite && (EX_MEM_rd != 0) && (EX_MEM_rd == ID_EX_rt))
        ForwardB = 2'b10;
    else if (MEM_WB_RegWrite && (MEM_WB_rd != 0) && (MEM_WB_rd == ID_EX_rt))
        ForwardB = 2'b01;
end

endmodule
