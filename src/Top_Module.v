module Top_Module(
    input seven_seg_clk,
    input clk,
    input reset,
    input [2:0] switches,
    output wire [6:0] seven_segment,
    output wire [3:0] anode
);

// Program Counter wires
wire [31:0] pc_out, branch_address;
wire  pc_src;

// Instruction Fetch wire
wire [31:0] instruction;

// Control Signals wires
wire [1:0] WB;
wire [2:0] M;
wire [3:0] EX;

// Sign Extension wire
wire [31:0] extended_constant;

// ALU wires
wire [31:0] alu_result;
wire [3:0] alu_operation;
wire overflow;

// Register File wires
wire [5:0] write_address;
wire [31:0] read_data_1, read_data_2, write_data;

// Memory wire
wire [31:0] memory_data;

// ALU Control wire
wire [5:0] function_bits;
wire zero_flag;

///IF_ID REGISTER

wire [31:0] IF_ID_pc,IF_ID_istr;

//ID_EX REGISTER

wire [1:0] ID_EX_WB;
wire [2:0] ID_EX_M;
wire [3:0] ID_EX_EX;
wire [31:0] ID_EX_pc;
wire [31:0] ID_EX_read_data_1;
wire [31:0] ID_EX_read_data_2;
wire [31:0] ID_EX_sign_ext_const;
wire [5:0] ID_EX_instruction_nibble_1;
wire [5:0] ID_EX_instruction_nibble_2;
wire [5:0] ID_EX_rs;
wire [5:0] ID_EX_rt;
wire ID_EX_fp_istr_check;


//EX_MEM Register

wire [1:0] EX_MEM_WB;
wire [2:0] EX_MEM_M;
wire [31:0] EX_MEM_branch_address;
wire [31:0] EX_MEM_alu_result;
wire [31:0] EX_MEM_read_data_2;
wire [5:0] EX_MEM_write_address;





//MEM_WB REGISTER

wire [1:0] MEM_WB_WB;
wire[31:0] MEM_WB_alu_result;
wire [31:0] MEM_WB_mem_data;
wire[5:0] MEM_WB_write_address;

// Forwarding Unit wires
wire [1:0] ForwardA, ForwardB;
wire [31:0] forward_A_data, forward_B_data;


// Seven segments register
reg [15:0] seg_in;

// Hazard Detection Unit wires
wire PC_Write, IF_ID_Write, control_mux_select;
wire [31:0] actual_result;

wire [31:0]alu_result_FP;

wire fp_istr_check;


wire [2:0] special_fp_no_flag;
// Display selection based on switches
always @(*) begin 
    case(switches)
        3'b000: seg_in = IF_ID_istr[15:0];
        3'b001: seg_in = IF_ID_istr[31:16];
        3'b010: seg_in = pc_out[15:0];
        3'b011: seg_in = pc_out[31:16];
        3'b100: seg_in = ID_EX_read_data_1[15:0];
        3'b101: seg_in = ID_EX_read_data_2[15:0];
        3'b111: seg_in = write_data[15:0];
		  3'b110: seg_in = fp_istr_check;
        default: seg_in = 16'h0000; // Default case to handle undefined switches state
    endcase
end 

// Instantiate Seven Segment Display module
SevenSegmentDisplay uut_seven_seg(
    .clk(seven_seg_clk),
    .reset(reset),
    .data_in(seg_in), 
    .seven_segment(seven_segment),
    .anode(anode)
);

reg [5:0] rs_address,rt_address,rd_address;

// pc_src MUX
assign pc_src = (zero_flag&M[0]);  //branch

// branch address
assign branch_address = ID_EX_sign_ext_const;

