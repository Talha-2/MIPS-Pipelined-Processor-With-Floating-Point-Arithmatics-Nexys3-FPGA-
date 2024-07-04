`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:36:12 06/01/2024 
// Design Name: 
// Module Name:    hazard_control 
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
module Hazard_Detection_Unit (
    input [5:0] IF_ID_RS,
    input [5:0] IF_ID_RT,
    input [5:0] ID_EX_RT,
    input ID_EX_mem_read,
    output reg PC_Write,
    output reg IF_ID_Write,
    output reg control_mux_select
);

always @(*) begin
    if (ID_EX_mem_read && ((ID_EX_RT == IF_ID_RS) || (ID_EX_RT == IF_ID_RT))) begin
        // Stall the pipeline
        PC_Write = 0;
        IF_ID_Write = 0;
        control_mux_select = 1;  // Selects the no-op control signals
    end else begin
        // No hazard detected
        PC_Write = 1;
        IF_ID_Write = 1;
        control_mux_select = 0;  // Normal operation
    end
end

endmodule

