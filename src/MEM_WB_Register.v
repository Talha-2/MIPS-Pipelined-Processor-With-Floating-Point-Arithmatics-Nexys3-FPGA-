`timescale 1ns / 1ps

module MEM_WB_Register(
    input clk, reset,
    input [31:0] EX_MEM_alu_result, mem_data,
    input [4:0] EX_MEM_write_address,
    input [1:0] EX_MEM_WB,
 
    output reg [1:0] MEM_WB_WB,
    output reg [31:0] MEM_WB_alu_result,
    output reg [31:0] MEM_WB_mem_data,
    output reg [5:0] MEM_WB_write_address  //changed to 6 bits
);
 reg [71:0] MEM_WB;
always @(posedge clk or posedge reset) begin
    if (reset) begin
      MEM_WB <= 71'b0;
    end
    else begin
        MEM_WB[1:0] <= EX_MEM_WB;
        MEM_WB[33:2] <= EX_MEM_alu_result; // This is MEM_WB[33:2]
        MEM_WB[65:34] <= mem_data;  // This is MEM_WB[65:34]
        MEM_WB[71:66] <= EX_MEM_write_address;  // This is MEM_WB[70:66]
        
      
    end
end

always @ (*)
begin
  // Assigning individual outputs
        MEM_WB_WB <=  MEM_WB[1:0];
        MEM_WB_alu_result <= MEM_WB[33:2];
        MEM_WB_mem_data <=   MEM_WB[65:34];
        MEM_WB_write_address <=   MEM_WB[71:66];

end

endmodule


