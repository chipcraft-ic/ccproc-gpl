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
// $Date: 2019-02-03 12:01:07 +0100 (Sun, 03 Feb 2019) $
// $Revision: 385 $
// -FHDR------------------------------------------------------------------------

`ifndef __MI32_DEFINE__
`define __MI32_DEFINE__

// -----------------------------------------------------------------------------
// debug exception codes
// -----------------------------------------------------------------------------

`define MI32_SYSCALL_EXIT        15
`define MI32_BREAK_CODE          15

// -----------------------------------------------------------------------------
// decoder defines
// -----------------------------------------------------------------------------

`define MI32_OPS                 31
`define MI32_OPE                 26
`define MI32_RSS                 25
`define MI32_RSE                 21
`define MI32_RTS                 20
`define MI32_CCS                 20
`define MI32_CCE                 17
`define MI32_RTE                 16
`define MI32_IMMS                15
`define MI32_IMME                0
`define MI32_TARS                25
`define MI32_TARE                0
`define MI32_RDS                 15
`define MI32_RDE                 11
`define MI32_SHAMS               10
`define MI32_SHAME               6
`define MI32_FUNS                5
`define MI32_FUNE                0
`define MI32_CONDS               3
`define MI32_CONDE               0

// -----------------------------------------------------------------------------
// destination register
// -----------------------------------------------------------------------------

`define MI32_WRD                 2'b01
`define MI32_WRT                 2'b10
`define MI32_W31                 2'b11

// -----------------------------------------------------------------------------
// stack pointer register
// -----------------------------------------------------------------------------

`define MI32_SPREG               5'd29

// -----------------------------------------------------------------------------
// ALU defines
// -----------------------------------------------------------------------------

`define MI32_ALU_ADD             5'b00000
`define MI32_ALU_SUB             5'b00001
`define MI32_ALU_OR              5'b00010
`define MI32_ALU_AND             5'b00011
`define MI32_ALU_XOR             5'b00100
`define MI32_ALU_SL              5'b00101
`define MI32_ALU_SR              5'b00110
`define MI32_ALU_SLT             5'b00111
`define MI32_ALU_NOR             5'b10010
`define MI32_ALU_LUI             5'b01000
`define MI32_ALU_NO              5'b11110

`define MI32_ALU_MUL             5'b01001
`define MI32_ALU_DIV             5'b01010
`define MI32_ALU_THI             5'b01011
`define MI32_ALU_TLO             5'b01100
`define MI32_ALU_FHI             5'b01101
`define MI32_ALU_FLO             5'b01110

`define MI32_ALU_SEZ             5'b01111
`define MI32_ALU_LI              5'b10000

`define MI32_ALU_MFC1            5'b11000
`define MI32_ALU_MTC1            5'b11001
`define MI32_ALU_CTC1            5'b11010
`define MI32_ALU_CFC1            5'b11011

// -----------------------------------------------------------------------------
// branch defines
// -----------------------------------------------------------------------------

`define MI32_BEQ                 6'b000100
`define MI32_BNE                 6'b000101
`define MI32_BLEZ                6'b000110
`define MI32_BGTZ                6'b000111

`define MI32_BLTZ                5'b00000
`define MI32_BGEZ                5'b00001
`define MI32_BLTZAL              5'b10000
`define MI32_BGEZAL              5'b10001

// -----------------------------------------------------------------------------
// jump defines
// -----------------------------------------------------------------------------

`define MI32_J                   6'b000010
`define MI32_JAL                 6'b000011

`define MI32_JR                  6'b001000
`define MI32_JALR                6'b001001

`define MI32_JALX                6'b011101

// -----------------------------------------------------------------------------
// arithmetical/logical defines
// -----------------------------------------------------------------------------

