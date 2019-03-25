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
// File Name : eth_fifo_memory.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-11-22 09:50:57 +0100 (Thu, 22 Nov 2018) $
// $Revision: 324 $
// -FHDR------------------------------------------------------------------------

module eth_fifo_memory
#(
    parameter [31:0]    DATA_WIDTH    = 32'd32,
    parameter [31:0]    SIZE          = 32'd8,
    parameter [31:0]    DFT_MEM       = 32'd0,
    parameter [31:0]    TARGET_FPGA   = 32'd0,
    parameter [31:0]    TARGET_ASIC   = 32'd0
)(
    data_out,
    we,
    re,
    data_in,
    read_address,
    write_address,
    wclk,
    test_mode
);

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

output wire [DATA_WIDTH-1:0]    data_out;
input wire                      we;
input wire                      re;
input wire  [DATA_WIDTH-1:0]    data_in;
input wire  [SIZE-1:0]          read_address;
input wire  [SIZE-1:0]          write_address;
input wire                      wclk;
input wire                      test_mode;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire    [DATA_WIDTH-1:0]    dft_data_out;
wire                        dft_re;
wire                        dft_we;

// -----------------------------------------------------------------------------
// shadow logic
// -----------------------------------------------------------------------------

dftmem #(
    .DWIDTH(DATA_WIDTH),
    .CWIDTH(2*SIZE+2),
    .DFT_MEM(DFT_MEM),
    .WE_WIDTH(1))
dftmem_u (
    .clk(wclk),
    .data_mem_in(data_in),
    .data_mem_out(dft_data_out),
    .ctrl_in({we,re,read_address,write_address}),
    .test_mode(test_mode),
    .en(test_mode|re|we),
    .data_out(data_out),
    .re_in(re),
    .re_out(dft_re),
    .we_in(we),
    .we_out(dft_we));

generate
    if (TARGET_FPGA == 1) begin : virtex6

        if (SIZE == 6) begin
            // simple dual port 32bit 256B memory
            blk_dp_fifo_256B
            ram_memory (
                .clka(wclk),
                .wea(dft_we),
                .addra(write_address),
                .dina(data_in),
                .clkb(wclk),
                .enb(dft_re),
                .addrb(read_address),
                .doutb(dft_data_out));
        end
        else if (SIZE == 7) begin
            // simple dual port 32bit 512B memory
            blk_dp_fifo_512B
            ram_memory (
                .clka(wclk),
                .wea(dft_we),
                .addra(write_address),
                .dina(data_in),
                .clkb(wclk),
                .enb(dft_re),
                .addrb(read_address),
                .doutb(dft_data_out));
        end
        else if (SIZE == 8) begin
            // simple dual port 32bit 1kB memory
            blk_dp_fifo_1kB
            ram_memory (
                .clka(wclk),
                .wea(dft_we),
                .addra(write_address),
                .dina(data_in),
                .clkb(wclk),
                .enb(dft_re),
                .addrb(read_address),
                .doutb(dft_data_out));
        end
        else if (SIZE == 9) begin
            // simple dual port 32bit 2kB memory
            blk_dp_fifo_2kB
            ram_memory (
                .clka(wclk),
                .wea(dft_we),
                .addra(write_address),
                .dina(data_in),
                .clkb(wclk),
                .enb(dft_re),
                .addrb(read_address),
                .doutb(dft_data_out));
        end

// -----------------------------------------------------------------------------
// size configuration sanity check
// -----------------------------------------------------------------------------

        else begin
            `ifndef GATE
                initial begin
                    $display("CONFIG_ERROR: Not supported Virtex6 blk_dp_fifo memory size configuration!\n");
                    $finish;
                end
            `endif
        end

    end
    else if ((TARGET_ASIC == 0) && (TARGET_FPGA == 0)) begin : sim

        // simulation memory
        ram_mem_sim_dp #(
            .SIZE(SIZE+2))
        eth_fifo_mem (
            .clk(wclk),
            .rena(dft_re),
            .wea(4'd0),
            .addra(read_address),
            .dina({DATA_WIDTH{1'b0}}),
            .douta(dft_data_out),
            .renb(1'b0),
            .web({4{dft_we}}),
            .addrb(write_address),
            .dinb(data_in),
            .doutb());

    end

// -----------------------------------------------------------------------------
// technology configuration sanity check
// -----------------------------------------------------------------------------

    else begin : memory_error
        `ifndef GATE
            initial begin
                $display("CONFIG_ERROR: Not supported eth_fifo memory technology!\n");
                $finish;
            end
        `endif
    end
endgenerate

endmodule
