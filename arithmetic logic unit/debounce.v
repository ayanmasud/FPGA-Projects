`timescale 1ns / 1ps

module debounce (
    input wire clk,          // 100 MHz clock
    input wire btn_in,       // Raw button input
    output reg btn_out       // Clean, debounced output
);

    // Parameters
    localparam DEBOUNCE_MS = 20;     // 20ms debounce period
    localparam CLK_FREQ = 100_000_000; // 100 MHz clock
    localparam MAX_COUNT = (DEBOUNCE_MS * CLK_FREQ) / 1000; // Clock cycles for debounce
    
    // Internal signals
    reg [31:0] counter = 0;
    reg btn_sync;

    // Synchronize button input to clock domain (avoid metastability)
    always @(posedge clk) begin
        btn_sync <= btn_in;
    end

    // Debounce logic
    always @(posedge clk) begin
        if (btn_out != btn_sync) begin
            // Button state is different from output
            if (counter == MAX_COUNT) begin
                // Stable for debounce period - update output
                btn_out <= btn_sync;
                counter <= 0;
            end else begin
                counter <= counter + 1;
            end
        end else begin
            // Button state matches output - reset counter
            counter <= 0;
        end
    end

endmodule