`timescale 1ns / 1ps

module RegisterFile (
    input wire CLK,                // System clock
    input wire [2:0] READ_REG1,   // First read register address
    input wire [2:0] READ_REG2,   // Second read register address
    input wire [2:0] WRITE_REG,   // Write register address
    input wire [7:0] WRITE_DATA,  // Data to write
    input wire REG_WRITE,         // Write enable
    output wire [7:0] DATA1,      // First read output
    output wire [7:0] DATA2,      // Second read output
    output reg [7:0] REG_DISPLAY, // For debugging display
    input wire [2:0] DISPLAY_REG   // Select which register to display
);

    // 8x8-bit register file
    reg [7:0] registers [0:7];

    // Initialize all registers to zero
    integer i;
    initial begin
        for (i = 0; i < 8; i = i + 1) begin
            registers[i] = 8'b0;
        end
    end

    // Asynchronous read ports
    assign DATA1 = registers[READ_REG1];
    assign DATA2 = registers[READ_REG2];

    // Synchronous write (on rising clock edge)
    always @(posedge CLK) begin
        if (REG_WRITE) begin
            registers[WRITE_REG] <= WRITE_DATA;
        end
    end

    // Register display logic (for debugging)
    always @(*) begin
        REG_DISPLAY = registers[DISPLAY_REG];
    end

endmodule