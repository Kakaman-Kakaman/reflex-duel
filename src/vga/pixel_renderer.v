module pixel_renderer (
    input  wire        clk,
    input  wire        active,
    input  wire [10:0] pixel_x,
    input  wire [9:0]  pixel_y,

    input  wire [3:0]  p1_score,
    input  wire [3:0]  p2_score,
    input  wire [9:0]  p1_reaction,
    input  wire [9:0]  p2_reaction,
    input  wire [1:0]  round_num,
    input  wire [1:0]  p1_round_wins,
    input  wire [1:0]  p2_round_wins,
    input  wire        game_over,
    input  wire        p1_wins,

    output reg  [3:0]  vga_r,
    output reg  [3:0]  vga_g,
    output reg  [3:0]  vga_b
);

    localparam [11:0]
        COL_BLACK     = 12'h000,
        COL_WHITE     = 12'hFFF,
        COL_P1_BG     = 12'h002,
        COL_P2_BG     = 12'h200,
        COL_P1_TEXT   = 12'h4AF,
        COL_P2_TEXT   = 12'hF64,
        COL_SCORE     = 12'hFFF,
        COL_REACT     = 12'hAA8,
        COL_TOPBAR    = 12'h111,
        COL_DIVIDER   = 12'h444,
        COL_WIN_DOT   = 12'hFF0,
        COL_EMPTY_DOT = 12'h444,
        COL_GO_BG     = 12'h000,
        COL_GO_TEXT   = 12'hFF0;

    localparam CHAR_0=0, CHAR_1=1, CHAR_2=2, CHAR_3=3, CHAR_4=4,
               CHAR_5=5, CHAR_6=6, CHAR_7=7, CHAR_8=8, CHAR_9=9,
               CHAR_P=10, CHAR_L=11, CHAR_A=12, CHAR_Y=13, CHAR_E=14,
               CHAR_R=15, CHAR_W=16, CHAR_I=17, CHAR_N=18, CHAR_S=19,
               CHAR_G=20, CHAR_M=21, CHAR_O=22, CHAR_V=23, CHAR_T=24,
               CHAR_C=25, CHAR_COLON=26, CHAR_SPACE=27, CHAR_B=28,
               CHAR_F=29;

    reg [7:0] font [0:29][0:7];

    initial begin
        font[0][0]=8'b00111100; font[0][1]=8'b01100110;
        font[0][2]=8'b01101110; font[0][3]=8'b01110110;
        font[0][4]=8'b01100110; font[0][5]=8'b01100110;
        font[0][6]=8'b00111100; font[0][7]=8'b00000000;

        font[1][0]=8'b00011000; font[1][1]=8'b00111000;
        font[1][2]=8'b00011000; font[1][3]=8'b00011000;
        font[1][4]=8'b00011000; font[1][5]=8'b00011000;
        font[1][6]=8'b01111110; font[1][7]=8'b00000000;

        font[2][0]=8'b00111100; font[2][1]=8'b01100110;
        font[2][2]=8'b00000110; font[2][3]=8'b00001100;
        font[2][4]=8'b00011000; font[2][5]=8'b00110000;
        font[2][6]=8'b01111110; font[2][7]=8'b00000000;

        font[3][0]=8'b00111100; font[3][1]=8'b01100110;
        font[3][2]=8'b00000110; font[3][3]=8'b00011100;
        font[3][4]=8'b00000110; font[3][5]=8'b01100110;
        font[3][6]=8'b00111100; font[3][7]=8'b00000000;

        font[4][0]=8'b00001100; font[4][1]=8'b00011100;
        font[4][2]=8'b00101100; font[4][3]=8'b01001100;
        font[4][4]=8'b01111110; font[4][5]=8'b00001100;
        font[4][6]=8'b00001100; font[4][7]=8'b00000000;

        font[5][0]=8'b01111110; font[5][1]=8'b01100000;
        font[5][2]=8'b01111100; font[5][3]=8'b00000110;
        font[5][4]=8'b00000110; font[5][5]=8'b01100110;
        font[5][6]=8'b00111100; font[5][7]=8'b00000000;

        font[6][0]=8'b00111100; font[6][1]=8'b01100000;
        font[6][2]=8'b01111100; font[6][3]=8'b01100110;
        font[6][4]=8'b01100110; font[6][5]=8'b01100110;
        font[6][6]=8'b00111100; font[6][7]=8'b00000000;

        font[7][0]=8'b01111110; font[7][1]=8'b00000110;
        font[7][2]=8'b00001100; font[7][3]=8'b00011000;
        font[7][4]=8'b00011000; font[7][5]=8'b00011000;
        font[7][6]=8'b00011000; font[7][7]=8'b00000000;

        font[8][0]=8'b00111100; font[8][1]=8'b01100110;
        font[8][2]=8'b01100110; font[8][3]=8'b00111100;
        font[8][4]=8'b01100110; font[8][5]=8'b01100110;
        font[8][6]=8'b00111100; font[8][7]=8'b00000000;

        font[9][0]=8'b00111100; font[9][1]=8'b01100110;
        font[9][2]=8'b01100110; font[9][3]=8'b00111110;
        font[9][4]=8'b00000110; font[9][5]=8'b01100110;
        font[9][6]=8'b00111100; font[9][7]=8'b00000000;

        font[10][0]=8'b01111100; font[10][1]=8'b01100110;
        font[10][2]=8'b01100110; font[10][3]=8'b01111100;
        font[10][4]=8'b01100000; font[10][5]=8'b01100000;
        font[10][6]=8'b01100000; font[10][7]=8'b00000000;

        font[11][0]=8'b01100000; font[11][1]=8'b01100000;
        font[11][2]=8'b01100000; font[11][3]=8'b01100000;
        font[11][4]=8'b01100000; font[11][5]=8'b01100000;
        font[11][6]=8'b01111110; font[11][7]=8'b00000000;

        font[12][0]=8'b00011000; font[12][1]=8'b00111100;
        font[12][2]=8'b01100110; font[12][3]=8'b01100110;
        font[12][4]=8'b01111110; font[12][5]=8'b01100110;
        font[12][6]=8'b01100110; font[12][7]=8'b00000000;

        font[13][0]=8'b01100110; font[13][1]=8'b01100110;
        font[13][2]=8'b01100110; font[13][3]=8'b00111100;
        font[13][4]=8'b00011000; font[13][5]=8'b00011000;
        font[13][6]=8'b00011000; font[13][7]=8'b00000000;

        font[14][0]=8'b01111110; font[14][1]=8'b01100000;
        font[14][2]=8'b01100000; font[14][3]=8'b01111100;
        font[14][4]=8'b01100000; font[14][5]=8'b01100000;
        font[14][6]=8'b01111110; font[14][7]=8'b00000000;

        font[15][0]=8'b01111100; font[15][1]=8'b01100110;
        font[15][2]=8'b01100110; font[15][3]=8'b01111100;
        font[15][4]=8'b01101100; font[15][5]=8'b01100110;
        font[15][6]=8'b01100110; font[15][7]=8'b00000000;

        font[16][0]=8'b01100110; font[16][1]=8'b01100110;
        font[16][2]=8'b01100110; font[16][3]=8'b01010110;
        font[16][4]=8'b01010110; font[16][5]=8'b00111110;
        font[16][6]=8'b00100110; font[16][7]=8'b00000000;

        font[17][0]=8'b00111100; font[17][1]=8'b00011000;
        font[17][2]=8'b00011000; font[17][3]=8'b00011000;
        font[17][4]=8'b00011000; font[17][5]=8'b00011000;
        font[17][6]=8'b00111100; font[17][7]=8'b00000000;

        font[18][0]=8'b01100110; font[18][1]=8'b01110110;
        font[18][2]=8'b01110110; font[18][3]=8'b01101110;
        font[18][4]=8'b01101110; font[18][5]=8'b01100110;
        font[18][6]=8'b01100110; font[18][7]=8'b00000000;

        font[19][0]=8'b00111100; font[19][1]=8'b01100110;
        font[19][2]=8'b01100000; font[19][3]=8'b00111100;
        font[19][4]=8'b00000110; font[19][5]=8'b01100110;
        font[19][6]=8'b00111100; font[19][7]=8'b00000000;

        font[20][0]=8'b00111100; font[20][1]=8'b01100110;
        font[20][2]=8'b01100000; font[20][3]=8'b01101110;
        font[20][4]=8'b01100110; font[20][5]=8'b01100110;
        font[20][6]=8'b00111100; font[20][7]=8'b00000000;

        font[21][0]=8'b01000010; font[21][1]=8'b11100111;
        font[21][2]=8'b11111111; font[21][3]=8'b11011011;
        font[21][4]=8'b11000011; font[21][5]=8'b11000011;
        font[21][6]=8'b11000011; font[21][7]=8'b00000000;

        font[22][0]=8'b00111100; font[22][1]=8'b01100110;
        font[22][2]=8'b01100110; font[22][3]=8'b01100110;
        font[22][4]=8'b01100110; font[22][5]=8'b01100110;
        font[22][6]=8'b00111100; font[22][7]=8'b00000000;

        font[23][0]=8'b01100110; font[23][1]=8'b01100110;
        font[23][2]=8'b01100110; font[23][3]=8'b01100110;
        font[23][4]=8'b01100110; font[23][5]=8'b00111100;
        font[23][6]=8'b00011000; font[23][7]=8'b00000000;

        font[24][0]=8'b01111110; font[24][1]=8'b00011000;
        font[24][2]=8'b00011000; font[24][3]=8'b00011000;
        font[24][4]=8'b00011000; font[24][5]=8'b00011000;
        font[24][6]=8'b00011000; font[24][7]=8'b00000000;

        font[25][0]=8'b00111100; font[25][1]=8'b01100110;
        font[25][2]=8'b01100000; font[25][3]=8'b01100000;
        font[25][4]=8'b01100000; font[25][5]=8'b01100110;
        font[25][6]=8'b00111100; font[25][7]=8'b00000000;

        font[26][0]=8'b00000000; font[26][1]=8'b00011000;
        font[26][2]=8'b00011000; font[26][3]=8'b00000000;
        font[26][4]=8'b00000000; font[26][5]=8'b00011000;
        font[26][6]=8'b00011000; font[26][7]=8'b00000000;

        font[27][0]=8'b00000000; font[27][1]=8'b00000000;
        font[27][2]=8'b00000000; font[27][3]=8'b00000000;
        font[27][4]=8'b00000000; font[27][5]=8'b00000000;
        font[27][6]=8'b00000000; font[27][7]=8'b00000000;

        font[28][0]=8'b01111100; font[28][1]=8'b01100110;
        font[28][2]=8'b01100110; font[28][3]=8'b01111100;
        font[28][4]=8'b01100110; font[28][5]=8'b01100110;
        font[28][6]=8'b01111100; font[28][7]=8'b00000000;

        font[29][0]=8'b01111110; font[29][1]=8'b01100000;
        font[29][2]=8'b01100000; font[29][3]=8'b01111100;
        font[29][4]=8'b01100000; font[29][5]=8'b01100000;
        font[29][6]=8'b01100000; font[29][7]=8'b00000000;
    end

    function get_font_pixel;
        input [4:0] char_id;
        input [2:0] row;
        input [2:0] col;
        begin
            get_font_pixel = font[char_id][row][7 - col];
        end
    endfunction

    localparam SCALE = 4;

    function is_char_pixel;
        input [4:0]  char_id;
        input [10:0] x0;
        input [9:0]  y0;
        input [10:0] px;
        input [9:0]  py;
        reg   [10:0] lx;
        reg   [9:0]  ly;
        reg   [2:0]  fx, fy;
        begin
            lx = px - x0;
            ly = py - y0;
            if (lx < (8*SCALE) && ly < (8*SCALE)) begin
                fx = lx[4:2];
                fy = ly[4:2];
                is_char_pixel = get_font_pixel(char_id, fy, fx);
            end else begin
                is_char_pixel = 0;
            end
        end
    endfunction

    wire [3:0] p1_r_h, p1_r_t, p1_r_u;
    wire [3:0] p2_r_h, p2_r_t, p2_r_u;

    assign p1_r_h = p1_reaction / 100;
    assign p1_r_t = (p1_reaction % 100) / 10;
    assign p1_r_u = p1_reaction % 10;
    assign p2_r_h = p2_reaction / 100;
    assign p2_r_t = (p2_reaction % 100) / 10;
    assign p2_r_u = p2_reaction % 10;

    wire [3:0] round_digit;
    assign round_digit = (round_num == 2'd1) ? 4'd1 :
                         (round_num == 2'd2) ? 4'd2 : 4'd3;

    reg [11:0] colour;

    always @(*) begin
        colour = COL_BLACK;

        if (!active) begin
            vga_r = 4'h0; vga_g = 4'h0; vga_b = 4'h0;
        end else begin

            if (game_over) begin
                colour = COL_GO_BG;
                if (is_char_pixel(CHAR_P, 11'd160, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_L, 11'd192, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_A, 11'd224, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_Y, 11'd256, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_E, 11'd288, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_R, 11'd320, 10'd180, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (p1_wins) begin
                    if (is_char_pixel(CHAR_1, 11'd384, 10'd180, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                end else begin
                    if (is_char_pixel(CHAR_2, 11'd384, 10'd180, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                end
                if (is_char_pixel(CHAR_W, 11'd160, 10'd240, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_I, 11'd192, 10'd240, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_N, 11'd224, 10'd240, pixel_x, pixel_y)) colour = COL_GO_TEXT;
                if (is_char_pixel(CHAR_S, 11'd256, 10'd240, pixel_x, pixel_y)) colour = COL_GO_TEXT;

            end else begin

                if (pixel_y < 40) begin
                    colour = COL_TOPBAR;
                    if (is_char_pixel(CHAR_R, 11'd10,  10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_O, 11'd42,  10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_N, 11'd74,  10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(round_digit[3:0], 11'd150, 10'd4, pixel_x, pixel_y)) colour = COL_WIN_DOT;
                    if (is_char_pixel(CHAR_B, 11'd340, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_E, 11'd372, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_S, 11'd404, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_T, 11'd436, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_O, 11'd484, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_F, 11'd516, 10'd4, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_3, 11'd564, 10'd4, pixel_x, pixel_y)) colour = COL_WIN_DOT;

                end else if (pixel_x >= 11'd398 && pixel_x <= 11'd401) begin
                    colour = COL_DIVIDER;

                end else if (pixel_x < 11'd398) begin
                    colour = COL_P1_BG;
                    if (is_char_pixel(CHAR_P, 11'd80,  10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_L, 11'd112, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_A, 11'd144, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_Y, 11'd176, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_E, 11'd208, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_R, 11'd240, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(CHAR_1, 11'd288, 10'd50, pixel_x, pixel_y)) colour = COL_P1_TEXT;
                    if (is_char_pixel(p1_score[3:0], 11'd176, 10'd150, pixel_x, pixel_y)) colour = COL_SCORE;
                    if (is_char_pixel(CHAR_R, 11'd48,  10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_E, 11'd80,  10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_A, 11'd112, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_C, 11'd144, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_T, 11'd176, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_I, 11'd208, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_O, 11'd240, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_N, 11'd272, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_COLON, 11'd304, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(p1_r_h, 11'd128, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(p1_r_t, 11'd160, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(p1_r_u, 11'd192, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_M, 11'd232, 10'd330, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_S, 11'd264, 10'd330, pixel_x, pixel_y)) colour = COL_REACT;
                    if (pixel_x >= 11'd128 && pixel_x <= 11'd144 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = (p1_round_wins >= 1) ? COL_WIN_DOT : COL_EMPTY_DOT;
                    if (pixel_x >= 11'd164 && pixel_x <= 11'd180 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = (p1_round_wins >= 2) ? COL_WIN_DOT : COL_EMPTY_DOT;
                    if (pixel_x >= 11'd200 && pixel_x <= 11'd216 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = COL_EMPTY_DOT;

                end else begin
                    colour = COL_P2_BG;
                    if (is_char_pixel(CHAR_P, 11'd480, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_L, 11'd512, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_A, 11'd544, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_Y, 11'd576, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_E, 11'd608, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_R, 11'd640, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(CHAR_2, 11'd688, 10'd50, pixel_x, pixel_y)) colour = COL_P2_TEXT;
                    if (is_char_pixel(p2_score[3:0], 11'd576, 10'd150, pixel_x, pixel_y)) colour = COL_SCORE;
                    if (is_char_pixel(CHAR_R, 11'd448, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_E, 11'd480, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_A, 11'd512, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_C, 11'd544, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_T, 11'd576, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_I, 11'd608, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_O, 11'd640, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_N, 11'd672, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_COLON, 11'd704, 10'd280, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(p2_r_h, 11'd528, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(p2_r_t, 11'd560, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(p2_r_u, 11'd592, 10'd330, pixel_x, pixel_y)) colour = COL_WHITE;
                    if (is_char_pixel(CHAR_M, 11'd632, 10'd330, pixel_x, pixel_y)) colour = COL_REACT;
                    if (is_char_pixel(CHAR_S, 11'd664, 10'd330, pixel_x, pixel_y)) colour = COL_REACT;
                    if (pixel_x >= 11'd528 && pixel_x <= 11'd544 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = (p2_round_wins >= 1) ? COL_WIN_DOT : COL_EMPTY_DOT;
                    if (pixel_x >= 11'd564 && pixel_x <= 11'd580 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = (p2_round_wins >= 2) ? COL_WIN_DOT : COL_EMPTY_DOT;
                    if (pixel_x >= 11'd600 && pixel_x <= 11'd616 && pixel_y >= 10'd440 && pixel_y <= 10'd456)
                        colour = COL_EMPTY_DOT;
                end
            end

            vga_r = colour[11:8];
            vga_g = colour[7:4];
            vga_b = colour[3:0];
        end
    end

endmodule