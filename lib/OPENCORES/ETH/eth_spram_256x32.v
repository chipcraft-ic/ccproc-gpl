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
// File Name : eth_spram_256x32.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-11-22 09:50:57 +0100 (Thu, 22 Nov 2018) $
// $Revision: 324 $
// -FHDR------------------------------------------------------------------------

module eth_spram_256x32
#(
     parameter [31:0] DFT_MEM     = 32'd0,
     parameter [31:0] TARGET_FPGA = 32'd0,
     parameter [31:0] TARGET_ASIC = 32'd0
)(
    input wire           clk,
    input wire           rst,
    input wire           ce,
    input wire  [3:0]    we,
    input wire           oe,
    input wire  [7:0]    addr,
    input wire  [31:0]   di,
    output wire [31:0]   dato,
    input wire           test_mode
);

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire    [31:0]    dft_dato;
wire    [3:0]     dft_we;
wire              dft_ce;

// -----------------------------------------------------------------------------
// shadow logic
// -----------------------------------------------------------------------------

dftmem #(
    .DWIDTH(32),
    .CWIDTH(14),
    .DFT_MEM(DFT_MEM),
    .WE_WIDTH(4))
dftmem_u (
    .clk(clk),
    .data_mem_in(di),
    .data_mem_out(dft_dato),
    .ctrl_in({ce,we,oe,addr}),
    .test_mode(test_mode),
    .en(test_mode|ce),
    .data_out(dato),
    .re_in(ce),
    .re_out(dft_ce),
    .we_in(we),
    .we_out(dft_we));

generate
    if (TARGET_FPGA == 1) begin : virtex6

        // single port 1kB memory
        blk_sp_mem_1kB
        eth_bd_memory (
            .clka(clk),
            .ena(dft_ce),
            .wea(|dft_we),
            .addra(addr),
            .dina(di),
            .douta(dft_dato));

    end
    else if ((TARGET_ASIC == 0) && (TARGET_FPGA == 0)) begin : sim

        // simulation memory
        ram_mem_sim #(
            .SIZE(10))
        eth_bd_memory_sim (
            .clk(clk),
            .ren(dft_ce),
            .we(dft_we),
            .addr(addr),
            .din(di),
            .dout(dft_dato));

    end

// -----------------------------------------------------------------------------
// technology configuration sanity check
// -----------------------------------------------------------------------------

    else begin : memory_error
        `ifndef GATE
            initial begin
                $display("CONFIG_ERROR: Not supported eth_bd memory technology!\n");
                $finish;
            end
        `endif
    end
endgenerate

endmodule
