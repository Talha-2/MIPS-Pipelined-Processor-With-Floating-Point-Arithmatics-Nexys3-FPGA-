`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:19:31 05/07/2024 
// Design Name: 
// Module Name:    IF_ID_Register 
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


module IF_ID_Register(clk,reset,IF_ID_Write,instruction_input ,pc_input,IF_ID_pc,IF_ID_istr);

input clk,reset,IF_ID_Write;
input [31:0]instruction_input,pc_input;
output reg [31:0]  IF_ID_pc,IF_ID_istr;


reg [63:0] IF_ID;
always@(posedge clk or posedge reset)begin
	if (reset)
        IF_ID <= 64'b0;
   else begin
	if (IF_ID_Write) begin
	IF_ID[31:0]<= pc_input;
	IF_ID[63:32]<= instruction_input;
	end
	end
end

always @(*)
begin
    IF_ID_pc <= IF_ID[31:0];
    IF_ID_istr <= IF_ID[63:32];

end

endmodule