`define MI32_ADD                 6'b100000
`define MI32_ADDI                6'b001000
`define MI32_ADDIU               6'b001001
`define MI32_ADDU                6'b100001
`define MI32_AND                 6'b100100
`define MI32_ANDI                6'b001100
`define MI32_NOR                 6'b100111
`define MI32_OR                  6'b100101
`define MI32_ORI                 6'b001101
`define MI32_LUI                 6'b001111
`define MI32_SLL                 6'b000000
`define MI32_SLLV                6'b000100
`define MI32_SLT                 6'b101010
`define MI32_SLTI                6'b001010
`define MI32_SLTIU               6'b001011
`define MI32_SLTU                6'b101011
`define MI32_SRA                 6'b000011
`define MI32_SRAV                6'b000111
`define MI32_SRL                 6'b000010
`define MI32_SRLV                6'b000110
`define MI32_SUB                 6'b100010
`define MI32_SUBU                6'b100011
`define MI32_XOR                 6'b100110
`define MI32_XORI                6'b001110
`define MI32_LUI                 6'b001111

// -----------------------------------------------------------------------------
// mul/div defines
// -----------------------------------------------------------------------------

`define MI32_DIV                 6'b011010
`define MI32_DIVU                6'b011011
`define MI32_MULT                6'b011000
`define MI32_MULTU               6'b011001
`define MI32_MTHI                6'b010001
`define MI32_MTLO                6'b010011
`define MI32_MFHI                6'b010000
`define MI32_MFLO                6'b010010

// -----------------------------------------------------------------------------
// store defines
// -----------------------------------------------------------------------------

`define MI32_SB                  6'b101000
`define MI32_SH                  6'b101001
`define MI32_SW                  6'b101011
//`define MI32_SWL               6'b101010
//`define MI32_SWR               6'b101110

// -----------------------------------------------------------------------------
// load defines
// -----------------------------------------------------------------------------

`define MI32_LB                  6'b100000
`define MI32_LBU                 6'b100100
`define MI32_LH                  6'b100001
`define MI32_LHU                 6'b100101
`define MI32_LW                  6'b100011
`define MI32_LWU                 6'b100111

`define MI32_LL                  6'b110000
`define MI32_SC                  6'b111000

// -----------------------------------------------------------------------------
// spec2 defines
// -----------------------------------------------------------------------------

`define MI32_SPEC2               6'b011100

`define MI32_MADD                6'b000000
`define MI32_MADDU               6'b000001
`define MI32_MUL                 6'b000010

// -----------------------------------------------------------------------------
// cop defines
// -----------------------------------------------------------------------------

`define MI32_COP0                6'b010000
`define MI32_COP1                6'b010001
`define MI32_COP2                6'b010010
`define MI32_COP3                6'b010011

`define MI32_C0                  5'b10000
`define MI32_MFC0                5'b00000
`define MI32_MTC0                5'b00100

`define MI32_RFE                 6'b010000

`define MI32_BREAK               6'b001101
`define MI32_SYSCALL             6'b001100

`define MI32_SYNC                6'b001111

// -----------------------------------------------------------------------------
// trap defines
// -----------------------------------------------------------------------------

`define MI32_TEQ                 6'b110100
`define MI32_TGE                 6'b110000
`define MI32_TGEU                6'b110001
`define MI32_TLT                 6'b110010
`define MI32_TLTU                6'b110011
`define MI32_TNE                 6'b110110

`define MI32_TEQI                5'b01100
`define MI32_TGEI                5'b01000
`define MI32_TGEIU               5'b01001
`define MI32_TLTI                5'b01010
`define MI32_TLTIU               5'b01011
`define MI32_TNEI                5'b01110

// -----------------------------------------------------------------------------
// trap types defines
// -----------------------------------------------------------------------------

`define MI32_NO_TRAP_TYPE        4'd0

`define MI32_TEQ_TYPE            4'd1
`define MI32_TGE_TYPE            4'd2
`define MI32_TGEU_TYPE           4'd3
`define MI32_TLT_TYPE            4'd4
`define MI32_TLTU_TYPE           4'd5
`define MI32_TNE_TYPE            4'd6

`define MI32_TEQI_TYPE           4'd7
`define MI32_TGEI_TYPE           4'd8
`define MI32_TGEIU_TYPE          4'd9
`define MI32_TLTI_TYPE           4'd10
`define MI32_TLTIU_TYPE          4'd11
`define MI32_TNEI_TYPE           4'd12

