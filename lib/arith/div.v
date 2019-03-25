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
// File Name : div.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-01-11 16:22:32 +0100 (Fri, 11 Jan 2019) $
// $Revision: 363 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"

module div(clk, rstn, start, dividend, divisor, quotient, remainder, finish, addA, addB, addC, addRes);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] WIDTH      = 32'd32;
parameter [31:0] RSHARE     = 32'd0;
parameter [31:0] INIT_SHIFT = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire                          clk;
input wire                          rstn;
input wire                          start;
input wire      [WIDTH-1:0]         dividend;
input wire      [WIDTH-1:0]         divisor;
output reg      [WIDTH-1:0]         quotient;
output reg      [WIDTH-1:0]         remainder;
output reg                          finish;

output wire     [WIDTH:0]           addA;
output wire     [WIDTH:0]           addB;
output wire                         addC;
input wire      [WIDTH:0]           addRes;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg     [WIDTH-1:0]      result;
reg     [WIDTH-1:0]      denom;
reg     [6:0]            cycle;
reg                      neg_quotient;
reg                      neg_remainder;
reg                      active;
reg                      divzero;

wire    [WIDTH:0]        sub;

wire    [WIDTH-1:0]      nosign_dividend;
wire    [2*WIDTH-1:0]    remainder_result;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign    nosign_dividend    = (dividend[WIDTH-1] == 1'b0) ? dividend : $unsigned(-dividend);
assign    remainder_result   = nosign_dividend << INIT_SHIFT;

generate

// -----------------------------------------------------------------------------
// without resource sharing
// -----------------------------------------------------------------------------

    if (RSHARE == 0) begin
        assign    sub     = {1'b0,remainder[WIDTH-2:0],result[WIDTH-1]} - {1'b0,denom};
        assign    addA    = {WIDTH+1{1'b0}};
        assign    addB    = {WIDTH+1{1'b0}};
        assign    addC    = 1'b0;
    end

// -----------------------------------------------------------------------------
// resource sharing
// -----------------------------------------------------------------------------

    else begin
        assign    sub     = addRes;
        assign    addA    = {1'b0,remainder[WIDTH-2:0],result[WIDTH-1]};
        assign    addB    = {1'b1,~denom};
        assign    addC    = 1'b1;
    end
endgenerate

// -----------------------------------------------------------------------------
// main state machine
// -----------------------------------------------------------------------------

always @(posedge clk or negedge rstn) begin
    if (!rstn) begin
        finish <= 1'b1;
        active <= 1'b0;
        divzero <= 1'b0;
        neg_quotient <= 1'b0;
        neg_remainder <= 1'b0;
        cycle <= 7'd0;
        result <= {WIDTH{1'b0}};
        quotient <= {WIDTH{1'b0}};
        denom <= {WIDTH{1'b0}};
        remainder <= {WIDTH{1'b0}};
    end
    else begin
        if (finish == 1'b1) begin
            if (start == 1'b1) begin
                cycle <= WIDTH[6:0];
                {remainder,result} <= remainder_result;
                denom <= (divisor[WIDTH-1] == 1'b0) ? divisor : $unsigned(-divisor);
                neg_quotient <= dividend[WIDTH-1] ^ divisor[WIDTH-1];
                neg_remainder <= dividend[WIDTH-1];
                finish <= 1'b0;
                if (divisor == {WIDTH{1'b0}}) begin
                    divzero <= 1'b1;
                    remainder <= dividend;
                end else begin
                    active <= 1'b1;
                end
            end
        end
        else if (divzero) begin
            divzero <= 1'b0;
            quotient <= {WIDTH{1'b1}};
            //remainder <= dividend;
            finish <= 1'b1;
        end
        else if (active) begin
            if (sub[WIDTH] == 1'b0) begin
                remainder <= sub[WIDTH-1:0];
                result <= {result[WIDTH-2:0],1'b1};
            end
            else begin
                remainder <= {remainder[WIDTH-2:0],result[WIDTH-1]};
                result <= {result[WIDTH-2:0],1'b0};
            end
            if (cycle == 7'd1) begin
                active <= 1'b0;
            end
            cycle <= cycle - 7'd1;
        end
        else if (finish == 1'b0) begin
            finish <= 1'b1;
            quotient <= !neg_quotient ? result : $unsigned(-result);
            remainder <= !neg_remainder ? remainder : $unsigned(-remainder);
        end
    end
end

// -----------------------------------------------------------------------------
// configuration sanity check
// -----------------------------------------------------------------------------

`ifndef GATE
initial begin
    if (WIDTH > 127) begin
        $display("CONFIG_ERROR: Increase cycle variable width!\n");
        $finish;
    end
end
`endif

endmodule
