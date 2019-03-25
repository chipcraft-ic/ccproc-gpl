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

genvar pk_idx;
genvar unpk_idx;

`define PACK_ARRAY(ID,PK_WIDTH,PK_LEN,PK_SRC,PK_DEST)    generate for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin : ID assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end endgenerate
`define UNPACK_ARRAY(ID,PK_WIDTH,PK_LEN,PK_DEST,PK_SRC)  generate for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin : ID assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end endgenerate

`define NOGEN_PACK_ARRAY(ID,PK_WIDTH,PK_LEN,PK_SRC,PK_DEST)    for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin : ID assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_WIDTH)-1):0]; end
`define NOGEN_UNPACK_ARRAY(ID,PK_WIDTH,PK_LEN,PK_DEST,PK_SRC)  for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin : ID assign PK_DEST[unpk_idx][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end

`define NOGEN_PACK_ARRAY_SIZE(ID,PK_WIDTH,PK_LEN,PK_SRC_S,PK_SRC_E,PK_SRC,PK_DEST)      for (pk_idx=0; pk_idx<(PK_LEN); pk_idx=pk_idx+1) begin : ID assign PK_DEST[((PK_WIDTH)*pk_idx+((PK_WIDTH)-1)):((PK_WIDTH)*pk_idx)] = PK_SRC[pk_idx][((PK_SRC_S)-1):(PK_SRC_E)]; end
`define NOGEN_UNPACK_ARRAY_SIZE(ID,PK_WIDTH,PK_LEN,PK_DEST_S,PK_DEST_E,PK_DEST,PK_SRC)  for (unpk_idx=0; unpk_idx<(PK_LEN); unpk_idx=unpk_idx+1) begin : ID assign PK_DEST[unpk_idx][((PK_DEST_S)-1):(PK_DEST_E)] = PK_SRC[((PK_WIDTH)*unpk_idx+(PK_WIDTH-1)):((PK_WIDTH)*unpk_idx)]; end

