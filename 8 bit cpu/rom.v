module rom (
    input [7:0] addr,
    output reg [15:0] data
);
    reg [15:0] memory [0:255]; // 256 words of 16-bit memory

    initial begin
        $readmemh("C:/Users/ayanr/8_bit_cpu/8_bit_cpu.srcs/constrs_1/new/rom_init.mem", memory);
    end

    always @(*) begin
        data = memory[addr];
    end
endmodule