// -----------------------------------------------------------------------------
// branch types defines
// -----------------------------------------------------------------------------

`define MI32_NO_BRANCH_TYPE      4'd0
`define MI32_BGEZ_TYPE           4'd1
`define MI32_BLTZ_TYPE           4'd2
`define MI32_BEQ_TYPE            4'd3
`define MI32_BGTZ_TYPE           4'd4
`define MI32_BLEZ_TYPE           4'd5
`define MI32_BNE_TYPE            4'd6
`define MI32_BCF_TYPE            4'd7
`define MI32_BCT_TYPE            4'd8
`define MI32_NO_PREDICT_TYPE     4'd15

// -----------------------------------------------------------------------------
// FPU defines
// -----------------------------------------------------------------------------

`define MI32_LWC1                6'b110001
`define MI32_SWC1                6'b111001

`define MI32_MF                  5'b00000
`define MI32_BC                  5'b01000
`define MI32_CF                  5'b00010
`define MI32_CT                  5'b00110
`define MI32_SFMT                5'b10000
`define MI32_WFMT                5'b10100
`define MI32_MT                  5'b00100

`define MI32_FPU_MOVS            6'b000110
`define MI32_FPU_ADDS            6'b000000
`define MI32_FPU_ABSS            6'b000101
`define MI32_FPU_SUBS            6'b000001
`define MI32_FPU_MULS            6'b000010
`define MI32_FPU_DIVS            6'b000011
`define MI32_FPU_CVTWS           6'b100100
`define MI32_FPU_CVTSW           6'b100000
`define MI32_FPU_CEILWS          6'b001110
`define MI32_FPU_FLOORWS         6'b001111
`define MI32_FPU_ROUNDWS         6'b001100
`define MI32_FPU_TRUNCWS         6'b001101
`define MI32_FPU_NEGS            6'b000111
`define MI32_FPU_SQRTS           6'b000100

`define MI32_FPU_CONDS           7'b0000011

`define MI32_FPU_ALU_NO          6'b000000
`define MI32_FPU_ALU_ADDS        6'b000001
`define MI32_FPU_ALU_SUBS        6'b000011
`define MI32_FPU_ALU_MULS        6'b000101
`define MI32_FPU_ALU_DIVS        6'b000111
`define MI32_FPU_ALU_ABSS        6'b010001
`define MI32_FPU_ALU_NEGS        6'b010011
`define MI32_FPU_ALU_SQRTS       6'b010101

`define MI32_FPU_ALU_I2FS        6'b001001
`define MI32_FPU_ALU_F2IS        6'b001011

`define MI32_FPU_ALU_F           6'b100001
`define MI32_FPU_ALU_UN          6'b100011
`define MI32_FPU_ALU_EQ          6'b100101
`define MI32_FPU_ALU_UEQ         6'b100111
`define MI32_FPU_ALU_OLT         6'b101001
`define MI32_FPU_ALU_ULT         6'b101011
`define MI32_FPU_ALU_OLE         6'b101101
`define MI32_FPU_ALU_ULE         6'b101111
`define MI32_FPU_ALU_SF          6'b110001
`define MI32_FPU_ALU_NGLE        6'b110011
`define MI32_FPU_ALU_SEQ         6'b110101
`define MI32_FPU_ALU_NGL         6'b110111
`define MI32_FPU_ALU_LT          6'b111001
`define MI32_FPU_ALU_NGE         6'b111011
`define MI32_FPU_ALU_LE          6'b111101
`define MI32_FPU_ALU_NGT         6'b111111

`define MI32_FPU_RND_RN          2'b00
`define MI32_FPU_RND_RZ          2'b01
`define MI32_FPU_RND_RP          2'b10
`define MI32_FPU_RND_RM          2'b11

// -----------------------------------------------------------------------------
// MI16 defines
// -----------------------------------------------------------------------------

