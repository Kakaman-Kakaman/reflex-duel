module vga_controller (
    input  wire        clk_100mhz,
    input  wire        rst,
    output wire        hsync,
    output wire        vsync,
    output wire [10:0] pixel_x,
    output wire [9:0]  pixel_y,
    output wire        active
);

    // 50 MHz pixel clock
    reg pclk;
    always @(posedge clk_100mhz or posedge rst) begin
        if (rst) pclk <= 1'b0;
        else     pclk <= ~pclk;
    end

    // 800x600 @ 60Hz timing
    localparam H_ACTIVE      = 800;
    localparam H_FRONT_PORCH = 40;
    localparam H_SYNC_PULSE  = 128;
    localparam H_BACK_PORCH  = 88;
    localparam H_TOTAL       = 1056;

    localparam V_ACTIVE      = 600;
    localparam V_FRONT_PORCH = 1;
    localparam V_SYNC_PULSE  = 4;
    localparam V_BACK_PORCH  = 23;
    localparam V_TOTAL       = 628;

    reg [10:0] h_count;
    reg [9:0]  v_count;

    always @(posedge pclk or posedge rst) begin
        if (rst) begin
            h_count <= 11'd0;
            v_count <= 10'd0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 11'd0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 10'd0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    assign hsync = ~((h_count >= (H_ACTIVE + H_FRONT_PORCH)) &&
                     (h_count <  (H_ACTIVE + H_FRONT_PORCH + H_SYNC_PULSE)));
    assign vsync = ~((v_count >= (V_ACTIVE + V_FRONT_PORCH)) &&
                     (v_count <  (V_ACTIVE + V_FRONT_PORCH + V_SYNC_PULSE)));

    assign active  = (h_count < H_ACTIVE) && (v_count < V_ACTIVE);
    assign pixel_x = h_count;
    assign pixel_y = v_count;

endmodule