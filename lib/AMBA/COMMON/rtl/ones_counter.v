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
// File Name : ones_counter.v
// Author    : Maciej Plasota
// -----------------------------------------------------------------------------
// $Date: 2017-03-30 21:39:22 +0200 (Thu, 30 Mar 2017) $
// $Revision: 21 $
// -FHDR------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Counter for the number of "1"s in the input vector.
// -----------------------------------------------------------------------------
//  INPUTS:
//  vector_in - data vector to be examined
//
//  OUTPUTS:
//  ones_count - number of bits set in the input vector
//
//  PARAMETERS:
//  input_width - bit width of the input vector
//  count_width - bit width of the output port
//
//  NOTE: Output port must be wide enough to hold maximum possible
//  count value.
// -----------------------------------------------------------------------------
module ones_counter(
    vector_in,
    ones_count
);

parameter [31:0] input_width = 32'd4;
parameter [31:0] count_width = 32'd3;

input wire [input_width-1:0] vector_in;
output reg [count_width-1:0] ones_count;

integer i;

always @* begin
    ones_count = {count_width{1'b0}};
    for(i=0; i<input_width; i=i+1) begin
        ones_count = ones_count + {{count_width-1{1'b0}},vector_in[i]};
    end
end
endmodule
