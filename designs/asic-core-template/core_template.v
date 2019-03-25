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
// File Name : core_template.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-23 21:05:15 +0100 (Sat, 23 Mar 2019) $
// $Revision: 437 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"
`include "cache_define.vh"
`include "paths.vh"

`include "configdef.vh"

module core_template
#(
    `include "configval.vh"
)(

    // common
    input wire                                      rstn /*verilator clock_enable */,   // master reset, resets all but the debug unit
    input wire                                      clk /*verilator sc_clock*/,         // core clock
    input wire                                      apb_clk /*verilator sc_clock*/,     // APB clock
    input wire                                      dma_clk /*verilator sc_clock*/,     // DMA clock
    input wire                                      scan_enable,                        // DFT scan enable
    input wire                                      test_mode,                          // DFT test mode

    // debug
    input wire                                      dbg_rx,
    input wire                                      dbg_rstn,                           // resets debug unit
    input wire                                      dbg_en,                             // enable debug unit
    output wire                                     dbg_tx,
    output wire                                     dbg_mode,                           // indicates if processor is in debug mode or read/write mode
    output wire                                     dbg_term,                           // indicates stop of program execution (syscall instruction)
    output wire                                     dbg_oe,
    input wire                                      dbg_break,                          // enter debug mode

    // JTAG
    input wire                                      TCK,                                // JTAG interface
    input wire                                      TMS,
    input wire                                      TDI,
    output wire                                     RTCK,
    output wire                                     RTCK_oe,
    output wire                                     TDO,
    output wire                                     TDO_oe,
    output wire                                     BS_CLK_RISE,
    output wire                                     BS_CLK_FALL,
    input wire                                      BS_TDI,
    output wire                                     BS_EXTEST,
    output wire                                     BS_HIGHZ,
    output wire                                     BS_SHIFT,
    output wire                                     BS_CAPTURE,
    output wire                                     BS_UPDATE,
    output wire                                     BS_SELECT,

    // pwd
    output wire                                     proc_reset_request,     // indicates that core should be reset
    output wire                                     deep_reset_request,     // indicates that core should be deep reset

    // IRQ
    input wire  [CFG_EXT_IRQ_NUM-1:0]               irq,                    // interrupt input

    // AMBA

    // INST AHB-LITE MASTER
    output wire                                     INST_HSEL,
    output wire [`WIDTH-1:0]                        INST_HADDR,
    output wire [2:0]                               INST_HBURST,
    output wire                                     INST_HMASTLOCK,
    output wire [3:0]                               INST_HPROT,
    output wire [2:0]                               INST_HSIZE,
    output wire [1:0]                               INST_HTRANS,
    output wire [`WIDTH-1:0]                        INST_HWDATA,
    output wire                                     INST_HWRITE,
    input wire  [`WIDTH-1:0]                        INST_HRDATA,
    input wire                                      INST_HREADY,
    input wire                                      INST_HRESP,

    // DATA AHB-LITE MASTER
    output wire                                     DATA_HSEL,
    output wire [`WIDTH-1:0]                        DATA_HADDR,
    output wire [2:0]                               DATA_HBURST,
    output wire                                     DATA_HMASTLOCK,
    output wire [3:0]                               DATA_HPROT,
    output wire [2:0]                               DATA_HSIZE,
    output wire [1:0]                               DATA_HTRANS,
    output wire [`WIDTH-1:0]                        DATA_HWDATA,
    output wire                                     DATA_HWRITE,
    input wire  [`WIDTH-1:0]                        DATA_HRDATA,
    input wire                                      DATA_HREADY,
    input wire                                      DATA_HRESP,

    // APB MASTER
    input wire                                      PREADY,
    output wire                                     PENABLE,
    output wire [`WIDTH-1:0]                        PADDR,
    output wire                                     PWRITE,
    output wire [`WIDTH-1:0]                        PWDATA,
    input wire  [`WIDTH-1:0]                        PRDATA,
    input wire                                      PSLVERR,
    output wire                                     PSEL,

    // DMA AHB SLAVE
    input wire                                      DMA_HSEL,
    input wire    [`WIDTH-1:0]                      DMA_HADDR,
    input wire                                      DMA_HWRITE,
    input wire    [1:0]                             DMA_HTRANS,
    input wire    [2:0]                             DMA_HSIZE,
    input wire    [2:0]                             DMA_HBURST,
    input wire    [`WIDTH-1:0]                      DMA_HWDATA,
    input wire                                      DMA_HREADY_in,
    input wire    [3:0]                             DMA_HPROT,
    input wire    [3:0]                             DMA_HMASTER,
    input wire                                      DMA_HMASTLOCK,
    output wire                                     DMA_HREADY_out,
    output wire   [1:0]                             DMA_HRESP,
    output wire   [`WIDTH-1:0]                      DMA_HRDATA,
    output wire   [15:0]                            DMA_HSPLIT,

    output wire                                     debug_amba_stall_req,
    input wire                                      debug_amba_stall_ack,

    // WATCHDOG
    input wire                                      wdt_reset_request       // indicates reset caused by watchdog

);

