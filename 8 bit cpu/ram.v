module ram (
    input clk,
    input [7:0] addr,
    input [7:0] data_in,
    input mem_write,
    input mem_read,
    output reg [7:0] data_out,
    output reg [15:0] leds_out // Connected to Basys 3 LEDs
);
    reg [7:0] memory [0:255]; // 256 bytes of data memory

    integer i;
    initial begin
        for (i=0; i<256; i=i+1) memory[i] = 8'b0;
        leds_out = 16'b0;
    end

    always @(posedge clk) begin
        // Memory-Mapped IO: Writing to address 0x80 controls LEDs
        if (mem_write && addr == 8'h80) begin
            leds_out <= {8'b0, data_in}; // Assign lower 8 bits to LEDs
        end else if (mem_write) begin
            memory[addr] <= data_in;
        end
    end

    always @(*) begin
        if (mem_read) begin
            if (addr == 8'h80)
                data_out = leds_out[7:0]; // Can also read from LEDs
            else
                data_out = memory[addr];
        end else begin
            data_out = 8'bz; // High impedance when not reading
        end
    end
endmodule