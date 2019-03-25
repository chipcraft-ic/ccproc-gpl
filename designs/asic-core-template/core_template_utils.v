// +FHDR------------------------------------------------------------------------
//
// Copyright (c) 2017 ChipCraft Sp. z o.o. All rights reserved
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, version 2.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program. If not, see <http://www.gnu.org/licenses/>
//
// -----------------------------------------------------------------------------
// File Name : core_template_utils.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-23 21:05:15 +0100 (Sat, 23 Mar 2019) $
// $Revision: 437 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"
`include "cache_define.vh"
`include "debug_define.vh"
`include "paths.vh"

`ifndef VERILATOR_COMPILATION



// -----------------------------------------------------------------------------
// core template clock generator
// -----------------------------------------------------------------------------

module core_template_clock
#(
    parameter SYST_NAME = "BLANK",
    `include "configval.vh"
)(
    output reg      rstn,
    output reg      clk,
    output wire     apb_clk,
    output wire     dma_clk
);

reg     [(20*8)-1:0]    name;
reg     [256*8:0]       syst_string;
integer                 log;

initial #0 begin
    $timeformat(-9,1," ns",6);
    name = "logs/cpuinfo.txt";
    log = $fopen(name,"w");

    clk  = 1'b0;
    rstn = 1'b0;

    $sformat(syst_string,SYST_NAME);

    `include  "coreinfo.inc"

    #300000 rstn = 1'b1;

    $fclose(log);

end

`include    "clkbase.inc"

dffnr0    #(.N(1))    dff_dma_clk(.clk(clk),.rstn(rstn),.Q(dma_clk),.D(~dma_clk));
dffnr0    #(.N(1))    dff_apb_clk(.clk(dma_clk),.rstn(rstn),.Q(apb_clk),.D(~apb_clk));

endmodule



// -----------------------------------------------------------------------------
// core template debug test
// -----------------------------------------------------------------------------

module core_template_dbg_test
#(
    `include "configval.vh"
)(

    input wire rstn,
    input wire uart_clk,
    input wire uart_clk_x16,
    input wire terminate,
    input wire rx_in,
    output wire tx_out
);

`include "uart_transmitter_sim.inc"
`include "debug_tasks.vh"

initial begin

    tx_break = 1'b1;

`ifdef DBG_TEST

    #2000000;
    $write("----------------------------\n");
    $write("-- SIMPLE DEBUG UART TEST --\n");
    $write("----------------------------\n");
    dbg_break_task();

    dbg_read_task(32'h30030000);
    dbg_read_task(32'h20000000);
    dbg_write_task(32'h20000000,32'h12345678);
    dbg_read_task(32'h20000000);
    dbg_read_task(32'h80000000);
    dbg_iu_context_write(1);
    dbg_read_task(32'h30030000);
    dbg_iu_context_write(2);
    dbg_read_task(32'h30030000);
    dbg_iu_context_write(0);

    dbg_write_task(32'h80000008,32'h1);
    dbg_read_task(32'h81000024);

    dbg_step_task();
    dbg_step_task();
    dbg_free_task();
    dbg_reset_task();

`else

`ifdef DBG_MBIST_TEST

    if (CFG_MBIST_EN == 0) begin
        $write("DEBUG_ERROR: No MBIST unit present");
        $finish;
    end

    #2000000;
    $write("----------------------------------\n");
    $write("-- SIMPLE DEBUG UART MBIST TEST --\n");
    $write("----------------------------------\n");
    dbg_break_task();

    dbg_mbist_task();
    //dbg_step_task();
    //dbg_step_task();
    //dbg_reset_task();
    //#20000000;
    $finish;

`else

    #1000000;

    forever begin
        dbg_wait_frame();
        dbg_step_task();
        dbg_step_task();
        dbg_free_task();
    end

`endif
`endif

end

uart_receiver_sim #(
    .NO_OUTPUT(1))
dbg_console (
    .rstn(rstn),
    .terminate(terminate),
    .uart_clk(uart_clk),
    .uart_clk_x16(uart_clk_x16),
    .rx_in(rx_in));

endmodule



// -----------------------------------------------------------------------------
// core template jtag test
// -----------------------------------------------------------------------------

module core_template_jtag_test
#(
     `include "configval.vh"
)(
    output reg TCK,
    input wire RTCK,
    output reg TMS,
    output reg TDI,
    input wire TDO
);

`include "pack_unpack_inout.vh"

integer i,j;

wire    [CFG_CORE_NUM*(`DUMP_BLOCK_DEF-1)*8-1:0]    packed_debug_status_reg;
wire    [7:0]                                       command_response;

reg     [4096:0]                                    read_data;
wire    [(`DUMP_BLOCK_DEF-1)*8-1:0]                 unpacked_debug_status_reg       [CFG_CORE_NUM-1:0];

