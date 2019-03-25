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
// File Name : shifter.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-09-10 21:54:12 +0200 (Mon, 10 Sep 2018) $
// $Revision: 258 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"



// -----------------------------------------------------------------------------
// simple shifter
// -----------------------------------------------------------------------------

module shifter_module(op, amount, arithm, right, result);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] WIDTH = 32'd32;
parameter [31:0] SHAM  = 32'd5;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire    [WIDTH-1:0]   op;
input wire    [SHAM-1:0]    amount;
input wire                  arithm;
input wire                  right;
output reg    [WIDTH-1:0]   result;

// -----------------------------------------------------------------------------
// local wires
// -----------------------------------------------------------------------------

wire    carry;

// -----------------------------------------------------------------------------
// local variables
// -----------------------------------------------------------------------------

integer i;

// -----------------------------------------------------------------------------
// carry assign
// -----------------------------------------------------------------------------

assign carry = (arithm) ? op[WIDTH-1] : 1'b0;

// -----------------------------------------------------------------------------
// main body
// -----------------------------------------------------------------------------

always @(*)
begin
    if (right) begin
        result = op;
        for (i=0;i<amount;i=i+1) begin
            result = result >> 1;
            result[WIDTH-1] = carry;
        end
    end else begin
        result = op << amount;
    end
end

endmodule



// -----------------------------------------------------------------------------
// shifter with enable
// -----------------------------------------------------------------------------

module hw_shifter_module_en(op, amount, arithm, right, result, enable);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] WIDTH = 32'd32;
parameter [31:0] SHAM  = 32'd5;
parameter [31:0] OPIS  = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire    [WIDTH-1:0]   op;
input wire    [SHAM-1:0]    amount;
input wire                  arithm;
input wire                  right;
input wire                  enable;
output wire   [WIDTH-1:0]   result;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire                    carry;
reg    [WIDTH*2-1:0]    shiftout;
reg    [WIDTH-1:0]      reverse;
reg    [WIDTH-1:0]      reverseout;

reg    [WIDTH-1:0]      isol_op;
reg    [SHAM-1:0]       isol_amount;
reg                     isol_arithm;
reg                     isol_right;

// -----------------------------------------------------------------------------
// local variables
// -----------------------------------------------------------------------------

integer   i;

// -----------------------------------------------------------------------------
// assign carry and result
// -----------------------------------------------------------------------------

assign    carry     = (isol_arithm) ? isol_op[WIDTH-1]    : 1'b0;
assign    result    = (isol_right)  ? shiftout[WIDTH-1:0] : reverseout;

// -----------------------------------------------------------------------------
// operand isolation
// -----------------------------------------------------------------------------

generate
if (OPIS == 1) begin
    always @(*)
    begin
        isol_op     = op     & {WIDTH{enable}};
        isol_amount = amount & {SHAM{enable}};
        isol_arithm = arithm & enable;
        isol_right  = right  & enable;
    end
end

// -----------------------------------------------------------------------------
// without operand isolation
// -----------------------------------------------------------------------------

else begin
    always @(*)
    begin
        isol_op     = op;
        isol_amount = amount;
        isol_arithm = arithm;
        isol_right  = right;
    end
end
endgenerate

// -----------------------------------------------------------------------------
// shifter body
// -----------------------------------------------------------------------------

always @(*)
begin
    for (i=(WIDTH-1);i>=0;i=i-1) reverse[WIDTH-1-$unsigned(i)] = isol_op[i];
    shiftout[WIDTH*2-1:0] = {{(WIDTH){carry}},reverse};
    if (right) shiftout[WIDTH-1:0]  = isol_op;
    if (isol_amount[4]) shiftout[47:0] = shiftout[63:16];
    if (isol_amount[3]) shiftout[39:0] = shiftout[47:8];
    if (isol_amount[2]) shiftout[35:0] = shiftout[39:4];
    if (isol_amount[1]) shiftout[33:0] = shiftout[35:2];
    if (isol_amount[0]) shiftout[31:0] = shiftout[32:1];
    for (i=(WIDTH-1);i>=0;i=i-1) reverseout[WIDTH-1-$unsigned(i)] = shiftout[i];
end

endmodule



// -----------------------------------------------------------------------------
// shifter
// -----------------------------------------------------------------------------

module hw_shifter_module(op, amount, arithm, right, result);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] WIDTH = 32'd32;
parameter [31:0] SHAM  = 32'd5;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire    [WIDTH-1:0]   op;
input wire    [SHAM-1:0]    amount;
input wire                  arithm;
input wire                  right;
output wire   [WIDTH-1:0]   result;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire                    carry;
reg    [WIDTH*2-1:0]    shiftout;
reg    [WIDTH-1:0]      reverse;
reg    [WIDTH-1:0]      reverseout;

// -----------------------------------------------------------------------------
// local variables
// -----------------------------------------------------------------------------

integer   i;

// -----------------------------------------------------------------------------
// assign carry and rsult
// -----------------------------------------------------------------------------

assign    carry    = (arithm) ? op[WIDTH-1]         : 1'b0;
assign    result   = (right)  ? shiftout[WIDTH-1:0] : reverseout;

// -----------------------------------------------------------------------------
// shifter body
// -----------------------------------------------------------------------------

always @(*)
begin
    for (i=(WIDTH-1);i>=0;i=i-1) reverse[WIDTH-1-$unsigned(i)] = op[i];
    shiftout[WIDTH*2-1:0] = {{(WIDTH){carry}},reverse};
    if (right) shiftout[WIDTH-1:0] = op;
    if (amount[4]) shiftout[47:0]  = shiftout[63:16];
    if (amount[3]) shiftout[39:0]  = shiftout[47:8];
    if (amount[2]) shiftout[35:0]  = shiftout[39:4];
    if (amount[1]) shiftout[33:0]  = shiftout[35:2];
    if (amount[0]) shiftout[31:0]  = shiftout[32:1];
    for (i=(WIDTH-1);i>=0;i=i-1) reverseout[WIDTH-1-$unsigned(i)] = shiftout[i];
end

endmodule