always @ (*)begin 
if(IF_ID_istr[31:26]==6'b010001) begin 

	rs_address<= IF_ID_istr[15:11]+32;
	rt_address<= IF_ID_istr[20:16]+32;
   rd_address<= IF_ID_istr[10:6]+32;
end
else begin
     rs_address<= {1'b0, IF_ID_istr[25:21]};
	  rt_address<= {1'b0, IF_ID_istr[20:16]};
	  rd_address<= {1'b0, IF_ID_istr[15:11]};
end 
end

reg [31:0] jump_address_;
wire jump;
wire [31:0] pc_next;
assign pc_next =pc_out+1;
assign jump =(instruction[31:26]==6'd2);
always @ *
jump_address_ ={2'b00,pc_next[31:28],instruction[25:0]};

// Instantiate Program Counter
PC uut_PC(
    .clk(clk),
    .reset(reset),
    .jump(jump),
	 .jump_address(jump_address_),
    .pc_src(pc_src),
    .branch_address(extended_constant),
    .write_enable(PC_Write),
    .pc_out(pc_out)
);

// Instantiate Instruction Memory module
Instruction_memory uut_IM(
    .reset(reset),
    .memory_address(pc_out),
    .instruction_out(instruction)
);


Control_Unit_With_Mux uut_CU_Mux (
	.clk(clk),
    .opcode(IF_ID_istr[31:26]),
    .control_mux_select(control_mux_select),
    .WB(WB),
    .M(M),
    .EX(EX),
	 .fp_istr_check(fp_istr_check)
);


IF_ID_Register uut_IF_ID(
	.clk(clk),
	.reset(reset),
	.IF_ID_Write(IF_ID_Write),
	.instruction_input(instruction),
	.pc_input(pc_out),
	.IF_ID_pc(IF_ID_pc),
	.IF_ID_istr(IF_ID_istr)
);




// Instantiate Hazard Detection Unit
Hazard_Detection_Unit uut_HDU (
    .IF_ID_RS(rs_address),
    .IF_ID_RT(rt_address),
    .ID_EX_RT(ID_EX_instruction_nibble_1),
    .ID_EX_mem_read(ID_EX_M[2]),
    .PC_Write(PC_Write),
    .IF_ID_Write(IF_ID_Write),
    .control_mux_select(control_mux_select)
);

// Instantiate Forwarding Unit module
Forwarding_Unit uut_FU (
    .ID_EX_rs(ID_EX_rs),
    .ID_EX_rt(ID_EX_rt),
    .EX_MEM_rd(EX_MEM_write_address),
    .MEM_WB_rd(MEM_WB_write_address),
    .EX_MEM_RegWrite(EX_MEM_WB[1]),
    .MEM_WB_RegWrite(MEM_WB_WB[1]),
    .ForwardA(ForwardA),
    .ForwardB(ForwardB)
);

// MUX for forward_A_data
assign forward_A_data = (ForwardA == 2'b00) ? ID_EX_read_data_1 :
                        (ForwardA == 2'b01) ? write_data :
                        (ForwardA == 2'b10) ? EX_MEM_alu_result : ID_EX_read_data_1;

// MUX for forward_B_data
assign forward_B_data = (ForwardB == 2'b00) ? ID_EX_read_data_2 :
                        (ForwardB == 2'b01) ? write_data :
                        (ForwardB == 2'b10) ? EX_MEM_alu_result : ID_EX_read_data_2;
								
								
 

// Instantiate ID/EX Register
ID_EX_Register uut_ID_EX (
    .clk(clk),
    .reset(reset),
    .pc_input(IF_ID_pc),
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .sign_ext_const(extended_constant),
    .instruction_nibble_1(rt_address), // Assuming appropriate fields
    .instruction_nibble_2(rd_address),
    .IF_ID_rs(rs_address),
    .IF_ID_rt(rt_address),
    .WB(WB),
    .M(M),
    .EX(EX),
	 .fp_istr_check(fp_istr_check),
	 
    .ID_EX_WB(ID_EX_WB),
    .ID_EX_M(ID_EX_M),
    .ID_EX_EX(ID_EX_EX),
    .ID_EX_pc(ID_EX_pc),
    .ID_EX_read_data_1(ID_EX_read_data_1),
    .ID_EX_read_data_2(ID_EX_read_data_2),
    .ID_EX_sign_ext_const(ID_EX_sign_ext_const),
    .ID_EX_instruction_nibble_1(ID_EX_instruction_nibble_1),
    .ID_EX_instruction_nibble_2(ID_EX_instruction_nibble_2),
    .ID_EX_rs(ID_EX_rs),
    .ID_EX_rt(ID_EX_rt),
	 .ID_EX_fp_istr_check(ID_EX_fp_istr_check)
);

assign write_address = ID_EX_EX[0]? ID_EX_instruction_nibble_1:ID_EX_instruction_nibble_2; ////based on regdst

assign zero_flag = (read_data_1==read_data_2);


wire[1:0] special_fp_no_reg ;
assign special_fp_no_reg ={0,ID_EX_WB[0]}; /// stoping to write in register 

wire[2:0] special_fp_no_mem ;
assign special_fp_no_mem ={ID_EX_M[2], 0,ID_EX_M[0]}; /// stoping to write in data memory

// Instantiate EX_MEM Register
EX_MEM_Register uut_EX_MEM (
    .clk(clk),
    .reset(reset),
    .branch_address(branch_address),
    .alu_result(actual_result),
    .read_data_2(ID_EX_read_data_2),
    .write_address(write_address),  
    .ID_EX_WB(special_fp_no_flag == 3'b000 ? ID_EX_WB :special_fp_no_reg), //to check for fp special no
    .ID_EX_M(special_fp_no_flag == 3'b000 ? ID_EX_M :special_fp_no_mem),
    .EX_MEM_WB(EX_MEM_WB),
    .EX_MEM_M(EX_MEM_M),
    .EX_MEM_branch_address(EX_MEM_branch_address),
    .EX_MEM_alu_result(EX_MEM_alu_result),
    .EX_MEM_read_data_2(EX_MEM_read_data_2),
    .EX_MEM_write_address(EX_MEM_write_address)
);


MEM_WB_Register uut_MEM_WB (
    .clk(clk),
    .reset(reset),
    .EX_MEM_alu_result(EX_MEM_alu_result),
    .mem_data(memory_data),
    .EX_MEM_write_address(EX_MEM_write_address),
    .EX_MEM_WB(EX_MEM_WB),
    .MEM_WB_WB(MEM_WB_WB),
    .MEM_WB_alu_result(MEM_WB_alu_result),
    .MEM_WB_mem_data(MEM_WB_mem_data),
    .MEM_WB_write_address(MEM_WB_write_address)
);


// Instantiate Sign Extension module
Sign_Extension uut_SE(
    .constant(IF_ID_istr[15:0]),
    .extended_constant(extended_constant)
);

 

// Instantiate Register File module
Register_File uut_RF(
    .clk(clk),
    .write(MEM_WB_WB[1]),
    .reset(reset),
    .rs_address(rs_address),
    .rt_address(rt_address),
    .rd_address(MEM_WB_write_address), 
    .read_data_1(read_data_1),
    .read_data_2(read_data_2),
    .write_data(write_data)
);

// Extract function bits
assign function_bits = ID_EX_sign_ext_const[5:0];

// Instantiate ALU Control module
ALU_Control uut_ALUC(
    .ALUOp(ID_EX_EX[3:2]),
    .function_bits(function_bits), 
    .ALUOperation(alu_operation)
);


assign actual_result= ID_EX_fp_istr_check && !ID_EX_M[2] ? alu_result_FP : alu_result ;  ///ID_EX_M[2] mem read


FP_ALU uut_fp_alu(
.operand_1(forward_A_data),
.operand_2(ID_EX_EX[1] ? ID_EX_sign_ext_const : forward_B_data),
.operation(alu_operation),
.result(alu_result_FP),
.flag(special_fp_no_flag)
);

/*
///if floating point special number comes then we dont have to write it in our register file and data memory.
assign MEM_WB_WB[1] =(special_fp_no_flag ==3'b000 && !EX_MEM_M[1] )? 1 : 0 ;  //for register file
assign EX_MEM_M[1] =(special_fp_no_flag ==3'b000 && EX_MEM_M[1])? 1 : 0 ; ///for data memory
*/

// Instantiate ALU module
ALU uut_ALU(
    .alu_operation(alu_operation),
    .operand_1(forward_A_data),
    .operand_2(ID_EX_EX[1] ? ID_EX_sign_ext_const : forward_B_data), // MUX for ALUSrc
    .data_out(alu_result),
    .overflow(overflow)
 
);

// Instantiate Data Memory module
Data_Memory uut_DM(
    .clk(clk),
    .reset(reset),
    .write_enable(EX_MEM_M[1]),
    .read_enable(EX_MEM_M[2]),
    .write_data(EX_MEM_read_data_2),
    .memory_address(EX_MEM_alu_result),
    .data_out(memory_data)
);

// Determine write data using MemtoReg signal
assign write_data = MEM_WB_WB[0] ? MEM_WB_mem_data : MEM_WB_alu_result; // MUX for MemtoReg

endmodule
