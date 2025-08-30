module pc (
    input clk,
    input rst,
    input pc_inc,
    input pc_load,
    input [7:0] jump_addr,
    output reg [7:0] addr
);
    always @(posedge clk) begin
        if (rst)
            addr <= 8'b0;
        else if (pc_load)
            addr <= jump_addr;
        else if (pc_inc)
            addr <= addr + 1;
    end
endmodule