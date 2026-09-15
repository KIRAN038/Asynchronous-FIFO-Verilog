module sync_w2r (
    input        rd_clk,
    input        rd_reset,
    input  [3:0] wr_gray,

    output reg [3:0] wr_gray_sync
);

    reg [3:0] sync_ff1;

    always @(posedge rd_clk or posedge rd_reset)
    begin
        if (rd_reset)
        begin
            sync_ff1     <= 4'b0000;
            wr_gray_sync <= 4'b0000;
        end
        else
        begin
            sync_ff1     <= wr_gray;
            wr_gray_sync <= sync_ff1;
        end
    end

endmodule