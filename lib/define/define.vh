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
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-12-12 10:50:21 +0100 (Wed, 12 Dec 2018) $
// $Revision: 338 $
// -FHDR------------------------------------------------------------------------

`ifndef __DEFINE__
`define __DEFINE__

`default_nettype none

// -----------------------------------------------------------------------------
// common defines
// -----------------------------------------------------------------------------

`define WIDTH          32
`define HWIDTH         16
`define AWIDTH         5

// -----------------------------------------------------------------------------
// helper defines
// -----------------------------------------------------------------------------

`define FUNW           6
`define SHAMW          5
`define ALUSELW        5
`define IMMW           11
`define TARW           20

// -----------------------------------------------------------------------------
// delay defines
// -----------------------------------------------------------------------------

`ifdef GATE
    `define DEF_DEL_0
    `define DEF_DEL_1
    `define DEF_DEL_2
    `define DEF_DEL_3
    `define DEF_DEL_4
    `define DEF_DEL_5
    `define DEF_DEL_6
    `define DEF_DEL_7
    `define DEF_DEL_8
    `define DEF_DEL_9
`else
    `define DEF_DEL_0    #0
    `define DEF_DEL_1    #1
    `define DEF_DEL_2    #2
    `define DEF_DEL_3    #3
    `define DEF_DEL_4    #4
    `define DEF_DEL_5    #5
    `define DEF_DEL_6    #6
    `define DEF_DEL_7    #7
    `define DEF_DEL_8    #8
    `define DEF_DEL_9    #9
`endif

`endif // __DEFINE__
