`timescale 1ns/1ps

module async_fifo_tb;

    // Clock and reset signals
    reg wr_clk;
    reg rd_clk;
    reg wr_reset;
    reg rd_reset;

    // FIFO control signals
    reg wr_en;
    reg rd_en;

    // Data signals
    reg  [7:0] data_in;
    wire [7:0] data_out;

    // FIFO status
    wire full;
    wire empty;


    //==================================================
    // DUT - Device Under Test
    //==================================================
    async_fifo_top DUT (
        .wr_clk   (wr_clk),
        .rd_clk   (rd_clk),

        .wr_reset (wr_reset),
        .rd_reset (rd_reset),

        .wr_en    (wr_en),
        .rd_en    (rd_en),

        .data_in  (data_in),
        .data_out (data_out),

        .full     (full),
        .empty    (empty)
    );


    //==================================================
    // WRITE CLOCK
    // Period = 10 ns
    //==================================================
    initial begin
        wr_clk = 1'b0;
        forever #5 wr_clk = ~wr_clk;
    end


    //==================================================
    // READ CLOCK
    // Period = 14 ns
    //==================================================
    initial begin
        rd_clk = 1'b0;
        forever #7 rd_clk = ~rd_clk;
    end


    //==================================================
    // WAVEFORM
    //==================================================
    initial begin
        $dumpfile("async_fifo.vcd");
        $dumpvars(0, async_fifo_tb);
    end


    //==================================================
    // TEST SEQUENCE
    //==================================================
    initial begin

        // Initial values
        wr_reset = 1'b1;
        rd_reset = 1'b1;

        wr_en = 1'b0;
        rd_en = 1'b0;

        data_in = 8'h00;


        // --------------------------------------------
        // RESET
        // --------------------------------------------
        #20;

        wr_reset = 1'b0;
        rd_reset = 1'b0;


        // --------------------------------------------
        // WRITE 8 DATA VALUES
        // --------------------------------------------

        @(negedge wr_clk);
        wr_en   = 1'b1;
        data_in = 8'h11;

        @(negedge wr_clk);
        data_in = 8'h22;

        @(negedge wr_clk);
        data_in = 8'h33;

        @(negedge wr_clk);
        data_in = 8'h44;

        @(negedge wr_clk);
        data_in = 8'h55;

        @(negedge wr_clk);
        data_in = 8'h66;

        @(negedge wr_clk);
        data_in = 8'h77;

        @(negedge wr_clk);
        data_in = 8'h88;

        @(negedge wr_clk);
        wr_en = 1'b0;


        // --------------------------------------------
        // WAIT FOR POINTER SYNCHRONIZATION
        // --------------------------------------------
        #50;


        // --------------------------------------------
        // READ 8 DATA VALUES
        // --------------------------------------------

        @(negedge rd_clk);
        rd_en = 1'b1;

        @(negedge rd_clk);
        @(negedge rd_clk);
        @(negedge rd_clk);
        @(negedge rd_clk);
        @(negedge rd_clk);
        @(negedge rd_clk);
        @(negedge rd_clk);

        @(negedge rd_clk);
        rd_en = 1'b0;


        // --------------------------------------------
        // WAIT
        // --------------------------------------------
        #30;

        $finish;

    end


    //==================================================
    // MONITOR
    //==================================================
    initial begin

        $monitor(
            "TIME=%0t | wr_clk=%b rd_clk=%b | wr_en=%b rd_en=%b | data_in=%h data_out=%h | FULL=%b EMPTY=%b",
            $time,
            wr_clk,
            rd_clk,
            wr_en,
            rd_en,
            data_in,
            data_out,
            full,
            empty
        );

    end

endmodule