module control_unit (
    input clk,
    input rst,
    input [7:0] opcode,
    input zero_flag,
    input carry_flag,
    output reg reg_write,
    output reg [1:0] alu_op,
    output reg alu_src,
    output reg mem_write,
    output reg mem_read,
    output reg pc_inc,
    output reg pc_load,
    output reg [1:0] reg_src,
    output reg mem_addr_src
);
    // Define our simple instruction opcodes
    localparam NOP  = 8'h00;
    localparam ADD  = 8'h01;
    localparam ADDI = 8'h02; // Add Immediate
    localparam LOAD = 8'h03; // Load from RAM
    localparam STORE = 8'h04; // Store to RAM
    localparam JMPZ = 8'h05; // Jump if Zero

    always @(posedge clk) begin
        if (rst) begin
            // Default control signals (do nothing)
            reg_write <= 1'b0;
            alu_op <= 2'b00;
            alu_src <= 1'b0;
            mem_write <= 1'b0;
            mem_read <= 1'b0;
            pc_inc <= 1'b0;
            pc_load <= 1'b0;
            reg_src <= 2'b00;
            mem_addr_src <= 1'b0;
        end else begin
            // Defaults for each cycle
            reg_write <= 1'b0;
            mem_write <= 1'b0;
            mem_read <= 1'b0;
            pc_inc <= 1'b1; // Default: go to next instruction
            pc_load <= 1'b0;

            case (opcode)
                NOP: begin
                    // Do nothing, just increment PC
                end
                ADD: begin
                    reg_write <= 1'b1;
                    alu_op <= 2'b00; // ADD
                    alu_src <= 1'b0; // Use register B
                    reg_src <= 2'b00; // Write ALU result back to reg
                end
                ADDI: begin
                    reg_write <= 1'b1;
                    alu_op <= 2'b00; // ADD
                    alu_src <= 1'b1; // Use immediate value for B
                    reg_src <= 2'b00;
                end
                LOAD: begin
                    reg_write <= 1'b1;
                    mem_read <= 1'b1;
                    reg_src <= 2'b01; // Write data from RAM to reg
                    mem_addr_src <= 1'b0; // Use ALU result as addr
                end
                STORE: begin
                    mem_write <= 1'b1;
                    mem_addr_src <= 1'b0;
                end
                JMPZ: begin
                    pc_inc <= 1'b0; // Halt default increment
                    if (zero_flag) pc_load <= 1'b1; // Jump!
                end
                default: begin
                    // Handle unknown opcode (maybe NOP)
                end
            endcase
        end
    end
endmodule