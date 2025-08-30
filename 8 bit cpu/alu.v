module alu (
    input [7:0] a,
    input [7:0] b,
    input [1:0] op, // 00 = ADD, 01 = SUB, 10 = AND, 11 = OR
    output reg [7:0] result,
    output reg zero,
    output reg carry
);
    reg [8:0] temp_result; // 9-bit for carry-out

    always @(*) begin
        carry = 1'b0;
        zero = 1'b0;
        temp_result = 9'b0;

        case (op)
            2'b00: temp_result = a + b;        // ADD
            2'b01: temp_result = a - b;        // SUB
            2'b10: temp_result = a & b;        // AND
            2'b11: temp_result = a | b;        // OR
            default: temp_result = {1'b0, a};  // NOP
        endcase

        result = temp_result[7:0];
        carry = temp_result[8]; // Carry is 9th bit for ADD/SUB
        zero = (result == 8'b0);
    end
endmodule