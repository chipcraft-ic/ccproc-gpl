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
// File Name : synchronizer.v
// Author    : Maciej Plasota
// -----------------------------------------------------------------------------
// $Date: 2018-01-21 20:14:13 +0100 (Sun, 21 Jan 2018) $
// $Revision: 139 $
// -FHDR------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Synchronizer (double Flip-flop) model 1
//  with enable and nRST inputs.
//  Last output is held, while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable (active high)
//  IN - data input
//
//  OUTPUTS:
//  OUT - synchronized data output
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------

module Synchronizer(clk, nRST, en, IN, OUT);
    input wire IN;
    input wire en,clk,nRST;
    output wire OUT;

    wire    interStage;
    wire    synchIn;

    assign  synchIn = en ? IN : OUT;

    // set_max_delay between stages 10% to 20% of clock cycle
    DFF_rst    #(.n(1)) SYNCH1(.clk(clk) , .nRST(nRST), .D(synchIn), .Q(interStage));
    DFF_rst    #(.n(1)) SYNCH2(.clk(clk) , .nRST(nRST), .D(interStage), .Q(OUT));
endmodule

// -----------------------------------------------------------------------------
//  Synchronizer (double Flip-flop) model 2
//  with enable and nRST inputs.
//  Output is 0, while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable (active high)
//  IN - data input
//
//  OUTPUTS:
//  OUT - synchronized data output
//
//  NOTE: Sets output to 0 when disabled
// -----------------------------------------------------------------------------
module Synchronizer2(clk, nRST, en, IN, OUT);
    input wire IN;
    input wire en,clk,nRST;
    output wire OUT;

    wire    interStage;
    wire    synchIn;

    assign  synchIn = en ? IN : 1'b0;

    // set_max_delay between stages 10% to 20% of clock cycle
    DFF_rst     #(.n(1)) SYNCH1(.clk(clk) , .nRST(nRST), .D(synchIn), .Q(interStage));
    DFF_rst     #(.n(1)) SYNCH2(.clk(clk) , .nRST(nRST), .D(interStage), .Q(OUT));
endmodule

// -----------------------------------------------------------------------------
//  Synchronizer (double Flip-flop) model 3
//  with enable and nRST inputs.
//  Output is 1, while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable (active high)
//  IN - data input
//
//  OUTPUTS:
//  OUT - synchronized data output
//
//  NOTE: Sets output to 1 when disabled
// -----------------------------------------------------------------------------
module Synchronizer3(clk, nRST, en, IN, OUT);
    input wire IN;
    input wire en,clk,nRST;
    output wire OUT;

    wire    interStage;
    wire    synchIn;

    assign  synchIn = en ? IN : 1'b1;

    // set_max_delay between stages 10% to 20% of clock cycle
    DFF_rst     #(.n(1)) SYNCH1(.clk(clk) , .nRST(nRST), .D(synchIn), .Q(interStage));
    DFF_rst     #(.n(1)) SYNCH2(.clk(clk) , .nRST(nRST), .D(interStage), .Q(OUT));
endmodule

// -----------------------------------------------------------------------------
//  Synchronizer (double Flip-flop) model 4
//  with enable and nRST inputs.
//  Last output is held, while enable is 0.
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  en - enable (active high)
//  IN - data input
//
//  OUTPUTS:
//  OUT - synchronized data output
//
//  NOTE: Keeps previous level when disabled
// -----------------------------------------------------------------------------

module Synchronizer_set_en(clk, nRST, en, IN, OUT);
    input wire IN;
    input wire en,clk,nRST;
    output wire OUT;

    wire    interStage;
    wire    synchIn;

    assign  synchIn = en ? IN : OUT;

    // set_max_delay between stages 10% to 20% of clock cycle
    DFF_set    #(.n(1)) SYNCH1(.clk(clk) , .nSET(nRST), .D(synchIn), .Q(interStage));
    DFF_set    #(.n(1)) SYNCH2(.clk(clk) , .nSET(nRST), .D(interStage), .Q(OUT));
endmodule
