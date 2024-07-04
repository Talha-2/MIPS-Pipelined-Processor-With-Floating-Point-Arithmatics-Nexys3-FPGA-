`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:59:06 06/02/2024 
// Design Name: 
// Module Name:    FP_ALU 
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






module FP_ALU(
    input [31:0] operand_1,
    input [31:0] operand_2,
    input [3:0] operation,
    output reg [31:0] result,
	 output reg [2:0]flag
);

wire [31:0]op1,op2 ;

assign op1 = operand_1;
assign op2 = operand_2;

wire [31:0]results_add_sub;
wire [31:0]results_mul;
wire [31:0]results_div;

FP_Addition_Subtraction fpas(op1,op2,operation,results_add_sub);
FP_Multiply FPm(op1,op2,results_mul);
FP_Divide fpdu (op1,op2,results_div);

always@(*) begin
if(operation == 4'b0010 || operation == 4'b0110)
result <= results_add_sub;
else if(operation == 4'b0000)
result <= results_mul;
else if(4'b0001)
result <= results_div;


if (result == 32'h7FC00000)  // NaN
   flag <= 3'b100;
else if(result == 32'h00000000) // zero
   flag <= 3'b010;
else if(result == 32'h7F800000) // infinity
   flag <= 3'b001;
else
   flag <= 3'b000;
end
endmodule



module FP_Multiply(
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] result
);

reg [7:0] exponent_1, exponent_2, result_exponent;
reg [23:0] mantissa_1, mantissa_2;
reg [47:0] mantissa_product;
reg sign_1, sign_2, result_sign;
reg [23:0] result_mantissa;

always @(*) begin
    // Extract sign, exponent, and mantissa from operand1
    sign_1 = operand1[31];
    exponent_1 = operand1[30:23];
    mantissa_1 = {1'b1, operand1[22:0]};

    // Extract sign, exponent, and mantissa from operand2
    sign_2 = operand2[31];
    exponent_2 = operand2[30:23];
    mantissa_2 = {1'b1, operand2[22:0]};

    // Compute the sign of the result
    result_sign = sign_1 ^ sign_2;

    // Compute the exponent of the result
    result_exponent = exponent_1 + exponent_2 - 8'd127;

    // Compute the product of the mantissas
    mantissa_product = mantissa_1 * mantissa_2;

    // Normalize the result mantissa
    if(mantissa_product[47] == 1) begin
        result_mantissa = mantissa_product[46:24];
        result_exponent = result_exponent + 1;
    end else begin
        result_mantissa = mantissa_product[45:23];
    end

    // Assemble the final result
	 if(operand1 == 32'h7FC00000 || operand2 == 32'h7FC00000) // NaN
       result = 32'h7FC00000;
    else if(operand1 == 0 || operand2 == 0) // zero
       result = 32'd0;
     else
       result = {result_sign, result_exponent, result_mantissa[22:0]};
end

endmodule

module FP_Divide(
    input [31:0] dividend,
    input [31:0] divisor,
    output reg [31:0] result
);

reg [7:0] exponent_dividend, exponent_divisor, result_exponent;
reg [23:0] mantissa_dividend, mantissa_divisor;
reg [47:0] mantissa_quotient;
reg sign_dividend, sign_divisor, result_sign;
reg [22:0] result_mantissa;
integer i;
always @(*) begin
    // Initialize the result to zero
    result = 32'b0;
    
    // Special case for zero divisor
    if (divisor == 32'b0) begin
        result = {dividend[31], 8'hFF, 23'b0}; // +/-Infinity
    end else if (dividend == 32'b0) begin
        result = 32'b0; // Zero
    end else begin
        // Extract sign from dividend and divisor
        sign_dividend = dividend[31];
        sign_divisor = divisor[31];
        
        // Extract exponent from dividend and divisor
        exponent_dividend = dividend[30:23];
        exponent_divisor = divisor[30:23];

        // Extract mantissa from dividend
        if (exponent_dividend == 0) begin
            mantissa_dividend = {1'b0, dividend[22:0]};
        end else begin
            mantissa_dividend = {1'b1, dividend[22:0]};
        end

        // Extract mantissa from divisor
        if (exponent_divisor == 0) begin
            mantissa_divisor = {1'b0, divisor[22:0]};
        end else begin
            mantissa_divisor = {1'b1, divisor[22:0]};
        end

        // Compute the sign of the result
        result_sign = sign_dividend ^ sign_divisor;

        // Compute the exponent of the result
        result_exponent = exponent_dividend - exponent_divisor + 8'd127;

        // Perform mantissa division
        mantissa_quotient = {mantissa_dividend, 24'b0} / mantissa_divisor;

        // Normalize the result mantissa
        if (mantissa_quotient[47] == 0) begin
            // Find the first 1 in mantissa_quotient
				for(i=0; i<24 &&mantissa_quotient[47] == 0 && result_exponent > 0;i=i+1)begin
           
                mantissa_quotient = mantissa_quotient << 1;
               // result_exponent = result_exponent - 1;
            end
        end

        result_mantissa = mantissa_quotient[46:24];

        // Handle underflow and overflow
       /* if (result_exponent >= 255) begin
            // Overflow
            result_exponent = 8'd255;
            result_mantissa = 0;
        end else if (result_exponent <= 0) begin
            // Underflow
            result_exponent = 8'd0;
            result_mantissa = 0;
        end
*/
        // Assemble the final result
       result = {result_sign, result_exponent, result_mantissa[22:0]};
    end
end

endmodule

module FP_Addition_Subtraction(
    input [31:0] operand_1,
    input [31:0] operand_2,
    input [3:0] operation,
    output reg [31:0] result
);

reg [7:0] exponent_1, exponent_2, exponent_diff;
reg [23:0] mantissa_1, mantissa_2;
reg [24:0] mantissa_result;
reg [23:0] shifted_mantissa;
reg sign_1, sign_2, result_sign;
reg [7:0] result_exponent;
reg [23:0] result_mantissa;
reg [23:0] mantissa_result_1;


integer k;
always @(*) begin
    // Extract fields from operand_1
    sign_1 = operand_1[31];
    exponent_1 = operand_1[30:23];
    mantissa_1 = {1'b1, operand_1[22:0]}; // Add implicit leading 1
    
    // Extract fields from operand_2
    sign_2 = operand_2[31];
    exponent_2 = operand_2[30:23];
    mantissa_2 = {1'b1, operand_2[22:0]}; // Add implicit leading 1

    // Align exponents by shifting the mantissa of the smaller exponent
    if (exponent_1 > exponent_2) begin
        exponent_diff = exponent_1 - exponent_2;
        shifted_mantissa = mantissa_2 >> exponent_diff;
        result_exponent = exponent_1;
        mantissa_result = (operation == 4'b0010) ? (mantissa_1 + shifted_mantissa) : (mantissa_1 - shifted_mantissa);
        if(sign_1 == sign_2)
             if(operation == 4'b0010)
             result_sign = sign_1;
             else
             result_sign = (mantissa_1 > shifted_mantissa) ? 0 : 1;
        else if(sign_1 > sign_2) 
             if(operation == 4'b0010)
             result_sign = (mantissa_1 > shifted_mantissa) ? 1 : 0;
             else
             result_sign = 1;
        else 
             if(operation == 4'b0010)
             result_sign = (mantissa_1 > shifted_mantissa) ? 0 : 1;
             else
             result_sign = 1;
        end else begin
        exponent_diff = exponent_2 - exponent_1;
        shifted_mantissa = mantissa_1 >> exponent_diff;
        result_exponent = exponent_2;
        mantissa_result = (operation == 4'b0010) ? (mantissa_2 + shifted_mantissa) : (-shifted_mantissa + mantissa_2);
        if(sign_1 == sign_2)
             if(operation == 4'b0010)
             result_sign = sign_1;
             else
             result_sign = (shifted_mantissa > mantissa_2) ? 0 : 1;
        else if(sign_1 > sign_2)
             if(operation ==4'b0010)
             result_sign = (shifted_mantissa > mantissa_2) ? 1 : 0;
             else
             result_sign = 1;
        else 
             if(operation == 4'b0010)
             result_sign = (shifted_mantissa > mantissa_2) ? 0 : 1;
             else
             result_sign = 1;
    end
              
    // Normalize the result
    if (mantissa_result[24] == 1) begin
         result_mantissa = mantissa_result >> 1;
        result_exponent = result_exponent + 1;
    end else begin
        result_mantissa = mantissa_result[22:0];
        // If subtraction, result might need normalization
        if (operation == 4'b0110) begin
            for (k = 0; k<23 &&result_mantissa[23] == 0 && result_exponent > 0 ;k = k+1) begin
                result_mantissa = result_mantissa << 1;
                result_exponent = result_exponent - 1;
            
                 end
            end     
    end

    // Assemble the result
	 if(operand_1 == 32'h7FC00000 || operand_2 == 32'h7FC00000) // NaN
       result = 32'h7FC00000;
    else if(operand_1 == operand_2 && operation == 4'b0110) // zero
       result = 32'd0;
    else
    result = {result_sign, result_exponent, result_mantissa[22:0]};
end


endmodule