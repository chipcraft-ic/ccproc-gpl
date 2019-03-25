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
// File Name : clog2.vh
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2017-05-13 13:57:45 +0200 (Sat, 13 May 2017) $
// $Revision: 27 $
// -FHDR------------------------------------------------------------------------

function [31:0] clog2;
input [31:0] x;
reg [31:0] tmp_x;
reg [31:0] tmp_clog2;
integer i;
begin
    tmp_x = x;
    if (tmp_x == 32'd0) begin
        tmp_clog2 = 32'd0;
    end else begin
        tmp_x = tmp_x - 32'd1;
        for (i=0; tmp_x!=0; i=i+1) begin
            tmp_x = tmp_x >> 1;
        end
        if (i == 0)
            tmp_clog2 = 32'd1;
        else
            tmp_clog2 = i[31:0];
    end
    clog2 = tmp_clog2;
end
endfunction
