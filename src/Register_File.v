module Register_File #(parameter N=32, address_size=6) (clk,write ,reset ,rs_address,rt_address,rd_address,read_data_1,read_data_2,write_data);
input [N-1:0] write_data;
input wire clk,reset,write ;
input [address_size-1:0] rs_address,rt_address,rd_address;
output reg [N-1:0] read_data_1,read_data_2;
reg [N-1:0] register_file[0:63];
integer i;

 (* RAM_STYLE="BLOCK " *)

initial begin
 $readmemh("Register_file.txt", register_file );

end

always @ (posedge clk)
 if(write)
 begin 
   register_file [rd_address] <= write_data;
 end
		



always @(*)
begin

read_data_1<=register_file[rs_address];
read_data_2<=register_file[rt_address];
end

endmodule
