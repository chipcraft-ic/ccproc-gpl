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
// $Date: 2018-07-10 20:25:31 +0200 (Tue, 10 Jul 2018) $
// $Revision: 232 $
// -FHDR------------------------------------------------------------------------

`ifndef __CACHE_DEF__
`define __CACHE_DEF__

// -----------------------------------------------------------------------------
// instruction cache
// -----------------------------------------------------------------------------

`define ADD_ITAG_S      (CFG_IMEM_BUS-32'd1)
`define ADD_ITAG_E      (CFG_ICACHE_SIZE)
`define ADD_IC_S        (`ADD_ITAG_E-32'd1)
`define ADD_IC_E        32'd2
`define ADD_ILINE_S     (32'd3+CFG_ILINE_SIZE)
`define ADD_ILINE_E     32'd2

`define TAG_ITAG_S      (CFG_IMEM_BUS-`ADD_ITAG_E)
`define TAG_ITAG_E      32'd1

`define REFILL_IS       (`ADD_ILINE_S-32'd1)

// -----------------------------------------------------------------------------
// data cache
// -----------------------------------------------------------------------------

`define ADD_DTAG_S      (CFG_MAX_MEM_BUS-32'd1)
`define ADD_DTAG_E      (CFG_DCACHE_SIZE)
`define ADD_DC_S        (`ADD_DTAG_E-32'd1)
`define ADD_DC_E        32'd2
`define ADD_DLINE_S     (32'd3+CFG_DLINE_SIZE)
`define ADD_DLINE_E     32'd2

`define TAG_DTAG_S      (CFG_MAX_MEM_BUS-CFG_FULLADDR_EN-`ADD_DTAG_E)
`define TAG_DTAG_E      32'd0

`define REFILL_DS       (`ADD_DLINE_S-32'd1)

`endif // __CACHE_DEF__
