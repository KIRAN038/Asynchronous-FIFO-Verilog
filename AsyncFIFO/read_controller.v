module read_controller (
    input        rd_clk,
    input        rd_reset,
    input        rd_en,

    // Write pointer synchronized into read clock domain
    input  [3:0] wr_gray_sync,

    // Read pointer outputs
    output reg [3:0] rd_bin,
    output reg [3:0] rd_gray,

    // Memory address
    output [2:0] rd_addr,

    // FIFO status
    output reg empty
);

    // Next-state signals
    wire [3:0] rd_bin_next;
    wire [3:0] rd_gray_next;
    wire        empty_next;

    // Read pointer moves only when:
    // rd_en = 1 AND FIFO is not empty
    assign rd_bin_next = rd_bin + (rd_en && !empty);

    // Binary to Gray conversion
    assign rd_gray_next = rd_bin_next ^ (rd_bin_next >> 1);

    // Lower 3 bits select one of the 8 memory locations
    assign rd_addr = rd_bin[2:0];

    // FIFO EMPTY detection
    assign empty_next = (rd_gray_next == wr_gray_sync);

    // Register read pointer and EMPTY flag
    always @(posedge rd_clk or posedge rd_reset)
    begin
        if (rd_reset)
        begin
            rd_bin  <= 4'b0000;
            rd_gray <= 4'b0000;
            empty   <= 1'b1;
        end
        else
        begin
            rd_bin  <= rd_bin_next;
            rd_gray <= rd_gray_next;
            empty   <= empty_next;
        end
    end

endmodule