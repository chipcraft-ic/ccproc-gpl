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
// File Name : dff.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-12-16 22:10:51 +0100 (Sun, 16 Dec 2018) $
// $Revision: 341 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"
`include "define.vh"



// -----------------------------------------------------------------------------
// latch without reset
// -----------------------------------------------------------------------------

module latch(Q, D, E);
parameter   [31:0]  N = 32'd32;
input wire               E;
input wire    [N-1:0]    D;
output reg    [N-1:0]    Q;

always @(*)
begin
    if (E) begin
        Q <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// latch with negedge reset to zero
// -----------------------------------------------------------------------------

module latchnr0(Q, D, E, rstn);
parameter   [31:0]  N = 32'd32;
input wire               E;
input wire               rstn;
input wire    [N-1:0]    D;
output reg    [N-1:0]    Q;

always @(*)
begin
    if (!rstn) begin
        Q <= {N{1'b0}};
    end else begin
        if (E) begin
            Q <= D;
        end
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff
// -----------------------------------------------------------------------------

module dff(clk, Q, D);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire               clk;
input wire    [N-1:0]    D;
output wire   [N-1:0]    Q;

reg         [N-1:0] tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk)
begin
    tmpQ <= D;
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to zero
// -----------------------------------------------------------------------------

module dffnr0(clk, rstn, Q, D);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire              clk;
input wire              rstn;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg         [N-1:0] tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= {N{1'b0}};
    end else begin
        tmpQ <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to one
// -----------------------------------------------------------------------------

module dffnr1(clk, rstn, Q, D);
parameter   [31:0]  N = 32'd32;
input wire              clk;
input wire              rstn;
input wire    [N-1:0]   D;
output reg    [N-1:0]   Q;

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        Q <= {N{1'b1}};
    end else begin
        Q <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with posedge reset to zero
// -----------------------------------------------------------------------------

module dffpr0(clk, rst, Q, D);
parameter   [31:0]  N = 32'd32;
input wire              clk;
input wire              rst;
input wire    [N-1:0]   D;
output reg    [N-1:0]   Q;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        Q <= {N{1'b0}};
    end else begin
        Q <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with posedge reset to one
// -----------------------------------------------------------------------------

module dffpr1(clk, rst, Q, D);
parameter   [31:0]  N = 32'd32;
input wire              clk;
input wire              rst;
input wire    [N-1:0]   D;
output reg    [N-1:0]   Q;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        Q <= {N{1'b1}};
    end else begin
        Q <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with enable
// -----------------------------------------------------------------------------

module dffen(clk, Q, D, E);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire              clk;
input wire              E;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg [N-1:0]  tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk)
begin
    if (E) begin
        tmpQ <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to zero and enable
// -----------------------------------------------------------------------------

module dffnr0en(clk, rstn, Q, D, E);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire              clk;
input wire              rstn;
input wire              E;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg [N-1:0]  tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= {N{1'b0}};
    end else begin
        if (E) begin
            tmpQ <= D;
        end
    end
end

endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to VAL
// -----------------------------------------------------------------------------

module dffnrx(clk, rstn, Q, D);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
parameter   [31:0]  VAL = 32'd0;
input wire              clk;
input wire              rstn;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg [N-1:0]  tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= VAL[N-1:0];
    end else begin
        tmpQ <= D;
    end
end

endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to VAL and enable
// -----------------------------------------------------------------------------

module dffnrxen(clk, rstn, Q, D, E);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
parameter   [31:0]  VAL = 32'd0;
input wire              clk;
input wire              rstn;
input wire              E;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg [N-1:0]  tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= VAL[N-1:0];
    end else begin
        if (E) begin
            tmpQ <= D;
        end
    end
end

endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with negedge reset to one and enable
// -----------------------------------------------------------------------------

module dffnr1en(clk, rstn, Q, D, E);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire              clk;
input wire              rstn;
input wire              E;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg [N-1:0]  tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
       tmpQ <= {N{1'b1}};
    end else begin
        if (E) begin
            tmpQ <= D;
        end
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with posedge reset to zero and enable
// -----------------------------------------------------------------------------

module dffpr0en(clk, rst, Q, D, E);
parameter   [31:0]  N = 32'd32;
input wire              clk;
input wire              rst;
input wire              E;
input wire    [N-1:0]   D;
output reg    [N-1:0]   Q;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        Q <= {N{1'b0}};
    end else begin
        if (E) begin
            Q <= D;
        end
    end
end
endmodule



// -----------------------------------------------------------------------------
// posedge clock dff with posedge reset to one and enable
// -----------------------------------------------------------------------------

module dffpr1en(clk, rst, Q, D, E);
parameter   [31:0]  N = 32'd32;
input wire              clk;
input wire              rst;
input wire              E;
input wire    [N-1:0]   D;
output reg    [N-1:0]   Q;

always @(posedge clk or posedge rst)
begin
    if (rst) begin
        Q <= {N{1'b1}};
    end else begin
        if (E) begin
            Q <= D;
        end
    end
end
endmodule



// -----------------------------------------------------------------------------
// negedge clock dff with negedge reset to zero
// -----------------------------------------------------------------------------

module dffnr0ne(clk, rstn, Q, D);
parameter   [31:0] N   = 32'd32;
parameter   [31:0] DEL = 32'd0;
input wire              clk;
input wire              rstn;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg         [N-1:0] tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(negedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= {N{1'b0}};
    end else begin
        tmpQ <= D;
    end
end
endmodule



// -----------------------------------------------------------------------------
// negedge clock dff with negedge reset to one
// -----------------------------------------------------------------------------

module dffnr1ne(clk, rstn, Q, D);
parameter   [31:0]  N   = 32'd32;
parameter   [31:0]  DEL = 32'd0;
input wire              clk;
input wire              rstn;
input wire    [N-1:0]   D;
output wire   [N-1:0]   Q;

reg         [N-1:0] tmpQ;

`ifdef GATE
    assign  Q = tmpQ;
`else
    generate
        if (DEL == 0) begin
            assign          Q = tmpQ;
        end else begin
            assign  #DEL    Q = tmpQ;
        end
    endgenerate
`endif

always @(negedge clk or negedge rstn)
begin
    if (!rstn) begin
        tmpQ <= {N{1'b1}};
    end else begin
        tmpQ <= D;
    end
end
endmodule
