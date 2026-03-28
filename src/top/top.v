module top (
    input  wire        clk_100mhz,
    input  wire        rst,
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b
);

    wire [9:0] pixel_x;
    wire [9:0] pixel_y;
    wire       active;

    // Instantiate VGA controller
    vga_controller vga_ctrl (
        .clk_100mhz (clk_100mhz),
        .rst        (rst),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y),
        .active     (active)
    );

    // Instantiate pixel renderer with test values
    // (hardcoded for now so we can test on monitor)
    pixel_renderer renderer (
        .clk            (clk_100mhz),
        .active         (active),
        .pixel_x        (pixel_x),
        .pixel_y        (pixel_y),
        .p1_score       (4'd3),
        .p2_score       (4'd2),
        .p1_reaction    (10'd342),
        .p2_reaction    (10'd510),
        .round_num      (2'd1),
        .p1_round_wins  (2'd1),
        .p2_round_wins  (2'd0),
        .game_over      (1'b0),
        .p1_wins        (1'b0),
        .vga_r          (vga_r),
        .vga_g          (vga_g),
        .vga_b          (vga_b)
    );

endmodule