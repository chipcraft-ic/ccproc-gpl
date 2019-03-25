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
// File Name : input_filter.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2017-07-09 09:31:45 +0200 (Sun, 09 Jul 2017) $
// $Revision: 72 $
// -FHDR------------------------------------------------------------------------

module input_filter(
    clk,
    rst,
    in,
    conf,
    en,
    out
);

parameter    [31:0] FILTER_WIDTH        = 32'd12;
parameter    [31:0] FILTER_LOG          = 32'd4;
parameter    [31:0] FILTER_DEFAULT_OUT  = 32'd1;
parameter    [31:0] FILTER_COUNT_IN     = 32'd1;

input wire                      clk;
input wire                      rst;
input wire                      in;
input wire    [FILTER_LOG-1:0]  conf;
input wire                      en;
output wire                     out;

reg [FILTER_WIDTH-1:0]    filter_reg;
reg                       filter_out;
reg                       filter_val;

integer i;

assign    out    = en ? filter_out : in;

always @(*) begin
    if (FILTER_COUNT_IN == 1) begin
        filter_val = filter_val_funct(filter_out,{filter_reg[FILTER_WIDTH-2:0],in},conf);
    end else begin
        filter_val = filter_val_funct(filter_out,filter_reg,conf);
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        filter_reg <= {FILTER_WIDTH{FILTER_DEFAULT_OUT[0]}};
    end else begin
        if (en) begin
            filter_reg <= {filter_reg[FILTER_WIDTH-2:0],in};
        end else begin
            filter_reg <= {FILTER_WIDTH{FILTER_DEFAULT_OUT[0]}};
        end
    end
end

always @(posedge clk or negedge rst) begin
    if (!rst) begin
        filter_out <= FILTER_DEFAULT_OUT[0];
    end else begin
        if (en) begin
            filter_out <= filter_val;
        end else begin
            filter_out <= FILTER_DEFAULT_OUT[0];
        end
    end
end

function filter_val_funct;
input                       filter_old;
input [FILTER_WIDTH-1:0]    filter_reg;
input [FILTER_LOG-1:0]      filter_conf;
integer i;
reg filter_temp;
reg hold;
begin
    filter_temp = filter_old;
    hold = 1'b0;
    for (i = 0; i < FILTER_WIDTH; i = i + 1) begin
        if (i[FILTER_LOG-1:0] < filter_conf) begin
            if (filter_reg[i] == 1'b1) begin
                hold = 1'b1;
            end
        end
    end
    if (hold == 1'b0) begin
        filter_temp = 1'b0;
    end
    hold = 1'b0;
    for (i = 0; i < FILTER_WIDTH; i = i + 1) begin
        if (i[FILTER_LOG-1:0] < filter_conf) begin
            if (filter_reg[i] == 1'b0) begin
                hold = 1'b1;
            end
        end
    end
    if (hold == 1'b0) begin
        filter_temp = 1'b1;
    end
    filter_val_funct = filter_temp;
end
endfunction

endmodule
