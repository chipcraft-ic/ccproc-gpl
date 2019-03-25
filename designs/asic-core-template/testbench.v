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
// File Name : testbench.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-23 21:05:15 +0100 (Sat, 23 Mar 2019) $
// $Revision: 437 $
// -FHDR------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// global includes
// -----------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"
`include "paths.vh"

// -----------------------------------------------------------------------------
// global defines
// -----------------------------------------------------------------------------

`include "UART_defines.v"

`define SYST_NAME "core_template processor system"

module testbench
#(
    `include "configval.vh"
)(
`ifdef VERILATOR_COMPILATION

    input wire                                  rstn,
    input wire                                  clk,

    input wire                                  uart_request,
    input wire    [7:0]                         uart_data,
    output wire                                 uart_ack,

    input wire                                  dbg_request,
    input wire    [7:0]                         dbg_data,
    output wire                                 dbg_ack,

    output wire                                 dbg_term

`endif
);

// -----------------------------------------------------------------------------
// includes
// -----------------------------------------------------------------------------

`include "pack_unpack_inout.vh"

// -----------------------------------------------------------------------------
// local variables
// -----------------------------------------------------------------------------

`ifndef VERILATOR_COMPILATION
    wire                    rstn;
    wire                    clk;
`endif

wire                        dma_clk;
wire                        apb_clk;
wire                        scan_enable  = 1'b0;
wire                        test_mode    = 1'b0;

wire                        proc_reset_request;
wire                        deep_reset_request;

wire                        wdt_reset_request = 1'b0;

// debug
`ifndef VERILATOR_COMPILATION
    wire                    dbg_term;
`endif
wire                        dbg_rx;
wire                        dbg_en = 1'b1;
wire                        dbg_tx;
wire                        dbg_mode;
wire                        dbg_rstn;
wire                        dbg_oe;
wire                        dbg_break = 1'b0;

wire                        debug_amba_stall_req;
wire                        debug_amba_stall_ack = 1'b1;

// JTAG
wire                        TCK;
wire                        TMS;
wire                        TDI;
wire                        RTCK;
wire                        RTCK_oe;
wire                        TDO;
wire                        TDO_oe;

wire                        BS_CLK_RISE;
wire                        BS_CLK_FALL;
wire                        BS_TDI;
wire                        BS_EXTEST;
wire                        BS_HIGHZ;
wire                        BS_SHIFT;
wire                        BS_CAPTURE;
wire                        BS_UPDATE;
wire                        BS_SELECT;

// APB
wire                        PREADY;
wire                        PENABLE;
wire    [`WIDTH-1:0]        PADDR;
wire                        PWRITE;
wire    [`WIDTH-1:0]        PWDATA;
wire    [`WIDTH-1:0]        PRDATA;
wire                        PSEL;
wire                        PSLVERR = 1'b0;

// INST AHB-LITE
wire                        INST_HSEL;
wire    [`WIDTH-1:0]        INST_HADDR;
wire    [2:0]               INST_HBURST;
wire                        INST_HMASTLOCK;
wire    [3:0]               INST_HPROT;
wire    [2:0]               INST_HSIZE;
wire    [1:0]               INST_HTRANS;
wire    [`WIDTH-1:0]        INST_HWDATA;
wire                        INST_HWRITE;
wire    [`WIDTH-1:0]        INST_HRDATA;
wire                        INST_HREADY;
wire                        INST_HRESP;

// DATA AHB-LITE
wire                        DATA_HSEL;
wire    [`WIDTH-1:0]        DATA_HADDR;
wire    [2:0]               DATA_HBURST;
wire                        DATA_HMASTLOCK;
wire    [3:0]               DATA_HPROT;
wire    [2:0]               DATA_HSIZE;
wire    [1:0]               DATA_HTRANS;
wire    [`WIDTH-1:0]        DATA_HWDATA;
wire                        DATA_HWRITE;
wire    [`WIDTH-1:0]        DATA_HRDATA;
wire                        DATA_HREADY;
wire                        DATA_HRESP;

