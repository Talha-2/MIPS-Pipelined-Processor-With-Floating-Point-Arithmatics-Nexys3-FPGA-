module Instruction_memory #(parameter N=32)(reset,memory_address,instruction_out);
input reset;
input[N-1:0] memory_address;
output reg [N-1:0] instruction_out;

reg [N-1:0] instruction_memory [0:N-1];

 (* RAM_STYLE="BLOCK " *)

 initial begin
    // R-type Instructions
	   //  instruction_memory[0] = 32'b000100_01011_01011_0000000001000010;    // BEQ $t12, $t11, offset
  
	 //instruction_memory[0] = 32'b100011_01001_01000_0000000000000100;    // LW $t8, 4($t9)
   // instruction_memory[1] = 32'b100011_01000_01001_0000000000001000;
    instruction_memory[0] = 32'b000000_01001_01110_01100_00000_100000;  // ADD $t12, $t9, $t14
    instruction_memory[1] = 32'b000000_01100_01111_01101_00000_100010;  // SUB $t13, $t12, $t15
    instruction_memory[2] = 32'b000000_01101_01101_01110_00000_100100;  // MUL $t14, $t13, $t13
    instruction_memory[3] = 32'b000000_01110_01100_01011_00000_100101;  // XOR $t11, $t14, $t12
    instruction_memory[4] = 32'b000000_01010_01101_01111_00000_101010;  // SLT $t15, $t10, $t13
	 //floating point instruction
	 instruction_memory[5] = 32'b010001_01001_00000_00001_00011_100000;  // ADD.s $t3, $t0, $t1
	 instruction_memory[6] = 32'b010001_00010_00000_01001_00111_100010;  // SUB.s $t7, $t2, $t9
	 instruction_memory[7] = 32'b010001_01101_01101_01110_00000_100100;  // MUL.s $t14, $t13, $t13
    // Load Word Instructions
    instruction_memory[8] = 32'b100011_01101_01000_0000000000000100;    // LW $t8, 4($t13)
    instruction_memory[9] = 32'b100011_01100_01001_0000000000001000;    // LW $t9, 8($t12)

    // Store Word Instructions
    instruction_memory[10] = 32'b101011_01011_01010_0000000000001100;    // SW $t10, 12($t11)
    instruction_memory[11] = 32'b101011_01010_01011_0000000000010000;    // SW $t11, 16($t10)

    // Branch Instructions
    instruction_memory[12] = 32'b000100_01100_01011_0000000000000010;    // BEQ $t12, $t11, offset

    // Jump Instructions
    instruction_memory[13] = 32'b000010_00000000000000000000001111;     // J address
	 
	 instruction_memory[14] = 32'b000000_01001_01110_01100_00000_100000;  // ADD $t12, $t9, $t14
    instruction_memory[15] = 32'b000000_01100_01111_01101_00000_100010;  // SUB $t13, $t12, $t15 (dependency on $t12)
       // Load Word Instructions with dependencies
    instruction_memory[16] = 32'b100011_01001_01000_0000000000000100;    // LW $t8, 4($t9)
    instruction_memory[17] = 32'b100011_01000_01001_0000000000001000;    // LW $t9, 8($t8) (dependency on $t8)
	 
	     // Store Word Instructions with dependencies
    instruction_memory[18] = 32'b101011_01100_01001_0000000000001100;    // SW $t9, 12($t12) (dependency on $t12)
    instruction_memory[19] = 32'b101011_01001_01100_0000000000010000;    // SW $t12, 16($t9) (dependency on $t9)
end

always @(*) begin
    if (reset)
        instruction_out <= 0;
    else
        instruction_out <= instruction_memory[memory_address];
end

endmodule
