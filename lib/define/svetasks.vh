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
// File Name : svetasks.vh
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-15 13:18:01 +0100 (Fri, 15 Mar 2019) $
// $Revision: 433 $
// -FHDR------------------------------------------------------------------------

function [0:0] isunknown;
input [31:0] in;
integer i;
begin
`ifndef GATE
    isunknown = 1'b0;
    for (i=0; i<32; i=i+1) begin
        if (in[i] === 1'bx) begin
            isunknown = 1'b1;
        end
        else if (in[i] === 1'bz) begin
            isunknown = 1'b1;
        end
    end
`else
    isunknown = 1'b0;
`endif
end
endfunction
