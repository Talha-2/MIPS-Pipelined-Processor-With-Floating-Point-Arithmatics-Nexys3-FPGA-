`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:43:59 06/02/2024 
// Design Name: 
// Module Name:    FP_CO_PROC 
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
module FP_CO_PROC(
    );




endmodule


module FP_ALU(
    input [31:0] operand_1,
    input [31:0] operand_2,
    input operation, // 0 for addition, 1 for subtraction
    output reg [31:0] result
);

reg [7:0] exponent_1, exponent_2, exponent_diff;
reg [23:0] mantissa_1, mantissa_2;
reg [24:0] mantissa_result;
reg [23:0] shifted_mantissa;
reg sign_1, sign_2, result_sign;
reg [7:0] result_exponent;
reg [22:0] result_mantissa;

always @(*) begin
    // Extract fields from operand_1
    sign_1 = operand_1[31];
    exponent_1 = operand_1[30:23];
    mantissa_1 = {1'b1, operand_1[22:0]};
    
    // Extract fields from operand_2
    sign_2 = operand_2[31];
    exponent_2 = operand_2[30:23];
    mantissa_2 = {1'b1, operand_2[22:0]}; 

    // Align exponents by shifting the mantissa of the smaller exponent
    if (exponent_1 > exponent_2) begin
        exponent_diff = exponent_1 - exponent_2;
        shifted_mantissa = mantissa_2 >> exponent_diff;
        result_exponent = exponent_1;
    end else begin
        exponent_diff = exponent_2 - exponent_1;
        shifted_mantissa = mantissa_1 >> exponent_diff;
        result_exponent = exponent_2;
    end

    // Perform addition or subtraction based on the operation and signs
    if (operation == 0) begin // Addition
        if (sign_1 == sign_2) begin
          
            mantissa_result = mantissa_1 + shifted_mantissa;
            result_sign = sign_1;
        end else begin
            // Different signs, perform subtraction
            if (mantissa_1 >= shifted_mantissa) begin
                mantissa_result = mantissa_1 - shifted_mantissa;
                result_sign = sign_1;
            end else begin
                mantissa_result = shifted_mantissa - mantissa_1;
                result_sign = sign_2;
            end
        end
    end else begin // Subtraction
        if (sign_1 != sign_2) begin
            // Different signs, perform addition
            mantissa_result = mantissa_1 + shifted_mantissa;
            result_sign = sign_1;
        end else begin
            // Same signs, perform subtraction
            if (mantissa_1 >= shifted_mantissa) begin
                mantissa_result = mantissa_1 - shifted_mantissa;
                result_sign = sign_1;
            end else begin
                mantissa_result = shifted_mantissa - mantissa_1;
                result_sign = !sign_1;
            end
        end
    end

	 
    // Normalization of addition the result
    if (mantissa_result[24] == 1) begin
         result_mantissa = mantissa_result >> 1;
         result_exponent = result_exponent + 1;
			
    end else begin
        result_mantissa = mantissa_result[22:0];
	 end
	 
          // Normalization of subtraction the result
    if (operation == 3'b001) begin
         while (mantissa_result[23] == 0 && result_exponent > 0) begin
                mantissa_result = mantissa_result << 1;
                result_exponent = result_exponent - 1;
            end
		   result_mantissa = mantissa_result[22:0];
     end



    // Assemble the result
    result = {result_sign, result_exponent, result_mantissa[22:0]};
end

endmodule

module FP_REG_FILE #(parameter N=32, address_size=5) (clk,write ,reset ,rs_address,rt_address,rd_address,read_data_1,read_data_2,write_data);
input [N-1:0] write_data;
input wire clk,reset,write ;
input [address_size-1:0] rs_address,rt_address,rd_address;
output reg [N-1:0] read_data_1,read_data_2;
reg [N-1:0] register_file[0:N-1];
integer k;

 (* RAM_STYLE="BLOCK " *)

initial begin
 $readmemh("Register_file_FP.txt", register_file );

end

always @ (posedge clk)
begin 
if(write)
 begin 
   register_file [rd_address] <= write_data;
 end
		
end


always @(*)
begin

read_data_1<=register_file[rs_address];
read_data_2<=register_file[rt_address];
end

endmodule
