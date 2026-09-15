module fifo_memory (
    input        wr_clk,
    input        wr_en,
    input  [2:0] wr_addr,
    input  [7:0] data_in,

    input        rd_clk,
    input        rd_en,
    input  [2:0] rd_addr,
    output reg [7:0] data_out
);

    // 8 locations, each 8 bits wide
    reg [7:0] mem [0:7];

    // Write operation
    always @(posedge wr_clk)
    begin
        if (wr_en)
            mem[wr_addr] <= data_in;
    end

    // Read operation
    always @(posedge rd_clk)
    begin
        if (rd_en)
            data_out <= mem[rd_addr];
    end

endmodule