// -----------------------------------------------------------------------------
// local variables
// -----------------------------------------------------------------------------

genvar gi;

// -----------------------------------------------------------------------------
// includes
// -----------------------------------------------------------------------------

`include "pack_unpack_inout.vh"

`include `WIRE_CORE_IN
`include `WIRE_CORE_OUT
`include `WIRE_CORE_JTAG_IN
`include `WIRE_CORE_JTAG_OUT
`include `WIRE_CORE_REGFILE_IN
`include `WIRE_CORE_REGFILE_OUT
`include `WIRE_CORE_ROM_IN
`include `WIRE_CORE_ROM_OUT
`include `WIRE_CORE_RAM_IN
`include `WIRE_CORE_RAM_OUT
`include `WIRE_CORE_PRAM_IN
`include `WIRE_CORE_PRAM_OUT
`include `WIRE_CORE_ICMEM_IN
`include `WIRE_CORE_ICMEM_OUT
`include `WIRE_CORE_ICTAG_IN
`include `WIRE_CORE_ICTAG_OUT
`include `WIRE_CORE_DCMEM_IN
`include `WIRE_CORE_DCMEM_OUT
`include `WIRE_CORE_DCTAG_IN
`include `WIRE_CORE_DCTAG_OUT
`include `WIRE_CORE_AMBA_IN
`include `WIRE_CORE_AMBA_OUT
`include `WIRE_CORE_GNSS_IN
`include `WIRE_CORE_GNSS_OUT
`include `WIRE_DUMMY

// -----------------------------------------------------------------------------
// processor wires
// -----------------------------------------------------------------------------

`include "processor_wires.vh"

// -----------------------------------------------------------------------------
// processor assigns
// -----------------------------------------------------------------------------

`include "processor_arrays_core.vh"

// -----------------------------------------------------------------------------
// assigns from core
// -----------------------------------------------------------------------------

`include "processor_from_core_core.vh"

// -----------------------------------------------------------------------------
// assigns to core
// -----------------------------------------------------------------------------