reg     [7:0]    crc_8;
reg     [31:0]   crc_32;

assign    packed_debug_status_reg    = read_data[CFG_CORE_NUM*(`DUMP_BLOCK_DEF-1)*8-1:0];
assign    command_response           = read_data[7:0];

`UNPACK_ARRAY(pack_1,(`DUMP_BLOCK_DEF-1)*8,CFG_CORE_NUM,unpacked_debug_status_reg,packed_debug_status_reg)

`include "jtag_tasks.vh"

initial begin

    TCK = 0;
    TMS = 0;

    #20000;
    jtag_trst_task();

    #20000000;

`ifdef JTAG_TEST

    $write("----------------------------\n");
    $write("-- SIMPLE DEBUG JTAG TEST --\n");
    $write("----------------------------\n");
    jtag_break_task();

    jtag_read_id_task();
    jtag_read_task(32'h30030000);
    jtag_read_task(32'h20000000);
    jtag_write_task(32'h20000000,32'h12345678);
    jtag_read_task(32'h20000000);
    jtag_write_iu_context_task(1);
    jtag_read_task(32'h30030000);
    jtag_write_iu_context_task(2);
    jtag_read_task(32'h30030000);
    jtag_write_iu_context_task(0);
    jtag_step_task();
    jtag_step_task();
    jtag_free_task();

    #2000000;
    jtag_break_task();
    #2000000;
    jtag_reset_task();

`endif

end

endmodule



`else



// -----------------------------------------------------------------------------
// uart transmitter
// -----------------------------------------------------------------------------

module uart_tramsmiter_sim(
    input wire           rstn,
    input wire           uart_clk,
    input wire           request,
    input wire   [7:0]   data,
    output wire          ack,
    output reg           tx_out
);

wire                    wreq;

wire                    tx_req;

reg                     del_request;

reg     [7:0]           tx_reg;
reg                     tx_empty;
reg     [3:0]           tx_cnt;

assign  tx_req  = request & ~del_request;
assign  ack     = ~tx_empty;

always @(posedge uart_clk or negedge rstn)
begin
    if (!rstn) begin
        del_request <= 0;
    end else begin
        del_request <= request;
    end
end

always @(posedge uart_clk or negedge rstn)
begin
    if (!rstn) begin
        tx_reg <= 0;
        tx_empty <= 1;
        tx_out <= 1;
        tx_cnt <= 0;
    end else begin
        if ((tx_req == 1) || (tx_empty == 0)) begin
            if (tx_req) begin
                tx_reg <= data;
                tx_empty <= 0;
            end
            if (!tx_empty) begin
                tx_cnt <= tx_cnt + 1;
                if (tx_cnt == 0) begin
                    tx_out <= 0;
                end
                if (tx_cnt > 0 && tx_cnt < 9) begin
                    tx_out <= tx_reg[tx_cnt-1];
                end
                if (tx_cnt == 9) begin
                    tx_out <= 1;
                    tx_cnt <= 0;
                    tx_empty <= 1;
                end
            end
        end
    end
end

endmodule



// -----------------------------------------------------------------------------
// veri uart transmitter
// -----------------------------------------------------------------------------

module uart_veri_transmitter_sim(
    input wire           clk,
    input wire           request,
    input wire   [7:0]   data,
    output reg           ack,
    output reg           debug_busy,
    output reg   [7:0]   debug_data
);

reg [1:0]    ack_reg;

initial begin
    ack_reg = 2'd0;
    debug_busy = 1'b1;
end

always @(posedge clk)
begin
    debug_busy <= 1'b1;
    if (request && (ack_reg == 2'd0)) begin
        debug_data <= data;
        debug_busy <= 1'b0;
        ack_reg <= 2'd1;
    end
    if (ack_reg > 2'd0) begin
        ack_reg <= ack_reg + 2'd1;
        if (ack_reg == 2'd3) begin
            ack <= 1'b1;
        end
    end
    if(!request) begin
        ack_reg <= 2'b0;
        ack <= 1'b0;
    end
end

endmodule



// -----------------------------------------------------------------------------
// veri uart receiver
// -----------------------------------------------------------------------------

module uart_veri_receiver_sim(
    input wire           tx_empty,
    input wire    [7:0]  tx_reg
);

wire             rx_ready /*verilator public*/;
wire    [7:0]    rx_data  /*verilator public*/;

assign rx_ready   = ~tx_empty;
assign rx_data    = tx_reg;

endmodule

`endif