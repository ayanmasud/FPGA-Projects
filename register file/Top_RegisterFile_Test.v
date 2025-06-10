`timescale 1ns / 1ps

module Top_RegisterFile_Test (
    input wire CLK,          // 100 MHz clock
    input wire [7:0] SW,     // Switches (SW[2:0]=address, SW[7:0]=data)
    input wire [2:0] BTN,    // BTN[0]=write, BTN[1]=latch address, BTN[2]=cycle display
    output wire [7:0] LED    // LEDs show register contents
);

    // Debounce buttons (essential for reliable operation)
    wire btn0, btn1, btn2;
    debounce db0 (.clk(CLK), .btn_in(BTN[0]), .btn_out(btn0));
    debounce db1 (.clk(CLK), .btn_in(BTN[1]), .btn_out(btn1));
    debounce db2 (.clk(CLK), .btn_in(BTN[2]), .btn_out(btn2));

    // Latch address on BTN[1] press
    reg [2:0] stored_write_reg;
    always @(posedge btn1) begin
        stored_write_reg <= SW[2:0];
    end

    // Cycle through registers to display on BTN[2] press
    reg [2:0] display_reg = 0;
    always @(posedge btn2) begin
        display_reg <= display_reg + 1;
    end

    // Instantiate register file
    RegisterFile reg_file (
        .CLK(CLK),
        .READ_REG1(3'b0),       // Not used in this test
        .READ_REG2(3'b0),       // Not used in this test
        .WRITE_REG(stored_write_reg),
        .WRITE_DATA(SW[7:0]),
        .REG_WRITE(btn0),
        .DATA1(),               // Not used
        .DATA2(),               // Not used
        .REG_DISPLAY(LED),
        .DISPLAY_REG(display_reg)
    );

endmodule
