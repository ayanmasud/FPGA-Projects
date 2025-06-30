module Top_CPU_Components_Test (
    input wire CLK,
    input wire [7:0] SW,
    input wire [2:0] BTN,
    output wire [7:0] LED,
    output wire LED_ZERO,
    output wire LED_CARRY
);

    // Debounced buttons
    wire [2:0] btn_debounced;
    debounce db0 (.clk(CLK), .btn_in(BTN[0]), .btn_out(btn_debounced[0]));
    debounce db1 (.clk(CLK), .btn_in(BTN[1]), .btn_out(btn_debounced[1]));
    debounce db2 (.clk(CLK), .btn_in(BTN[2]), .btn_out(btn_debounced[2]));

    // ALU signals
    reg [1:0] alu_op = 0;
    wire [7:0] alu_result;
    
    // Operand storage
    reg [7:0] operand_A = 0;
    reg [7:0] operand_B = 0;
    
    // Latch operands
    always @(posedge btn_debounced[1]) begin
        operand_A <= SW;  // BTN1 latches operand A
    end
    
    always @(posedge btn_debounced[2]) begin
        operand_B <= SW;  // BTN2 latches operand B
    end

    // Cycle operations
    always @(posedge btn_debounced[0]) begin
        alu_op <= alu_op + 1;
    end

    // Instantiate ALU with direct inputs
    ALU alu (
        .A(operand_A),
        .B(operand_B),
        .ALU_OP(alu_op),
        .RESULT(LED),      // Show result directly on LEDs
        .ZERO(LED_ZERO),
        .CARRY(LED_CARRY)
    );

endmodule