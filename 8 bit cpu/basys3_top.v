module basys3_top (
    input clk,          // 100 MHz Basys 3 clock
    input btnC,         // Center button for reset
    output [15:0] led   // 16 LEDs on the Basys 3
);
    // Create a slower clock (~ 6 Hz) so we can see the counting
    reg [23:0] clk_divider = 0;
    wire slow_clk = clk_divider[23]; // Bit 23 toggles at ~6 Hz

    always @(posedge clk) begin
        clk_divider <= clk_divider + 1;
    end

    // Instantiate the CPU with the slow clock
    cpu_top my_cpu (.clk(slow_clk), .rst(btnC), .leds(led));

endmodule