`timescale 1ns / 1ps

module ALU (
    input wire [7:0] A,          // First operand (from registers)
    input wire [7:0] B,          // Second operand (from MUX)
    input wire [1:0] ALU_OP,     // Operation selector (00=ADD, 01=SUB, 10=AND, 11=OR)
    output reg [7:0] RESULT,     // 8-bit result
    output wire ZERO,            // 1 when result is zero
    output wire CARRY            // Carry/borrow for arithmetic ops
);

    // Operation codes - these match control unit's encoding
    localparam OP_ADD = 2'b00;
    localparam OP_SUB = 2'b01;
    localparam OP_AND = 2'b10;
    localparam OP_OR  = 2'b11;

    // 9-bit internal result (for carry detection)
    reg [8:0] arithmetic_result;

    // Main ALU operation selector
    always @(*) begin
        case (ALU_OP)
            OP_ADD: begin
                arithmetic_result = A + B;          // Addition
                RESULT = arithmetic_result[7:0];    // Lower 8 bits
            end
            OP_SUB: begin
                arithmetic_result = {1'b0, A} - {1'b0, B}; // Subtraction
                RESULT = arithmetic_result[7:0];
            end
            OP_AND: begin
                RESULT = A & B;                     // Bitwise AND
                arithmetic_result = {1'b0, RESULT};  // Zero-extend for flag logic
            end
            OP_OR: begin
                RESULT = A | B;                     // Bitwise OR
                arithmetic_result = {1'b0, RESULT};
            end
            default: begin                          // Default case (shouldn't happen)
                RESULT = 8'b0;
                arithmetic_result = 9'b0;
            end
        endcase
    end

    // Flag generation
    assign ZERO = (RESULT == 8'b0);      // True when all bits are zero
    assign CARRY = arithmetic_result[8]; // 9th bit indicates carry/borrow

endmodule