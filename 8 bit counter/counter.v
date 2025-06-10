`timescale 1ns / 1ps

module counter(
    input clk,
    input reset,
    output [7:0] led
);

reg [25:0] clk_divider;  // Clock divider for 1Hz count
reg [7:0]  count;        // 8-bit counter

// Clock division (~1Hz from 100MHz)
always @(posedge clk or posedge reset) begin
    if (reset) begin
        clk_divider <= 0;
        count       <= 0;
    end
    else begin
        if (clk_divider == 50_000_000) begin  // Adjust for speed (50M = ~1Hz)
            clk_divider <= 0;
            count <= count + 1;  // Increment counter
        end
        else begin
            clk_divider <= clk_divider + 1;
        end
    end
end

// Assign counter value to LEDs
assign led = count;

endmodule