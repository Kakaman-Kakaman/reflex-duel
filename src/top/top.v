module top (
    input  wire        clk_100mhz,
    input  wire        rst,
    input  wire        start,
    input  wire [8:0]  p1_ldr,
    input  wire [8:0]  p2_ldr,
    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b,
    output wire [8:0]  led_out
);

    wire [10:0] pixel_x;
    wire [9:0]  pixel_y;
    wire        active;

    wire [3:0]  p1_score, p2_score;
    wire [9:0]  p1_reaction, p2_reaction;
    wire [1:0]  round_num, p1_round_wins, p2_round_wins;
    wire        game_over, p1_wins;

    vga_controller vga_ctrl (
        .clk_100mhz (clk_100mhz),
        .rst        (rst),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y),
        .active     (active)
    );

    pixel_renderer renderer (
        .clk           (clk_100mhz),
        .active        (active),
        .pixel_x       (pixel_x),
        .pixel_y       (pixel_y),
        .p1_score      (p1_score),
        .p2_score      (p2_score),
        .p1_reaction   (p1_reaction),
        .p2_reaction   (p2_reaction),
        .round_num     (round_num),
        .p1_round_wins (p1_round_wins),
        .p2_round_wins (p2_round_wins),
        .game_over     (game_over),
        .p1_wins       (p1_wins),
        .vga_r         (vga_r),
        .vga_g         (vga_g),
        .vga_b         (vga_b)
    );

    game_logic game (
        .clk           (clk_100mhz),
        .rst           (rst),
        .start         (start),
        .p1_ldr        (p1_ldr),
        .p2_ldr        (p2_ldr),
        .led_out       (led_out),
        .p1_score      (p1_score),
        .p2_score      (p2_score),
        .p1_reaction   (p1_reaction),
        .p2_reaction   (p2_reaction),
        .round_num     (round_num),
        .p1_round_wins (p1_round_wins),
        .p2_round_wins (p2_round_wins),
        .game_over     (game_over),
        .p1_wins       (p1_wins)
    );

endmodule