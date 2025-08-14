module Control_Unit_With_Mux (
	 input clk,
    input [5:0] opcode,
    input control_mux_select,
    output reg [1:0] WB,
    output reg [2:0] M,
    output reg [3:0] EX,
	 output reg fp_istr_check
);

reg reg_dst_normal, branch_normal, mem_read_normal, mem_to_reg_normal, alu_src_normal, reg_write_normal, mem_write_normal;
reg [1:0] alu_op_normal;

always @(*) begin
    // Normal control unit logic
	 fp_istr_check=0;
    case (opcode)
			6'd17:begin  ///for floating point r-type addition
			   reg_dst_normal = 1;
            alu_src_normal = 0;
            mem_to_reg_normal = 0;
            reg_write_normal = 1;
            mem_read_normal = 0;
            mem_write_normal = 0;
            branch_normal = 0;
            alu_op_normal = 2'b10;
				fp_istr_check=1;
			end
        6'd0: begin // R-type instructions (add, sub, mul, slt)
            reg_dst_normal = 1;
            alu_src_normal = 0;
            mem_to_reg_normal = 0;
            reg_write_normal = 1;
            mem_read_normal = 0;
            mem_write_normal = 0;
            branch_normal = 0;
            alu_op_normal = 2'b10;
					
        end
        6'd8: begin // Immediate instructions (addi, subi, muli)
            reg_dst_normal = 0;
            alu_src_normal = 1;
            mem_to_reg_normal = 0;
            reg_write_normal = 1;
            mem_read_normal = 0;
            mem_write_normal = 0;
            branch_normal = 0;
            alu_op_normal = 2'b00;
        end
        6'd35: begin // Load Word (lw) instruction
            reg_dst_normal = 0;
            alu_src_normal = 1;
            mem_to_reg_normal = 1;
            reg_write_normal = 1;
            mem_read_normal = 1;
            mem_write_normal = 0;
            branch_normal = 0;
            alu_op_normal = 2'b00;
        end
        6'd43: begin // Store Word (sw) instruction
            reg_dst_normal = 0;
            alu_src_normal = 1;
            mem_to_reg_normal = 0;
            reg_write_normal = 0;
            mem_read_normal = 0;
            mem_write_normal = 1;
            branch_normal = 0;
            alu_op_normal = 2'b00;
        end
        6'd4: begin // Branch instruction
            reg_dst_normal = 0;
            alu_src_normal = 1;
            mem_to_reg_normal = 0;
            reg_write_normal = 0;
            mem_read_normal = 0;
            mem_write_normal = 0;
            branch_normal = 1;
            alu_op_normal = 2'b01;
        end
        default: begin
            // Default case for undefined opcodes
            reg_dst_normal = 0;
            alu_src_normal = 0;
            mem_to_reg_normal = 0;
            reg_write_normal = 0;
            mem_read_normal = 0;
            mem_write_normal = 0;
            branch_normal = 0;
            alu_op_normal = 2'b00;
        end
    endcase
end

always @(*) begin
    if (control_mux_select) begin
        // No-op signals to stall the pipeline
        WB = 2'b00;
        M = 3'b000;
        EX = 4'b0000;
    end else begin
        // Normal control signals
			WB[0]=mem_to_reg_normal;
			WB[1]=reg_write_normal;
			
			M[0] = branch_normal;
			M[1] =mem_write_normal;
			M[2]=mem_read_normal;
			
		   EX[0]= reg_dst_normal;
		   EX[1]= alu_src_normal;
			EX[3:2]=alu_op_normal;
		  
    end
end

endmodule