`define MI16_ADDIUSP             5'b00000
`define MI16_ADDIUPC             5'b00001
`define MI16_B                   5'b00010
`define MI16_JALX                5'b00011
`define MI16_BEQZ                5'b00100
`define MI16_BNEZ                5'b00101
`define MI16_SHIFT               5'b00110

`define MI16_RRI                 5'b01000
`define MI16_ADDIU8              5'b01001
`define MI16_SLTI                5'b01010
`define MI16_SLTIU               5'b01011
`define MI16_I8                  5'b01100
`define MI16_LI                  5'b01101
`define MI16_CMPI                5'b01110

`define MI16_LB                  5'b10000
`define MI16_LH                  5'b10001
`define MI16_LWSP                5'b10010
`define MI16_LW                  5'b10011
`define MI16_LBU                 5'b10100
`define MI16_LHU                 5'b10101
`define MI16_LWPC                5'b10110

`define MI16_SB                  5'b11000
`define MI16_SH                  5'b11001
`define MI16_SWSP                5'b11010
`define MI16_SW                  5'b11011
`define MI16_RRR                 5'b11100
`define MI16_RR                  5'b11101
`define MI16_EXTEND              5'b11110

`define MI16_SEB                 3'b100
`define MI16_SEH                 3'b101
`define MI16_ZEB                 3'b000
`define MI16_ZEH                 3'b001

// -----------------------------------------------------------------------------
// decoder defines
// -----------------------------------------------------------------------------

`define MI16_OPCODES             15
`define MI16_OPCODEE             11
`define MI16_FUNCTS              10
`define MI16_FUNCTE              8

`define MI16_RXS                 10
`define MI16_RXE                 8
`define MI16_RYS                 7
`define MI16_RYE                 5
`define MI16_RZS                 4
`define MI16_RZE                 2

// -----------------------------------------------------------------------------
// instructions defines
// -----------------------------------------------------------------------------

`define MI16_BTEQZ               3'b000
`define MI16_BTNEZ               3'b001
`define MI16_SWRASP              3'b010
`define MI16_ADJSP               3'b011
`define MI16_SVRS                3'b100
`define MI16_MOV32R              3'b101
`define MI16_MOVR32              3'b111

`define MI16_JALRC               5'b00000
`define MI16_SDBBR               5'b00001
`define MI16_SLT                 5'b00010
`define MI16_SLTU                5'b00011
`define MI16_SLLV                5'b00100
`define MI16_BREAK               5'b00101
`define MI16_SRLV                5'b00110
`define MI16_SRAV                5'b00111

`define MI16_CMP                 5'b01010
`define MI16_NEG                 5'b01011
`define MI16_AND                 5'b01100
`define MI16_OR                  5'b01101
`define MI16_XOR                 5'b01110
`define MI16_NOT                 5'b01111

`define MI16_MFHI                5'b10000
`define MI16_CNVT                5'b10001
`define MI16_MFLO                5'b10010

`define MI16_MULT                5'b11000
`define MI16_MULTU               5'b11001
`define MI16_DIV                 5'b11010
`define MI16_DIVU                5'b11011


`define MI16_ADDU                2'b01
`define MI16_SUBU                2'b11

`define MI16_SLL                 2'b00
`define MI16_SRL                 2'b10
`define MI16_SRA                 2'b11

// -----------------------------------------------------------------------------
// exceptions defines
// -----------------------------------------------------------------------------

`define MI32_EXC_NONE            8'd0
`define MI32_EXC_OV              8'd1
`define MI32_EXC_LOAD            8'd2
`define MI32_EXC_STORE           8'd3
`define MI32_EXC_SYS             8'd4
`define MI32_EXC_BREAK           8'd5
`define MI32_EXC_UNK             8'd6
`define MI32_EXC_ADDR            8'd7
`define MI32_EXC_PIPE            8'd8
`define MI32_EXC_STACK           8'd9
`define MI32_EXC_PRIV_DATA       8'd10
`define MI32_EXC_PRIV_INST       8'd11
`define MI32_EXC_TRAP            8'd12
`define MI32_EXC_PERIPH          8'd13
`define MI32_EXC_AMBA            8'd14
`define MI32_EXC_INST_BUS        8'd15
`define MI32_EXC_DATA_BUS        8'd16
`define MI32_EXC_FPU             8'd17

`endif // __MI32_DEFINE__