`include "processor_to_core_core.vh"

// -----------------------------------------------------------------------------
// assigns to core design specific
// -----------------------------------------------------------------------------

generate
if (1) begin : assign_gen_to_core

    assign  debug_rx                = dbg_rx;
    assign  debug_rstn_in           = dbg_rstn;
    assign  debug_en                = dbg_en;
    assign  debug_break             = dbg_break;
    assign  debug_rlock             = 1'b0;

    assign  gnss_clk_l1             = 1'b0;
    assign  gnss_input_l1           = 8'd0;
    assign  gnss_clk_l2             = 1'b0;
    assign  gnss_input_l2           = 8'd0;
    assign  gnss_clk_l5             = 1'b0;
    assign  gnss_input_l5           = 8'd0;

    assign  interrupt               = irq;

    assign  dbg_amba_stall_ack      = debug_amba_stall_ack;

    assign  mbist_ext_ack           = 1'b0;
    assign  mbist_ext_error         = 1'b0;

end
endgenerate

// -----------------------------------------------------------------------------
// processor core
// -----------------------------------------------------------------------------

processor_core #(
    `include "configinst.vh"
)
processor_core_u (
    `include `SIM_COMMON_IN
    `include `SIM_SCAN_IN
    `include `SIM_CORE_IN
    `include `SIM_CORE_OUT
    `include `SIM_CORE_JTAG_IN
    `include `SIM_CORE_JTAG_OUT
    `include `SIM_CORE_REGFILE_IN
    `include `SIM_CORE_REGFILE_OUT
    `include `SIM_CORE_ROM_IN
    `include `SIM_CORE_ROM_OUT
    `include `SIM_CORE_RAM_IN
    `include `SIM_CORE_RAM_OUT
    `include `SIM_CORE_PRAM_IN
    `include `SIM_CORE_PRAM_OUT
    `include `SIM_CORE_ICMEM_IN
    `include `SIM_CORE_ICMEM_OUT
    `include `SIM_CORE_ICTAG_IN
    `include `SIM_CORE_ICTAG_OUT
    `include `SIM_CORE_DCMEM_IN
    `include `SIM_CORE_DCMEM_OUT
    `include `SIM_CORE_DCTAG_IN
    `include `SIM_CORE_DCTAG_OUT
    `include `SIM_CORE_AMBA_IN
    `include `SIM_CORE_AMBA_OUT
    `include `SIM_CORE_GNSS_IN
    `include `SIM_CORE_GNSS_OUT
    `include `SIM_DUMMY
);

