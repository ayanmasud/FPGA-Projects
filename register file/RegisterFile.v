`timescale 1ns / 1ps

module RegisterFile (
    input wire CLK,
    input wire [2:0] READ_REG1,
    input wire [2:0] READ_REG2,
    input wire [2:0] WRITE_REG,
    input wire [7:0] WRITE_DATA,
    input wire REG_WRITE,
    output wire [7:0] DATA1,
    output wire [7:0] DATA2,
    output reg [7:0] REG_DISPLAY,
    input wire [2:0] DISPLAY_REG  // Input to select which register to display
);

    // 8 registers (8-bit each)
    reg [7:0] registers [0:7];

    // Initialize registers to 0 (optional)
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 8'b0;
        end
    end

    // Read ports (asynchronous)
    assign DATA1 = registers[READ_REG1];
    assign DATA2 = registers[READ_REG2];

    // Write port (synchronous)
    always @(posedge CLK) begin
        if (REG_WRITE) begin
            registers[WRITE_REG] <= WRITE_DATA;
        end
    end

    // Display selected register
    always @(*) begin
        REG_DISPLAY = registers[DISPLAY_REG];
    end

endmodule