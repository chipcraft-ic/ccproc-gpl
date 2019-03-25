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
// File Name : buff.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-12-16 22:10:51 +0100 (Sun, 16 Dec 2018) $
// $Revision: 341 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"

module buf_tri_state(in, out, en);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter   [31:0] WIDTH = 32'd32;
parameter   [31:0] DEL   = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire  [WIDTH-1:0]                 in;
inout wire  [WIDTH-1:0]                 out;
input wire                              en;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

`ifdef GATE
    assign  out = en ? in : {WIDTH{1'bz}};
`else
    generate
        if (DEL == 0) begin
            assign          out = en ? in : {WIDTH{1'bz}};
        end else begin
            assign  #DEL    out = en ? in : {WIDTH{1'bz}};
        end
    endgenerate
`endif

endmodule
