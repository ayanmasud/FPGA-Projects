`timescale 1ns / 1ps

module debounce (
    input wire clk,
    input wire btn_in,
    output reg btn_out
);

    reg [19:0] counter;
    reg btn_sync;

    always @(posedge clk) begin
        btn_sync <= btn_in;
        if (btn_sync ^ btn_in) begin  // If button state changed
            counter <= 0;
        end else if (counter == 20'd1_000_000) begin  // 10ms debounce
            btn_out <= btn_in;
        end else begin
            counter <= counter + 1;
        end
    end

endmodule