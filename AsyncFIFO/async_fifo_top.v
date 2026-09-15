module async_fifo_top (
    input        wr_clk,
    input        rd_clk,

    input        wr_reset,
    input        rd_reset,

    input        wr_en,
    input        rd_en,

    input  [7:0] data_in,
    output [7:0] data_out,

    output       full,
    output       empty
);

    // Write-side signals
    wire [3:0] wr_bin;
    wire [3:0] wr_gray;
    wire [2:0] wr_addr;

    // Read-side signals
    wire [3:0] rd_bin;
    wire [3:0] rd_gray;
    wire [2:0] rd_addr;

    // Synchronized pointer signals
    wire [3:0] wr_gray_sync;
    wire [3:0] rd_gray_sync;


    //==================================================
    // WRITE CONTROLLER
    //==================================================
    write_controller WC (
        .wr_clk       (wr_clk),
        .wr_reset     (wr_reset),
        .wr_en        (wr_en),
        .rd_gray_sync (rd_gray_sync),

        .wr_bin       (wr_bin),
        .wr_gray      (wr_gray),
        .wr_addr      (wr_addr),
        .full         (full)
    );


    //==================================================
    // READ CONTROLLER
    //==================================================
    read_controller RC (
        .rd_clk       (rd_clk),
        .rd_reset     (rd_reset),
        .rd_en        (rd_en),
        .wr_gray_sync (wr_gray_sync),

        .rd_bin       (rd_bin),
        .rd_gray      (rd_gray),
        .rd_addr      (rd_addr),
        .empty        (empty)
    );


    //==================================================
    // WRITE-TO-READ SYNCHRONIZER
    //==================================================
    sync_w2r SW2R (
        .rd_clk       (rd_clk),
        .rd_reset     (rd_reset),
        .wr_gray      (wr_gray),

        .wr_gray_sync (wr_gray_sync)
    );


    //==================================================
    // READ-TO-WRITE SYNCHRONIZER
    //==================================================
    sync_r2w SR2W (
        .wr_clk       (wr_clk),
        .wr_reset     (wr_reset),
        .rd_gray      (rd_gray),

        .rd_gray_sync (rd_gray_sync)
    );


    //==================================================
    // FIFO MEMORY
    //==================================================
    fifo_memory MEM (
        .wr_clk   (wr_clk),
        .wr_en    (wr_en && !full),
        .wr_addr  (wr_addr),
        .data_in  (data_in),

        .rd_clk   (rd_clk),
        .rd_en    (rd_en && !empty),
        .rd_addr  (rd_addr),
        .data_out (data_out)
    );

endmodule