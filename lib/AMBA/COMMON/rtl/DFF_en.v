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
// File Name : DFF_en.v
// Author    : Maciej Plasota
// -----------------------------------------------------------------------------
// $Date: 2017-12-10 21:03:52 +0100 (Sun, 10 Dec 2017) $
// $Revision: 128 $
// -FHDR------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  D flip flop (register) model 0
//  with nRST input.
// -----------------------------------------------------------------------------
//    INPUTS:
//    clk - clock
//    nRST - reset (active low)
//    D - data input
//
//    OUTPUTS:
//    Q - data output
//
//  PARAMETERS:
//  n - register width
//
// -----------------------------------------------------------------------------

module DFF_rst(clk ,nRST, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire clk;
    input wire nRST;
    output reg [n-1:0] Q;

    always@ (negedge nRST or posedge clk) begin
        if (!nRST) begin
            Q <= {n{1'b0}};
        end else begin
            Q <= D;
        end
    end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 1
//  with enable and nRST inputs.
//  Last output is held while enable is 0.
// -----------------------------------------------------------------------------
//    INPUTS:
//    clk - clock
//    nRST - reset (active low)
//    en - enable
//    D - data input
//
//    OUTPUTS:
//    Q - data output
//
//  PARAMETERS:
//  n - register width
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------

module DFF_en(clk ,nRST, en, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire en;
input wire clk;
input wire nRST;
output reg [n-1:0] Q;

always@ (negedge nRST or posedge clk) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else begin
        if(en) begin
            Q <= D;
        end
    end
end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 2
//  with enable and nRST inputs.
//  Output is 0 when enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable
//  D - data input
//
//  PARAMETERS:
//  n - register width
//
//  OUTPUTS:
//  Q - data output
//
//  NOTE: Sets output to 0 when disabled
// -----------------------------------------------------------------------------
module DFF_en2(clk ,nRST, en, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire en;
input wire clk;
input wire nRST;
output reg [n-1:0] Q;

always@ (negedge nRST or posedge clk) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else begin
        if(en) begin
            Q <= D;
        end else begin
            Q <= {n{1'b0}};
        end
    end
end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 3
//  with enable and nRST inputs.
//  Output is 1 when enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable
//  D - data input
//
//  PARAMETERS:
//  n - register width
//
//  OUTPUTS:
//  Q - data output
//
//  NOTE: Sets output to 1 when disabled
// -----------------------------------------------------------------------------
module DFF_en3(clk ,nRST, en, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire en;
input wire clk;
input wire nRST;
output reg [n-1:0] Q;

always@ (negedge nRST or posedge clk) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else begin
        if(en) begin
            Q <= D;
        end else begin
            Q <= {n{1'b1}};
        end
    end
end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 4
//  with enable and nRST and nSET inputs.
//  Last output is held while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  nSET - set (active low)
//  en - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output
//
//  PARAMETERS:
//  n - register width
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------
module DFF_set_rst_en(clk, nRST, nSET, en, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire en,clk,nRST,nSET;
output reg [n-1:0] Q;

always@ (posedge clk or negedge nRST or negedge nSET) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else if(!nSET) begin
        Q <= {n{1'b1}};
    end else begin
        if(en) begin
            Q <= D;
        end
    end
end

endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 5
//  with enable and nRST inputs.
//  Last output is held while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output
//
//  PARAMETERS:
//  n - register width
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------
module DFF_rst_en(clk, nRST, en, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire en,clk,nRST;
    output reg [n-1:0] Q;

    always@ (posedge clk or negedge nRST) begin
        if (!nRST) begin
            Q <= {n{1'b0}};
        end else begin
            if(en) begin
                Q <= D;
            end
        end
    end

endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 6
//  with enable and nSET inputs.
//  Last output is held while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nSET - set (active low)
//  en - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output
//
//  PARAMETERS:
//  n - register width
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------
module DFF_set_en(clk, nSET, en, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire en,clk,nSET;
    output reg [n-1:0] Q;

    always@ (posedge clk or negedge nSET) begin
        if(!nSET) begin
            Q <= {n{1'b1}};
        end else begin
            if(en) begin
                Q <= D;
            end
        end
    end

endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 7
//  with nRST and nSET inputs.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  nSET - set (active low)
//  D - data input
//
//  OUTPUTS:
//  Q - data output
// -----------------------------------------------------------------------------
module DFF_set_rst(clk, nRST, nSET, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire clk,nRST,nSET;
output reg [n-1:0] Q;

always@ (posedge clk or negedge nRST or negedge nSET) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else if(!nSET) begin
        Q <= {n{1'b1}};
    end else begin
        Q <= D;
    end
end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 8
//  with enable nSET and nRST inputs.
//  Output is 0 when enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  nSET - set (active low)
//  enable - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output or zero when enable is 0
//
//  NOTE: Sets output to 0 when disabled
// -----------------------------------------------------------------------------
module DFF_set_rst_en2(clk, nRST, nSET, en, D, Q);
parameter [31:0] n = 32'd32;
input wire [n-1:0] D;
input wire en,clk,nRST,nSET;
output reg [n-1:0] Q;

always@ (posedge clk or negedge nRST or negedge nSET) begin
    if (!nRST) begin
        Q <= {n{1'b0}};
    end else if(!nSET) begin
        Q <= {n{1'b1}};
    end else begin
        if(en) begin
            Q <= D;
        end else begin
            Q <= {n{1'b0}};
        end
    end
end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 9
//  with enable and nSET inputs.
//  Last output is held while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nSET - set (active low)
//  D - data input
//
//  OUTPUTS:
//  Q - data output
//
//  PARAMETERS:
//  n - register width
// -----------------------------------------------------------------------------*/
module DFF_set(clk, nSET, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire clk,nSET;
    output reg [n-1:0] Q;

    always@ (posedge clk or negedge nSET) begin
        if(!nSET) begin
            Q <= {n{1'b1}};
        end else begin
            Q <= D;
        end
    end

endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 10
//  with enable nSET and nRST inputs.
//  Output is 1 when enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  nSET - set (active low)
//  enable - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output or 1 when enable is 0
//
//  NOTE: Sets output to 1 when disabled
// -----------------------------------------------------------------------------
module DFF_set_rst_en3(clk, nRST, nSET, en, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire en,clk,nRST,nSET;
    output reg [n-1:0] Q;

    always@ (posedge clk or negedge nRST or negedge nSET) begin
        if (!nRST) begin
            Q <= {n{1'b0}};
        end else if(!nSET) begin
            Q <= {n{1'b1}};
        end else begin
            if(en) begin
                Q <= D;
            end else begin
                Q <= {n{1'b1}};
            end
        end
    end
endmodule

// -----------------------------------------------------------------------------
//  D flip flop (register) model 11
//  with enable and nSET inputs.
//  NOTE: Sets output to 1 when disabled
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nSET - set (active low)
//  en - enable
//  D - data input
//
//  OUTPUTS:
//  Q - data output
//
//  PARAMETERS:
//  n - register width
//
//  NOTE: Sets output to 1 when disabled
// -----------------------------------------------------------------------------
module DFF_set_en2(clk, nSET, en, D, Q);
    parameter [31:0] n = 32'd32;
    input wire [n-1:0] D;
    input wire en,clk,nSET;
    output reg [n-1:0] Q;

    always@ (posedge clk or negedge nSET) begin
        if(!nSET) begin
            Q <= {n{1'b1}};
        end else begin
            if(en) begin
                Q <= D;
            end else begin
                Q <= {n{1'b1}};
            end
        end
    end

endmodule