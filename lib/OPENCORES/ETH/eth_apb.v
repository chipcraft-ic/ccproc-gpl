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
// File Name : eth_apb.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-11-07 21:33:20 +0100 (Wed, 07 Nov 2018) $
// $Revision: 315 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"

module eth_apb
#(
    parameter [31:0] TARGET_ASIC = 32'd0,
    parameter [31:0] TARGET_FPGA = 32'd0,
    parameter [31:0] DFT_MEM     = 32'd0
)(

    input wire                  PCLK,
    input wire                  PCLKon,
    input wire                  PRESETn,
    input wire                  PSEL,
    input wire                  PENABLE,
    input wire    [11:2]        PADDR,
    input wire                  PWRITE,
    input wire    [`WIDTH-1:0]  PWDATA,
    output wire                 PREADY,
    output wire   [`WIDTH-1:0]  PRDATA,
    output wire                 PSLVERR,

    input wire    [`WIDTH-1:0]  DAT_I,
    output wire   [`WIDTH-1:0]  ADR_O,
    output wire   [3:0]         SEL_O,
    output wire   [2:0]         CTI_O,
    output wire   [1:0]         BTE_O,
    output wire                 CYC_O,
    output wire                 LOCK_O,
    output wire                 STB_O,
    output wire                 WE_O,
    output wire   [`WIDTH-1:0]  DAT_O,
    input wire                  ACK_I,
    input wire                  RTY_I,
    input wire                  ERR_I,

    // Tx
    input wire                  mtx_clk_pad_i, // Transmit clock (from PHY)
    output wire   [3:0]         mtxd_pad_o,    // Transmit nibble (to PHY)
    output wire                 mtxen_pad_o,   // Transmit enable (to PHY)
    output wire                 mtxerr_pad_o,  // Transmit error (to PHY)

    // Rx
    input wire                  mrx_clk_pad_i, // Receive clock (from PHY)
    input wire    [3:0]         mrxd_pad_i,    // Receive nibble (from PHY)
    input wire                  mrxdv_pad_i,   // Receive data valid (from PHY)
    input wire                  mrxerr_pad_i,  // Receive data error (from PHY)

    // Common Tx and Rx
    input wire                  mcoll_pad_i,   // Collision (from PHY)
    input wire                  mcrs_pad_i,    // Carrier sense (from PHY)

    // MII Management Interface
    input wire                  md_pad_i,      // MII data input (from I/O cell)
    output wire                 mdc_pad_o,     // MII Management data clock (to PHY)
    output wire                 md_pad_o,      // MII data output (to I/O cell)
    output wire                 md_padoe_o,    // MII data output enable (to I/O cell)

    output wire                 irq,

    input wire                  test_mode
);

// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam    [31:0]  APB_BRIDGE    = 32'd1;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire                  PRESETn_synch;

wire                  S_ACK_I;
wire    [`WIDTH-1:0]  S_DAT_I;
wire                  S_ERR_I;
wire                  S_STB_O;
wire                  S_CYC_O;
wire                  S_WE_O;
wire    [9:0]         S_ADR_O;
wire    [3:0]         S_SEL_O;
wire    [`WIDTH-1:0]  S_DAT_O;

wire                  mirq;

// -----------------------------------------------------------------------------
// assign LOCK_O
// -----------------------------------------------------------------------------

assign LOCK_O       = 1'b0;

// -----------------------------------------------------------------------------
// reset generator
// -----------------------------------------------------------------------------

rstgen #(
    .WIDTH(3),
    .TARGET_ASIC(TARGET_ASIC),
    .TARGET_FPGA(TARGET_FPGA))
rstgen_eth (
    .clk(PCLKon),
    .rstn(PRESETn),
    .test_mode(test_mode),
    .in(1'b1),
    .out(PRESETn_synch));

// -----------------------------------------------------------------------------
// register interrupt
// -----------------------------------------------------------------------------

dffnr0    #(.N(1))   dff_eth_irq    (.clk(PCLK),.Q(irq),.D(mirq),.rstn(PRESETn_synch));

// -----------------------------------------------------------------------------
// wishbone<->apb bridge
// -----------------------------------------------------------------------------

amba_apb_wishbone_bridge #(
    .DATA_WIDTH(`WIDTH),
    .ADDR_WIDTH(10))
amba_apb_wishbone_bridge_u (
    .PCLK(PCLK),
    .PRESETn(PRESETn_synch),
    .PADDR(PADDR),
    .PSEL(PSEL),
    .PENABLE(PENABLE),
    .PWRITE(PWRITE),
    .PWDATA(PWDATA),
    .PSLVERR(PSLVERR),
    .PRDATA(PRDATA),
    .PREADY(PREADY),
    .ACK_I(S_ACK_I),
    .DAT_I(S_DAT_I),
    .ERR_I(S_ERR_I),
    .STB_O(S_STB_O),
    .CYC_O(S_CYC_O),
    .WE_O(S_WE_O),
    .ADR_O(S_ADR_O),
    .SEL_O(S_SEL_O),
    .DAT_O(S_DAT_O));

// -----------------------------------------------------------------------------
// ethernet MAC layer
// -----------------------------------------------------------------------------

ethmac #(
    .DFT_MEM(DFT_MEM),
    .TARGET_FPGA(TARGET_FPGA),
    .TARGET_ASIC(TARGET_ASIC))
ethmac_u (
    .wb_clk_i(PCLK),
    .wb_rst_i(~PRESETn_synch),
    .wb_dat_i(S_DAT_O),
    .wb_dat_o(S_DAT_I),
    .wb_adr_i(S_ADR_O),
    .wb_sel_i(S_SEL_O),
    .wb_we_i(S_WE_O),
    .wb_cyc_i(S_CYC_O),
    .wb_stb_i(S_STB_O),
    .wb_ack_o(S_ACK_I),
    .wb_err_o(S_ERR_I), 
    .m_wb_adr_o(ADR_O),
    .m_wb_sel_o(SEL_O),
    .m_wb_we_o(WE_O),
    .m_wb_dat_o(DAT_O),
    .m_wb_dat_i(DAT_I),
    .m_wb_cyc_o(CYC_O),
    .m_wb_stb_o(STB_O),
    .m_wb_ack_i(ACK_I),
    .m_wb_err_i(ERR_I),
    .m_wb_cti_o(CTI_O),
    .m_wb_bte_o(BTE_O),
    .mtx_clk_pad_i(mtx_clk_pad_i),
    .mtxd_pad_o(mtxd_pad_o),
    .mtxen_pad_o(mtxen_pad_o),
    .mtxerr_pad_o(mtxerr_pad_o),
    .mrx_clk_pad_i(mrx_clk_pad_i),
    .mrxd_pad_i(mrxd_pad_i),
    .mrxdv_pad_i(mrxdv_pad_i),
    .mrxerr_pad_i(mrxerr_pad_i),
    .mcoll_pad_i(mcoll_pad_i),
    .mcrs_pad_i(mcrs_pad_i),
    .mdc_pad_o(mdc_pad_o),
    .md_pad_i(md_pad_i),
    .md_pad_o(md_pad_o),
    .md_padoe_o(md_padoe_o),
    .test_mode(test_mode),
    .int_o(mirq));

endmodule
