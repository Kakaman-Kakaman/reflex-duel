module game_logic (
    input  wire        clk,
    input  wire        rst,
    input  wire        start,
    input  wire [8:0]  p1_ldr,
    input  wire [8:0]  p2_ldr,

    output reg  [8:0]  led_out,
    output reg  [3:0]  p1_score,
    output reg  [3:0]  p2_score,
    output reg  [9:0]  p1_reaction,
    output reg  [9:0]  p2_reaction,
    output reg  [1:0]  round_num,
    output reg  [1:0]  p1_round_wins,
    output reg  [1:0]  p2_round_wins,
    output reg         game_over,
    output reg         p1_wins
);

    // =========================================================================
    // State encoding
    // =========================================================================
    localparam IDLE         = 3'd0;
    localparam COUNTDOWN    = 3'd1;
    localparam SELECT_LED   = 3'd2;
    localparam ARMED        = 3'd3;
    localparam HIT_DETECTED = 3'd4;
    localparam ROUND_DONE   = 3'd5;
    localparam GAME_OVER    = 3'd6;

    reg [2:0] state, next_state;

    // =========================================================================
    // LFSR - 9-bit for random LED selection (1-9)
    // =========================================================================
    reg [8:0] lfsr;
    wire      lfsr_feedback = lfsr[8] ^ lfsr[4];

    always @(posedge clk or posedge rst) begin
        if (rst) lfsr <= 9'b101010101;
        else     lfsr <= {lfsr[7:0], lfsr_feedback};
    end

    // Map LFSR to LED index 0-8
    wire [3:0] led_index = lfsr[3:0] % 9;

    // =========================================================================
    // Countdown timer - 3 seconds at 100MHz = 300,000,000 cycles
    // =========================================================================
    localparam COUNTDOWN_MAX = 300_000_000;
    reg [28:0] countdown_timer;

    // =========================================================================
    // Reaction timer - counts ms (100,000 cycles per ms at 100MHz)
    // =========================================================================
    localparam MS_TICKS = 100_000;
    reg [16:0] ms_tick_counter;
    reg [9:0]  reaction_timer;
    reg        timer_running;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ms_tick_counter <= 0;
            reaction_timer  <= 0;
        end else if (timer_running) begin
            if (ms_tick_counter == MS_TICKS - 1) begin
                ms_tick_counter <= 0;
                if (reaction_timer < 999)
                    reaction_timer <= reaction_timer + 1;
            end else begin
                ms_tick_counter <= ms_tick_counter + 1;
            end
        end else begin
            ms_tick_counter <= 0;
            reaction_timer  <= 0;
        end
    end

    // =========================================================================
    // Hit detection - LDR goes LOW when covered (light blocked)
    // =========================================================================
    wire p1_hit = ~p1_ldr[led_index];
    wire p2_hit = ~p2_ldr[led_index];

    // =========================================================================
    // Round done timer - show result for 2 seconds
    // =========================================================================
    localparam ROUND_DONE_MAX = 200_000_000;
    reg [27:0] round_done_timer;

    // =========================================================================
    // FSM state register
    // =========================================================================
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state          <= IDLE;
            countdown_timer <= 0;
            round_done_timer<= 0;
            led_out        <= 9'b0;
            p1_score       <= 0;
            p2_score       <= 0;
            p1_reaction    <= 0;
            p2_reaction    <= 0;
            round_num      <= 2'd1;
            p1_round_wins  <= 0;
            p2_round_wins  <= 0;
            game_over      <= 0;
            p1_wins        <= 0;
            timer_running  <= 0;
        end else begin
            case (state)

                IDLE: begin
                    led_out       <= 9'b0;
                    timer_running <= 0;
                    if (start)
                        state <= COUNTDOWN;
                end

                COUNTDOWN: begin
                    led_out <= 9'b0;
                    if (countdown_timer == COUNTDOWN_MAX - 1) begin
                        countdown_timer <= 0;
                        state <= SELECT_LED;
                    end else begin
                        countdown_timer <= countdown_timer + 1;
                    end
                end

                SELECT_LED: begin
                    // Light up the selected LED on both arrays
                    led_out       <= (9'b1 << led_index);
                    timer_running <= 1;
                    state         <= ARMED;
                end

                ARMED: begin
                    if (p1_hit && !p2_hit) begin
                        // P1 wins this point
                        p1_score    <= p1_score + 1;
                        p1_reaction <= reaction_timer;
                        timer_running <= 0;
                        led_out     <= 9'b0;
                        state       <= HIT_DETECTED;
                    end else if (p2_hit && !p1_hit) begin
                        // P2 wins this point
                        p2_score    <= p2_score + 1;
                        p2_reaction <= reaction_timer;
                        timer_running <= 0;
                        led_out     <= 9'b0;
                        state       <= HIT_DETECTED;
                    end else if (p1_hit && p2_hit) begin
                        // Simultaneous - no point, redo
                        timer_running <= 0;
                        led_out     <= 9'b0;
                        state       <= COUNTDOWN;
                    end
                end

                HIT_DETECTED: begin
                    // Check if anyone has won the round (first to 3 points)
                    if (p1_score >= 3) begin
                        p1_round_wins <= p1_round_wins + 1;
                        p1_score      <= 0;
                        p2_score      <= 0;
                        state         <= ROUND_DONE;
                    end else if (p2_score >= 3) begin
                        p2_round_wins <= p2_round_wins + 1;
                        p1_score      <= 0;
                        p2_score      <= 0;
                        state         <= ROUND_DONE;
                    end else begin
                        state <= COUNTDOWN;
                    end
                end

                ROUND_DONE: begin
                    if (round_done_timer == ROUND_DONE_MAX - 1) begin
                        round_done_timer <= 0;
                        // Check if anyone won the match (best of 3)
                        if (p1_round_wins >= 2) begin
                            p1_wins   <= 1;
                            game_over <= 1;
                            state     <= GAME_OVER;
                        end else if (p2_round_wins >= 2) begin
                            p1_wins   <= 0;
                            game_over <= 1;
                            state     <= GAME_OVER;
                        end else begin
                            round_num <= round_num + 1;
                            state     <= COUNTDOWN;
                        end
                    end else begin
                        round_done_timer <= round_done_timer + 1;
                    end
                end

                GAME_OVER: begin
                    // Stay here until reset
                    led_out <= 9'b0;
                end

            endcase
        end
    end

endmodule