assign boot_data = {`WIDTH{1'b0}};

generate

// -----------------------------------------------------------------------------
// bootloader clock
// -----------------------------------------------------------------------------

    assign  boot_clk = 1'b0;

// -----------------------------------------------------------------------------
// integer unit register file
// -----------------------------------------------------------------------------

    for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : regfile_memory_iu

        regfile_mem_generic #(
            .WIDTH(`WIDTH),
            .AWIDTH(`AWIDTH))
        regfile_memory_iu (
            .clk(iuclk[gi]),
            .raddr1(unpacked_regfile_iu_rsaddr[gi]),
            .raddr2(unpacked_regfile_iu_rtaddr[gi]),
            .waddr(unpacked_regfile_iu_waddr[gi]),
            .wdata(unpacked_regfile_iu_wdata[gi]),
            .write(regfile_iu_we[gi]),
            .rdata1(unpacked_regfile_iu_rdata1[gi]),
            .rdata2(unpacked_regfile_iu_rdata2[gi]),
            .renable(regfile_iu_ren[gi]));

    end

// -----------------------------------------------------------------------------
// floating point unit register file
// -----------------------------------------------------------------------------

    for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : regfile_memory_fpu
        if (CFG_FPU_EN == 1) begin : regfile_fp

            regfile_mem_generic #(
                .WIDTH(`WIDTH),
                .AWIDTH(`AWIDTH))
            regfile_memory_fpu (
                .clk(iuclk[gi]),
                .raddr1(unpacked_regfile_fp_fsaddr[gi]),
                .raddr2(unpacked_regfile_fp_ftaddr[gi]),
                .waddr(unpacked_regfile_fp_waddr[gi]),
                .wdata(unpacked_regfile_fp_wdata[gi]),
                .write(regfile_fp_we[gi]),
                .rdata1(unpacked_regfile_fp_rdata1[gi]),
                .rdata2(unpacked_regfile_fp_rdata2[gi]),
                .renable(regfile_fp_ren[gi]));

            end else begin : no_regfile_memory_fpu
                assign    unpacked_regfile_fp_rdata1[gi] = {`WIDTH{1'b0}};
                assign    unpacked_regfile_fp_rdata2[gi] = {`WIDTH{1'b0}};
            end

        end

// -----------------------------------------------------------------------------
// instruction cache memory
// -----------------------------------------------------------------------------

    if (CFG_ICACHE_EN == 1) begin : icache_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : icache_memory

            ic_cache_mem_sim #(
                .SIZE(CFG_ICACHE_SIZE),
                .SETS(CFG_ICACHE_WAY))
            icache_memory (
                .clk(iuclk[gi]),
                .ren(ic_ren[gi]),
                .we(unpacked_ic_we[gi]),
                .addr(unpacked_ic_address[gi]),
                .din(unpacked_ic_din[gi]),
                .dout(unpacked_icmemrdata[gi]));

            ic_tag_mem_sim #(
                .SETS(CFG_ICACHE_WAY),
                .WIDTH(`TAG_ITAG_S),
                .UTIL(CFG_ICACHE_LRR+1),
                .AWIDTH(`ADD_IC_S-`ADD_ILINE_S))
            ictag_memory (
                .clk(iuclk[gi]),
                .addr(unpacked_ictagaddress[gi]),
                .rdata(unpacked_ictagrdata[gi]),
                .wdata(ictagwdata),
                .write(unpacked_ictagwrite[gi]),
                .ren(ictagren[gi]));

        end
    end else begin : no_icache_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : unpacked_icmemrdata_gen
            assign  unpacked_icmemrdata[gi] = {CFG_ICACHE_WAY*`WIDTH{1'b0}};
            assign  unpacked_ictagrdata[gi] = {CFG_ICACHE_WAY*(`TAG_ITAG_S+CFG_ICACHE_LRR+1){1'b0}};
        end
    end

// -----------------------------------------------------------------------------
// data cache memory
// -----------------------------------------------------------------------------

    if ((CFG_DCACHE_EN == 1) && (CFG_DCACHE_IMPL != 2)) begin : dcache_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : dcache_memory

            dc_cache_mem_sim #(
                .SIZE(CFG_DCACHE_SIZE),
                .SETS(CFG_DCACHE_WAY))
            dcache_memory (
                .clk(iuclk[gi]),
                .ren(dc_ren[gi]),
                .we(unpacked_dc_we[gi]),
                .addr(unpacked_dc_address[gi]),
                .din(unpacked_dc_din[gi]),
                .dout(unpacked_dcmemrdata[gi]));

            dc_tag_mem_sim #(
                .SETS(CFG_DCACHE_WAY),
                .WIDTH(`TAG_DTAG_S+CFG_DCACHE_LRR+1),
                .AWIDTH(`ADD_DC_S-`ADD_DLINE_S))
             dctag_memory (
                 .clk(iuclk[gi]),
                 .addra(unpacked_dctagaddressa[gi]),
                 .rdataa(unpacked_dctagrdataa[gi]),
                 .addrb(unpacked_dctagaddressb[gi]),
                 .wdataa(unpacked_dctagwdataa[gi]),
                 .wdatab(unpacked_dctagwdatab[gi]),
                 .rdatab(unpacked_dctagrdatab[gi]),
                 .writea(unpacked_dctagwritea[gi]),
                 .writeb(unpacked_dctagwriteb[gi]),
                 .rena(dctagrena[gi]),
                 .renb(dctagrenb[gi]));

        end
    end else begin : no_dcache_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : unpacked_dcmemrdata_gen
            assign  unpacked_dcmemrdata[gi]  = {CFG_DCACHE_WAY*`WIDTH{1'b0}};
            assign  unpacked_dctagrdataa[gi] = {CFG_DCACHE_WAY*(`TAG_DTAG_S+CFG_DCACHE_LRR+2){1'b0}};
            assign  unpacked_dctagrdatab[gi] = {CFG_DCACHE_WAY*(`TAG_DTAG_S+CFG_DCACHE_LRR+2){1'b0}};
        end
    end

// -----------------------------------------------------------------------------
// scratch-pad ram memory
// -----------------------------------------------------------------------------

    if (CFG_PMEM_EN == 1) begin : pram_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : pram_memory

            assign    unpacked_pram_fft_rdata[gi] = {`WIDTH{1'b0}};

            ram_mem_sim #(
                .SIZE(CFG_PMEM_SIZE))
            pram_memory (
                .clk(iuclk[gi]),
                .ren(pram_ren[gi]),
                .we(unpacked_pram_we[gi]),
                .addr(unpacked_pram_address[gi]),
                .din(unpacked_pram_din[gi]),
                .dout(unpacked_pram_rdata[gi]));

        end
    end else begin : no_pram_memory
        for (gi = 0; gi < CFG_CORE_NUM; gi = gi + 1) begin : pram_memory
            assign    unpacked_pram_rdata[gi]     = {`WIDTH{1'b0}};
            assign    unpacked_pram_fft_rdata[gi] = {`WIDTH{1'b0}};
        end
    end

endgenerate

// -----------------------------------------------------------------------------
// amba apb port
// -----------------------------------------------------------------------------

amba_apb_port
amba_apb_port_u (
    .rstn(rstn),
    .amba_clk(apb_clk),
    .amba_load(amba_arb_load),
    .amba_store(amba_arb_store),
    .amba_address(amba_arb_address),
    .amba_wdata(amba_arb_wdata),
    .amba_rdata(amba_arb_rdata),
    .amba_error(amba_arb_error),
    .amba_ack(amba_arb_ack),
    .PREADY(PREADY),
    .PENABLE(PENABLE),
    .PADDR(PADDR),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PRDATA(PRDATA),
    .PSLVERR(PSLVERR),
    .PSEL(PSEL));

// -----------------------------------------------------------------------------
// amba ahb instruction port
// -----------------------------------------------------------------------------

amba_ahb_data_port #(
    .INST_HPROT({CFG_ICACHE_EN[0],3'b010}),
    .DATA_HPROT({CFG_DCACHE_EN[0],3'b011}))
amba_ahb_inst_port_u (
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
    .HRESP(INST_HRESP),
    .inst_access(rom_inst_access),
    .burst_access(rom_burst_access),
    .ren(rom_ren),
    .we(rom_we),
    .last(rom_last),
    .addr(rom_address),
    .din(rom_din),
    .dout(rom_data),
    .nstall(rom_nstall),
    .wrapper(rom_wrapper),
    .error(rom_error));

// -----------------------------------------------------------------------------
// amba ahb data port
// -----------------------------------------------------------------------------

amba_ahb_data_port #(
    .DATA_HPROT({CFG_DCACHE_EN[0],3'b011}))
amba_ahb_data_port_u (
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
    .HRESP(DATA_HRESP),
    .burst_access(ram_burst_access),
    .inst_access(1'b0),
    .ren(ram_ren),
    .we(ram_we),
    .last(ram_last),
    .addr(ram_address),
    .din(ram_din),
    .dout(ram_rdata),
    .nstall(ram_nstall),
    .wrapper(ram_wrapper),
    .error(ram_error));

// -----------------------------------------------------------------------------
// amba ahb dma port
// -----------------------------------------------------------------------------

amba_ahb_slave_dma_port
amba_ahb_slave_dma_port_u(
    .HCLK(dma_clk),
    .HRESETn(rstn),
    .HSEL(DMA_HSEL),
    .HADDR(DMA_HADDR),
    .HWRITE(DMA_HWRITE),
    .HTRANS(DMA_HTRANS),
    .HSIZE(DMA_HSIZE),
    .HBURST(DMA_HBURST),
    .HWDATA(DMA_HWDATA),
    .HREADY_in(DMA_HREADY_in),
    .HPROT(DMA_HPROT),
    .HMASTER(DMA_HMASTER),
    .HMASTLOCK(DMA_HMASTLOCK),
    .HREADY_out(DMA_HREADY_out),
    .HRESP(DMA_HRESP),
    .HRDATA(DMA_HRDATA),
    .HSPLIT(DMA_HSPLIT),
    .dma_clk(dma_clk),
    .dma_load(dma_load[0]),
    .dma_store(dma_store[0]),
    .dma_burst_req(dma_burst_req[0]),
    .dma_burst_type(dma_burst_type[0]),
    .dma_address(dma_address[0]),
    .dma_wdata(dma_wdata[0]),
    .dma_rdata(dma_rdata[0]),
    .dma_nstall(dma_ndstall[0]),
    .dma_error(dma_error[0]),
    .dma_burst_aack(dma_burst_aack[0]),
    .dma_burst_dack(dma_burst_dack[0]),
    .dma_arbiter_grant(1'b1),
    .dma_arbiter_req());

// -----------------------------------------------------------------------------
// misc assigns
// -----------------------------------------------------------------------------

generate
    if (1) begin : assign_gen_misc
        assign    cmem_rdata        = {CFG_CORE_NUM*`WIDTH{1'b0}};
        assign    dummy             = 1'b0;
    end
endgenerate

endmodule
