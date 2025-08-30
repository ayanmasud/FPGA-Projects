module reg_file (
    input clk,
    input rst,
    input reg_write,
    input [2:0] read_reg1,
    input [2:0] read_reg2,
    input [2:0] write_reg,
    input [7:0] write_data,
    output reg [7:0] read_data1,
    output reg [7:0] read_data2
);
    reg [7:0] registers [0:7];
    integer i;

    // Initialize all registers to 0
    initial begin
        for (i=0; i<8; i=i+1) registers[i] = 8'b0;
    end

    // Read ports (asynchronous)
    always @(*) begin
        read_data1 = registers[read_reg1];
        read_data2 = registers[read_reg2];
    end

    // Write port (synchronous)
    always @(posedge clk) begin
        if (rst) begin
            for (i=0; i<8; i=i+1) registers[i] <= 8'b0;
        end else if (reg_write) begin
            registers[write_reg] <= write_data;
        end
    end
endmodule