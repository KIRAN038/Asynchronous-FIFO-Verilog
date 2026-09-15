module write_controller (
    input        wr_clk,
    input        wr_reset,
    input        wr_en,

    // Read pointer synchronized into write clock domain
    input  [3:0] rd_gray_sync,

    // Write pointer outputs
    output reg [3:0] wr_bin,
    output reg [3:0] wr_gray,

    // Memory address
    output [2:0] wr_addr,

    // FIFO status
    output reg full
);

    // Next-state signals
    wire [3:0] wr_bin_next;
    wire [3:0] wr_gray_next;
    wire        full_next;

    // Write pointer moves only when:
    // wr_en = 1 AND FIFO is not full
    assign wr_bin_next = wr_bin + (wr_en && !full);

    // Binary to Gray conversion
    assign wr_gray_next = wr_bin_next ^ (wr_bin_next >> 1);

    // Lower 3 bits select one of the 8 memory locations
    assign wr_addr = wr_bin[2:0];

    // FIFO FULL detection
    // For an 8-depth FIFO, invert the upper two bits
    // of the synchronized read Gray pointer.
    assign full_next =
        (wr_gray_next ==
         {~rd_gray_sync[3:2], rd_gray_sync[1:0]});

    // Register write pointer and FULL flag
    always @(posedge wr_clk or posedge wr_reset)
    begin
        if (wr_reset)
        begin
            wr_bin  <= 4'b0000;
            wr_gray <= 4'b0000;
            full    <= 1'b0;
        end
        else
        begin
            wr_bin  <= wr_bin_next;
            wr_gray <= wr_gray_next;
            full    <= full_next;
        end
    end

endmodule