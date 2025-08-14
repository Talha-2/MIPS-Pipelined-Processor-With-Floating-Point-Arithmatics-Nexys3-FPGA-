module EX_MEM_Register(
    input clk,
    input reset,
    input [31:0] branch_address,
    input [31:0] alu_result,
    input [31:0] read_data_2,
    input [5:0] write_address, // Changed to 6 bits
    input [1:0] ID_EX_WB,
    input [2:3] ID_EX_M,
   
    output reg [1:0] EX_MEM_WB,
    output reg [2:0] EX_MEM_M,
    output reg [31:0] EX_MEM_branch_address,
    output reg [31:0] EX_MEM_alu_result,
    output reg [31:0] EX_MEM_read_data_2,
    output reg [5:0] EX_MEM_write_address // Changed to 6 bits
 
);


reg [106:0] EX_MEM;


always @(posedge clk or posedge reset) begin
    if (reset)
        EX_MEM <= 107'b0; // Adjusted the size to match the new configuration
    else begin
        EX_MEM[1:0] <= ID_EX_WB;
        EX_MEM[4:2] <= ID_EX_M;
        EX_MEM[36:5] <= branch_address;
        EX_MEM[68:37] <= alu_result;
        EX_MEM[100:69] <= read_data_2;
        EX_MEM[106:101] <= write_address; // Changed to 6 bits
    
    end
end

always @(*) begin
    EX_MEM_WB = EX_MEM[1:0];
    EX_MEM_M = EX_MEM[4:2];
    EX_MEM_branch_address = EX_MEM[36:5];
    EX_MEM_alu_result = EX_MEM[68:37];
    EX_MEM_read_data_2 = EX_MEM[100:69];
    EX_MEM_write_address = EX_MEM[106:101]; // Changed to 6 bits

end

endmodule
