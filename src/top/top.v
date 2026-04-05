// =============================================================================
// top.v  -  Reflex Duel  (4-cell proof of concept)
// =============================================================================

module top (
    input  wire        clk_100mhz,
    input  wire        rst,
    input  wire        start,

    input  wire [3:0]  p1_ldr,
    input  wire [3:0]  p2_ldr,

    output wire [3:0]  led_out,
    output wire [7:0]  debug_led,

    output wire        hsync,
    output wire        vsync,
    output wire [3:0]  vga_r,
    output wire [3:0]  vga_g,
    output wire [3:0]  vga_b
);

    wire [10:0] pixel_x;
    wire [9:0]  pixel_y;
    wire        active;

    wire [3:0]  led_out_wire;
    wire [3:0]  p1_score,      p2_score;
    wire [9:0]  p1_reaction,   p2_reaction;
    wire [1:0]  round_num;
    wire [1:0]  p1_round_wins, p2_round_wins;
    wire        game_over;
    wire        p1_wins;

    wire [3:0]  p1_ldr_clean, p2_ldr_clean;
    wire [3:0]  p1_ldr_edge,  p2_ldr_edge;

    assign led_out = led_out_wire;

    // Debug: LD[2:0]=state  LD[6:3]=led_out  LD[7]=game_over
    assign debug_led[2:0] = u_game.state;
    assign debug_led[6:3] = led_out_wire;
    assign debug_led[7]   = game_over;

    vga_controller u_vga (
        .clk_100mhz (clk_100mhz),
        .rst        (rst),
        .hsync      (hsync),
        .vsync      (vsync),
        .pixel_x    (pixel_x),
        .pixel_y    (pixel_y),
        .active     (active)
    );

    pixel_renderer u_renderer (
        .clk          (clk_100mhz),
        .active       (active),
        .pixel_x      (pixel_x),
        .pixel_y      (pixel_y),
        .p1_score     (p1_score),
        .p2_score     (p2_score),
        .p1_reaction  (p1_reaction),
        .p2_reaction  (p2_reaction),
        .round_num    (round_num),
        .p1_round_wins(p1_round_wins),
        .p2_round_wins(p2_round_wins),
        .game_over    (game_over),
        .p1_wins      (p1_wins),
        .vga_r        (vga_r),
        .vga_g        (vga_g),
        .vga_b        (vga_b)
    );

    game_logic u_game (
        .clk          (clk_100mhz),
        .rst          (rst),
        .start        (start),
        .p1_ldr_edge  (p1_ldr_edge),
        .p2_ldr_edge  (p2_ldr_edge),
        .led_out      (led_out_wire),
        .p1_score     (p1_score),
        .p2_score     (p2_score),
        .p1_reaction  (p1_reaction),
        .p2_reaction  (p2_reaction),
        .round_num    (round_num),
        .p1_round_wins(p1_round_wins),
        .p2_round_wins(p2_round_wins),
        .game_over    (game_over),
        .p1_wins      (p1_wins)
    );

    ldr_input u_ldr_p1 (
        .clk       (clk_100mhz),
        .rst       (rst),
        .raw_in    (p1_ldr),
        .clean_out (p1_ldr_clean),
        .edge_out  (p1_ldr_edge)
    );

    ldr_input u_ldr_p2 (
        .clk       (clk_100mhz),
        .rst       (rst),
        .raw_in    (p2_ldr),
        .clean_out (p2_ldr_clean),
        .edge_out  (p2_ldr_edge)
    );

endmodule
