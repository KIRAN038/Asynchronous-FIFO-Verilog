module sync_r2w (
    input        wr_clk,
    input        wr_reset,
    input  [3:0] rd_gray,

    output reg [3:0] rd_gray_sync
);

    reg [3:0] sync_ff1;

    always @(posedge wr_clk or posedge wr_reset)
    begin
        if (wr_reset)
        begin
            sync_ff1     <= 4'b0000;
            rd_gray_sync <= 4'b0000;
        end
        else
        begin
            sync_ff1     <= rd_gray;
            rd_gray_sync <= sync_ff1;
        end
    end

endmodule