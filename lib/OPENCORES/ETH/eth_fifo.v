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
// File Name : eth_fifo.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-11-05 15:24:29 +0100 (Mon, 05 Nov 2018) $
// $Revision: 311 $
// -FHDR------------------------------------------------------------------------

module eth_fifo(
    data_in,
    data_out,
    clk,
    reset,
    write,
    read,
    clear,
    almost_full,
    full,
    almost_empty,
    empty,
    cnt,
    test_mode,
    diag_addr,
    diag_read,
    diag_write,
    diag_wdata
);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0]    DATA_WIDTH    = 32'd32;
parameter [31:0]    DEPTH         = 32'd8;
parameter [31:0]    CNT_WIDTH     = 32'd4;
parameter [31:0]    DFT_MEM     = 32'd0;
parameter [31:0]    TARGET_FPGA = 32'd0;
parameter [31:0]    TARGET_ASIC = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire                    clk;
input wire                    reset;
input wire                    write;
input wire                    read;
input wire                    clear;
input wire  [DATA_WIDTH-1:0]  data_in;

input wire                    diag_write;
input wire                    diag_read;
input wire  [DATA_WIDTH-1:0]  diag_wdata;
input wire  [CNT_WIDTH-2:0]   diag_addr;

output wire [DATA_WIDTH-1:0]  data_out;
output wire                   almost_full;
output wire                   full;
output wire                   almost_empty;
output wire                   empty;
output reg  [CNT_WIDTH-1:0]   cnt;
input wire                    test_mode;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg     [CNT_WIDTH-2:0]   read_pointer;
reg     [CNT_WIDTH-2:0]   write_pointer;

reg                       update;

// -----------------------------------------------------------------------------
// fifo count logic
// -----------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
begin
    if(reset)
        cnt <= 0;
    else
    if(clear)
        cnt <= { {(CNT_WIDTH-1){1'b0}}, read^write};
    else
        if(read ^ write)
            if(read)
                cnt <= cnt - 1;
            else
                cnt <= cnt + 1;
end

// -----------------------------------------------------------------------------
// read pointer logic
// -----------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
begin
    if(reset)
        read_pointer <= 0;
    else
        if(clear)
            read_pointer <= { {(CNT_WIDTH-2){1'b0}}, read};
    else
        if(read & ~empty)
            read_pointer <= read_pointer + 1'b1;
end

// -----------------------------------------------------------------------------
// write pointer logic
// -----------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
begin
    if(reset)
        write_pointer <= 0;
    else
        if(clear)
            write_pointer <= { {(CNT_WIDTH-2){1'b0}}, write};
        else
            if(write & ~full)
                write_pointer <= write_pointer + 1'b1;
end

// -----------------------------------------------------------------------------
// memory output update
// -----------------------------------------------------------------------------

always @ (posedge clk or posedge reset)
begin
    if(reset)
        update <= 0;
    else
        update <= read | write | clear;
end

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign empty = ~(|cnt);
assign almost_empty = cnt == 1;
assign full = cnt == DEPTH;
assign almost_full  = &cnt[CNT_WIDTH-2:0];

// -----------------------------------------------------------------------------
// fifo memory
// -----------------------------------------------------------------------------

eth_fifo_memory #(
    .DATA_WIDTH(DATA_WIDTH),
    .SIZE(CNT_WIDTH-1),
    .DFT_MEM(DFT_MEM),
    .TARGET_FPGA(TARGET_FPGA),
    .TARGET_ASIC(TARGET_ASIC))
fifo (
    .data_out(data_out),
    .we((write & ~full) | (write & clear) | diag_write),
    .re(read | write | clear | update | diag_read),
    .data_in(diag_write ? diag_wdata : data_in),
    .read_address(  diag_read  ? diag_addr : clear ? {CNT_WIDTH-1{1'b0}} : read_pointer),
    .write_address( diag_write ? diag_addr : clear ? {CNT_WIDTH-1{1'b0}} : write_pointer),
    .wclk(clk),
    .test_mode(test_mode));

endmodule
