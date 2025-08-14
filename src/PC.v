module PC (
    input clk,
    input reset,
    input jump,
	 input[31:0] jump_address,
    input pc_src,
    input [31:0] branch_address,
    input write_enable,
    output [31:0] pc_out
);

// Internal register to hold the PC value
reg [31:0] pc_reg;

// PC increment logic
always @(posedge clk or posedge reset) begin
    if (reset)
        pc_reg <= 32'h0;
	else if(jump)
		pc_reg<=jump_address;
    else if (pc_src)
        pc_reg <= branch_address;
    else if (write_enable)
        pc_reg <= pc_reg + 1;
end

// Output the PC value
assign pc_out = pc_reg;

endmodule
