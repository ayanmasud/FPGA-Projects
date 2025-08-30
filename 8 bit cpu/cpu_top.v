module cpu_top (
    input clk,
    input rst,
    output [15:0] leds // Output for the test program
);
    // Internal wires
    wire [7:0] pc_addr;
    wire [15:0] instruction;
    wire [7:0] opcode = instruction[15:8];
    wire [7:0] imm_value = instruction[7:0];
    wire [2:0] reg_dest = imm_value[7:5]; // Use bits [7:5] for destination register
    wire [2:0] reg_src1 = imm_value[4:2]; // Use bits [4:2] for source register 1
    wire [2:0] reg_src2 = imm_value[1:0]; // Use bits [1:0] for source register 2
    // Control Unit outputs
    wire reg_write;
    wire [1:0] alu_op;
    wire alu_src;
    wire mem_write;
    wire mem_read;
    wire pc_inc;
    wire pc_load;
    wire [1:0] reg_data_src;
    wire mem_addr_src;
    // Register File outputs
    wire [7:0] reg_data1;
    wire [7:0] reg_data2;
    // ALU outputs
    wire [7:0] alu_result;
    wire alu_zero;
    wire alu_carry;
    // ALU MUX output
    wire [7:0] alu_mux_out;
    // Register Data MUX output
    wire [7:0] reg_data_mux_out;
    // RAM Address MUX output
    wire [7:0] ram_addr_mux_out;
    // RAM output
    wire [7:0] ram_data_out;
    // Module Instantiations
    pc ProgramCounter (.clk(clk), .rst(rst), .pc_inc(pc_inc), .pc_load(pc_load), .jump_addr(imm_value), .addr(pc_addr));
    rom InstructionMemory (.addr(pc_addr), .data(instruction));
    control_unit ControlUnit (.clk(clk), .rst(rst), .opcode(opcode), .zero_flag(alu_zero), .carry_flag(alu_carry),
                            .reg_write(reg_write), .alu_op(alu_op), .alu_src(alu_src), .mem_write(mem_write), .mem_read(mem_read),
                            .pc_inc(pc_inc), .pc_load(pc_load), .reg_src(reg_data_src), .mem_addr_src(mem_addr_src));
    reg_file RegisterFile (.clk(clk), .rst(rst), .reg_write(reg_write), .read_reg1(reg_src1), .read_reg2(reg_src2),
                            .write_reg(reg_dest), .write_data(reg_data_mux_out), .read_data1(reg_data1), .read_data2(reg_data2));
    alu ALU (.a(reg_data1), .b(alu_mux_out), .op(alu_op), .result(alu_result), .zero(alu_zero), .carry(alu_carry));
    mux_2to1 #(8) ALUMux (.in0(reg_data2), .in1(imm_value), .sel(alu_src), .out(alu_mux_out));
    mux_4to1 #(8) RegDataMux (.in0(alu_result), .in1(ram_data_out), .in2(8'b0), .in3(8'b0), .sel(reg_data_src), .out(reg_data_mux_out));
    mux_2to1 #(8) RAMAddrMux (.in0(alu_result), .in1(pc_addr), .sel(mem_addr_src), .out(ram_addr_mux_out));
    ram DataMemory (.clk(clk), .addr(ram_addr_mux_out), .data_in(reg_data2), .mem_write(mem_write), .mem_read(mem_read),
                    .data_out(ram_data_out), .leds_out(leds));
endmodule