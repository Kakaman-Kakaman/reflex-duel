// =============================================================================
// ldr_input.v  -  Reflex Duel  (4-cell)
// Uses friend's proven debounce style + edge detection
// One module handles debounce AND edge detection for all 4 channels
// =============================================================================

module ldr_input (
    input  wire        clk,
    input  wire        rst,
    input  wire [3:0]  raw_in,
    output wire [3:0]  clean_out,   // debounced level
    output wire [3:0]  edge_out     // one-cycle pulse on rising edge
);

    localparam DEBOUNCE_MAX = 5_000; // 5ms @ 100MHz (same as friend's code)

    // Channel 0
    reg [18:0] cnt0; reg deb0; reg prev0;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cnt0 <= 0; deb0 <= 0; end
        else if (raw_in[0] != deb0) begin
            cnt0 <= cnt0 + 1;
            if (cnt0 == DEBOUNCE_MAX) begin deb0 <= raw_in[0]; cnt0 <= 0; end
        end else cnt0 <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) prev0 <= 0;
        else     prev0 <= deb0;
    end

    // Channel 1
    reg [18:0] cnt1; reg deb1; reg prev1;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cnt1 <= 0; deb1 <= 0; end
        else if (raw_in[1] != deb1) begin
            cnt1 <= cnt1 + 1;
            if (cnt1 == DEBOUNCE_MAX) begin deb1 <= raw_in[1]; cnt1 <= 0; end
        end else cnt1 <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) prev1 <= 0;
        else     prev1 <= deb1;
    end

    // Channel 2
    reg [18:0] cnt2; reg deb2; reg prev2;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cnt2 <= 0; deb2 <= 0; end
        else if (raw_in[2] != deb2) begin
            cnt2 <= cnt2 + 1;
            if (cnt2 == DEBOUNCE_MAX) begin deb2 <= raw_in[2]; cnt2 <= 0; end
        end else cnt2 <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) prev2 <= 0;
        else     prev2 <= deb2;
    end

    // Channel 3
    reg [18:0] cnt3; reg deb3; reg prev3;
    always @(posedge clk or posedge rst) begin
        if (rst) begin cnt3 <= 0; deb3 <= 0; end
        else if (raw_in[3] != deb3) begin
            cnt3 <= cnt3 + 1;
            if (cnt3 == DEBOUNCE_MAX) begin deb3 <= raw_in[3]; cnt3 <= 0; end
        end else cnt3 <= 0;
    end
    always @(posedge clk or posedge rst) begin
        if (rst) prev3 <= 0;
        else     prev3 <= deb3;
    end

    // Debounced levels
    assign clean_out = {deb3, deb2, deb1, deb0};

    // Rising edge pulses - HIGH for exactly one clock cycle when light hits
    assign edge_out[0] = (deb0 == 0 && prev0 == 1);
    assign edge_out[1] = (deb1 == 0 && prev1 == 1);
    assign edge_out[2] = (deb2 == 0 && prev2 == 1);
    assign edge_out[3] = (deb3 == 0 && prev3 == 1);

endmodule