// DMA AHB
wire                        DMA_HSEL;
wire    [`WIDTH-1:0]        DMA_HADDR;
wire                        DMA_HWRITE;
wire    [1:0]               DMA_HTRANS;
wire    [2:0]               DMA_HSIZE;
wire    [2:0]               DMA_HBURST;
wire    [`WIDTH-1:0]        DMA_HWDATA;
wire                        DMA_HREADY_in;
wire    [3:0]               DMA_HPROT;
wire    [3:0]               DMA_HMASTER;
wire                        DMA_HMASTLOCK;
wire                        DMA_HREADY_out;
wire    [1:0]               DMA_HRESP;
wire    [`WIDTH-1:0]        DMA_HRDATA;
wire    [15:0]              DMA_HSPLIT;

// UART
wire                        RX;
wire                        TX;
wire                        TX_oe;
wire                        RTS;
wire                        RTS_oe;
wire                        CTS = 1'b0;
wire    [8:0]               uart_irq;
wire    [15:0]              uart_mantisa;
wire    [3:0]               uart_fraction;
wire                        uart_clk;
wire                        uart_clk_x16;

`ifndef VERILATOR_COMPILATION

// -----------------------------------------------------------------------------
// reset and clock generator
// -----------------------------------------------------------------------------

core_template_clock #(
    .SYST_NAME(`SYST_NAME))
generator_u (
    .rstn(rstn),
    .clk(clk),
    .apb_clk(apb_clk),
    .dma_clk(dma_clk));

`else

    assign apb_clk = clk;
    assign dma_clk = clk;

`endif

// -----------------------------------------------------------------------------
// core template
// -----------------------------------------------------------------------------

core_template
core_template_u (
    .rstn(rstn),
    .clk(clk),
    .apb_clk(apb_clk),
    .dma_clk(dma_clk),
    .scan_enable(scan_enable),
    .test_mode(test_mode),
    .dbg_rx(dbg_rx),
    .dbg_tx(dbg_tx),
    .dbg_en(dbg_en),
    .dbg_oe(dbg_oe),
    .dbg_term(dbg_term),
    .dbg_mode(dbg_mode),
    .dbg_break(dbg_break),
    .dbg_rstn(rstn),
    .TCK(TCK),
    .TMS(TMS),
    .TDI(TDI),
    .RTCK(RTCK),
    .RTCK_oe(RTCK_oe),
    .TDO(TDO),
    .TDO_oe(TDO_oe),
    .BS_CLK_RISE(BS_CLK_RISE),
    .BS_CLK_FALL(BS_CLK_FALL),
    .BS_TDI(BS_TDI),
    .BS_EXTEST(BS_EXTEST),
    .BS_HIGHZ(BS_HIGHZ),
    .BS_SHIFT(BS_SHIFT),
    .BS_CAPTURE(BS_CAPTURE),
    .BS_UPDATE(BS_UPDATE),
    .BS_SELECT(BS_SELECT),
    .proc_reset_request(proc_reset_request),
    .deep_reset_request(deep_reset_request),
    .irq({{14{1'b0}},|uart_irq}),
    .DMA_HSEL(DMA_HSEL),
    .DMA_HADDR(DMA_HADDR),
    .DMA_HWRITE(DMA_HWRITE),
    .DMA_HTRANS(DMA_HTRANS),
    .DMA_HSIZE(DMA_HSIZE),
    .DMA_HBURST(DMA_HBURST),
    .DMA_HWDATA(DMA_HWDATA),
    .DMA_HREADY_in(DMA_HREADY_in),
    .DMA_HPROT(DMA_HPROT),
    .DMA_HMASTER(DMA_HMASTER),
    .DMA_HMASTLOCK(DMA_HMASTLOCK),
    .DMA_HREADY_out(DMA_HREADY_out),
    .DMA_HRESP(DMA_HRESP),
    .DMA_HRDATA(DMA_HRDATA),
    .DMA_HSPLIT(DMA_HSPLIT),
    .PREADY(PREADY),
    .PENABLE(PENABLE),
    .PADDR(PADDR),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PSEL(PSEL),
    .PSLVERR(PSLVERR),
    .INST_HSEL(INST_HSEL),
    .INST_HADDR(INST_HADDR),
    .INST_HBURST(INST_HBURST),
    .INST_HMASTLOCK(INST_HMASTLOCK),
    .INST_HPROT(INST_HPROT),
    .INST_HSIZE(INST_HSIZE),
    .INST_HTRANS(INST_HTRANS),
    .INST_HWDATA(INST_HWDATA),
    .INST_HWRITE(INST_HWRITE),
    .INST_HRDATA(INST_HRDATA),
    .INST_HREADY(INST_HREADY),
    .INST_HRESP(INST_HRESP),
    .DATA_HSEL(DATA_HSEL),
    .DATA_HADDR(DATA_HADDR),
    .DATA_HBURST(DATA_HBURST),
    .DATA_HMASTLOCK(DATA_HMASTLOCK),
    .DATA_HPROT(DATA_HPROT),
    .DATA_HSIZE(DATA_HSIZE),
    .DATA_HTRANS(DATA_HTRANS),
    .DATA_HWDATA(DATA_HWDATA),
    .DATA_HWRITE(DATA_HWRITE),
    .DATA_HRDATA(DATA_HRDATA),
    .DATA_HREADY(DATA_HREADY),
    .DATA_HRESP(DATA_HRESP),
    .debug_amba_stall_req(debug_amba_stall_req),
    .debug_amba_stall_ack(debug_amba_stall_ack),
    .wdt_reset_request(wdt_reset_request));

// -----------------------------------------------------------------------------
// ahb rom
// -----------------------------------------------------------------------------

amba_ahb_rom_sim #(
    .RAMCODE("mem.hex"),
    .ADDR_MASK(CFG_ROM_START<<28))
amba_ahb_rom_sim_u (
    .HCLK(clk),
    .HRESETn(rstn),
    .HSEL(INST_HSEL),
    .HADDR(INST_HADDR),
    .HBURST(INST_HBURST),
    .HMASTLOCK(INST_HMASTLOCK),
    .HPROT(INST_HPROT),
    .HSIZE(INST_HSIZE),
    .HTRANS(INST_HTRANS),
    .HWDATA(INST_HWDATA),
    .HWRITE(INST_HWRITE),
    .HRDATA(INST_HRDATA),
    .HREADY(INST_HREADY),
    .HRESP(INST_HRESP));

// -----------------------------------------------------------------------------
// ahb ram
// -----------------------------------------------------------------------------

amba_ahb_ram_sim #(
    .ADDR_MASK(CFG_RAM_START<<28))
amba_ahb_ram_sim_u (
    .HCLK(clk),
    .HRESETn(rstn),
    .HSEL(DATA_HSEL),
    .HADDR(DATA_HADDR),
    .HBURST(DATA_HBURST),
    .HMASTLOCK(DATA_HMASTLOCK),
    .HPROT(DATA_HPROT),
    .HSIZE(DATA_HSIZE),
    .HTRANS(DATA_HTRANS),
    .HWDATA(DATA_HWDATA),
    .HWRITE(DATA_HWRITE),
    .HRDATA(DATA_HRDATA),
    .HREADY(DATA_HREADY),
    .HRESP(DATA_HRESP));

// -----------------------------------------------------------------------------
// uart console
// -----------------------------------------------------------------------------

APB_UART #(
    .PDMA_support(0),
    .default_interrupt_MAPPING(1))
APB_UART_u (
    .PCLK(apb_clk),
    .PRESETn(rstn),
    .PSEL((PADDR[23:8]==(CFG_AUART_S[15:0]))?PSEL:1'b0),
    .PENABLE(PENABLE&(PADDR[23:8]==(CFG_AUART_S[15:0]))),
    .PADDR(PADDR[`UART_ADDRESS_WIDTH_DF+1:2]),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PREADY(PREADY),
    .PRDATA(PRDATA),
    .CTS_pad(CTS),
    .RX_pad(RX),
    .TX_pad(TX),
    .TX_pad_oe(TX_oe),
    .RTS_pad(RTS),
    .RTS_pad_oe(RTS_oe),
    .interrupt_RX_finished(uart_irq[0]),
    .interrupt_TX_finished(uart_irq[1]),
    .interrupt_TX_data_reg_empty(uart_irq[2]),
    .interrupt_PARITY_error(uart_irq[3]),
    .interrupt_FRAMING_error(uart_irq[4]),
    .interrupt_OVERRUN_error(uart_irq[5]),
    .interrupt_BREAK_receiving(uart_irq[6]),
    .interrupt_BREAK_ended(uart_irq[7]),
    .interrupt_CTS_falling_edge(uart_irq[8]),
    .interrupt_MAPPING(),
    .Downstream_enable(1'b0),
    .Downstream_busy(),
    .Downstream_request(),
    .Downstream_ack(1'b0),
    .Downstream_data(32'd0),
    .Upstream_enable(1'b0),
    .Upstream_busy(),
    .Upstream_request(),
    .Upstream_ack(1'b0),
    .Upstream_data(),
    .clock_request());

// -----------------------------------------------------------------------------
// uart receiver
// -----------------------------------------------------------------------------

assign    uart_mantisa    = APB_UART_u.uart.CFG_mantissa_reg;
assign    uart_fraction   = APB_UART_u.uart.CFG_fraction_reg;

uart_baudgen_sim
uart_baudgen_core (
    .clk(apb_clk),
    `ifdef VERILATOR_COMPILATION .rstn(1'b1), `else .rstn(rstn), `endif
    .mantisa(uart_mantisa),
    .fraction(uart_fraction),
    .uart_clk(uart_clk),
    .uart_clk_x16(uart_clk_x16));

`ifdef VERILATOR_COMPILATION
uart_receiver_sim #(
    .NO_OUTPUT(1),
`else
uart_receiver_sim #(
    .NO_OUTPUT(0),
`endif
    .CONSOLE_INDEX(2))
amba_ux_console (
    .rstn(rstn),
    .terminate(dbg_term),
    .uart_clk(uart_clk),
    .uart_clk_x16(uart_clk_x16),
    .rx_in(TX));

// -----------------------------------------------------------------------------
// debug interface
// -----------------------------------------------------------------------------

wire    [15:0]  dbg_mantisa;
wire    [3:0]   dbg_fraction;
wire            dbg_uart_clk;
wire            dbg_uart_clk_x16;

assign    dbg_mantisa     = core_template_u.processor_core_u.debug_unit.debug_core_module_u.baud_rate_generator_u.DIV_Mantissa;
assign    dbg_fraction    = core_template_u.processor_core_u.debug_unit.debug_core_module_u.baud_rate_generator_u.DIV_Fraction;

uart_baudgen_sim
uart_baudgen_dbg (
    .clk(clk),
    `ifdef VERILATOR_COMPILATION .rstn(1'b1), `else .rstn(rstn), `endif
    .mantisa(dbg_mantisa),
    .fraction(dbg_fraction),
    .uart_clk(dbg_uart_clk),
    .uart_clk_x16(dbg_uart_clk_x16));

`ifdef VERILATOR_COMPILATION

    uart_veri_receiver_sim
    dbg_u_console (
        .tx_empty(core_template_u.processor_core_u.debug_unit.debug_core_module_u.dbgw_tx_empty),
        .tx_reg(core_template_u.processor_core_u.debug_unit.debug_core_module_u.dbgw_tx_reg)
    );

    uart_veri_transmitter_sim
    dbg_send (
        .clk(clk),
        .request(dbg_request),
        .data(dbg_data),
        .ack(dbg_ack),
        .debug_busy(core_template_u.processor_core_u.debug_unit.debug_core_module_u.dbgw_rx_busy),
        .debug_data(core_template_u.processor_core_u.debug_unit.debug_core_module_u.dbgw_rx_data));

`else

core_template_dbg_test
dbg_test (
    .rstn(rstn),
    .uart_clk(dbg_uart_clk),
    .uart_clk_x16(dbg_uart_clk_x16),
    .tx_out(dbg_rx),
    .terminate(dbg_term),
    .rx_in(dbg_tx));

`endif

`ifdef VERILATOR_COMPILATION

// -----------------------------------------------------------------------------
// uart transmitter
// -----------------------------------------------------------------------------

    uart_tramsmiter_sim
    uart_send (
        .rstn(rstn),
        .uart_clk(~rstn?clk:uart_clk),
        .tx_out(RX),
        .request(uart_request),
        .ack(uart_ack),
        .data(uart_data));

`endif

// -----------------------------------------------------------------------------
// jtag interface
// -----------------------------------------------------------------------------

`ifndef VERILATOR_COMPILATION

core_template_jtag_test
jtag_test (
    .TCK(TCK),
    .RTCK(RTCK),
    .TMS(TMS),
    .TDI(TDI),
    .TDO(TDO_oe?TDO:1'bz));

`else
    assign TCK = 1'b0;
    assign TMS = 1'b0;
    assign TDI = 1'b0;
`endif

// -----------------------------------------------------------------------------
// ahb dma
// -----------------------------------------------------------------------------

assign    DMA_HSEL        = 1'b0;
assign    DMA_HADDR       = {`WIDTH{1'b0}};
assign    DMA_HWRITE      = 1'b0;
assign    DMA_HTRANS      = 2'd0;
assign    DMA_HSIZE       = 3'd0;
assign    DMA_HBURST      = 3'd0;
assign    DMA_HWDATA      = {`WIDTH{1'b0}};
assign    DMA_HREADY_out  = 1'b1;
assign    DMA_HPROT       = 4'd0;
assign    DMA_HMASTER     = 4'd0;
assign    DMA_HMASTLOCK   = 1'b0;

// -----------------------------------------------------------------------------
// simulation end
// -----------------------------------------------------------------------------
always @(posedge clk)
begin
    if ((CFG_STAT_EN == 0) && (CFG_DISASM_EN == 0)) begin
        if (dbg_term) begin
            `DEF_DEL_9 $display("%t Terminating simulation\n\n",$time);
            $finish;
        end
    end
end

`ifdef ICARUS_COMPILATION
`ifdef ICARUS_DUMP
initial
begin
    $dumpfile("testbench.vcd");
    $dumpvars(0,testbench);
end
`endif
`endif

endmodule
