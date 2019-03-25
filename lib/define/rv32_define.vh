// +FHDR------------------------------------------------------------------------
//
// Copyright (c) 2018 ChipCraft Sp. z o.o. All rights reserved
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

`ifndef __RV32_DEFINE__
`define __RV32_DEFINE__

// -----------------------------------------------------------------------------
// decoder defines
// -----------------------------------------------------------------------------

`define RV32_RDS                11
`define RV32_RDE                7
`define RV32_OPS                6
`define RV32_OPE                0
`define RV32_F3S                14
`define RV32_F3E                12
`define RV32_F7S                31
`define RV32_F7E                25
`define RV32_F7OP               30
`define RV32_RS1S               19
`define RV32_RS1E               15
`define RV32_RS2S               24
`define RV32_RS2E               20
`define RV32_SHAMS              24
`define RV32_SHAME              20
`define RV32_IMMS               31
`define RV32_IMME               20
`define RV32_FUN_VAR            5
`define RV32_FUN_RIG            14
`define RV32_FUN_ARI            30

// -----------------------------------------------------------------------------
// destination register
// -----------------------------------------------------------------------------

`define RV32_WRD                2'b01

// -----------------------------------------------------------------------------
// stack pointer register
// -----------------------------------------------------------------------------

`define RV32_SPREG              5'd2

// -----------------------------------------------------------------------------
// ALU defines
// -----------------------------------------------------------------------------

`define RV32_ALU_ADD            5'b00000
`define RV32_ALU_SUB            5'b00001
`define RV32_ALU_OR             5'b00010
`define RV32_ALU_AND            5'b00011
`define RV32_ALU_XOR            5'b00100
`define RV32_ALU_SL             5'b00101
`define RV32_ALU_SR             5'b00110
`define RV32_ALU_SLT            5'b00111
`define RV32_ALU_LUI            5'b01000
`define RV32_ALU_NO             5'b11110

`define RV32_ALU_MUL            5'b01001
`define RV32_ALU_DIV            5'b01010

// -----------------------------------------------------------------------------
// arithmetical/logical defines
// -----------------------------------------------------------------------------

`define RV32_OP                 7'b0110011

`define RV32_ADD_SUB            3'b000
`define RV32_SLL                3'b001
`define RV32_SLT                3'b010
`define RV32_SLTU               3'b011
`define RV32_XOR                3'b100
`define RV32_SRL_SRA            3'b101
`define RV32_OR                 3'b110
`define RV32_AND                3'b111

`define RV32_IMM                7'b0010011
`define RV32_LUI                7'b0110111
`define RV32_AUIPC              7'b0010111

`define RV32_ADDI               3'b000
`define RV32_SLTI               3'b010
`define RV32_SLTIU              3'b011
`define RV32_XORI               3'b100
`define RV32_ORI                3'b110
`define RV32_ANDI               3'b111
`define RV32_SLLI               3'b001
`define RV32_SRLI_SRAI          3'b101

// -----------------------------------------------------------------------------
// branch defines
// -----------------------------------------------------------------------------

`define RV32_BRAN               7'b1100011

`define RV32_BEQ                3'b000
`define RV32_BNE                3'b001
`define RV32_BLT                3'b100
`define RV32_BGE                3'b101
`define RV32_BLTU               3'b110
`define RV32_BGEU               3'b111

// -----------------------------------------------------------------------------
// jump defines
// -----------------------------------------------------------------------------

`define RV32_JAL                7'b1101111
`define RV32_JALR               7'b1100111

// -----------------------------------------------------------------------------
// load defines
// -----------------------------------------------------------------------------

`define RV32_LOAD               7'b0000011

`define RV32_LB                 3'b000
`define RV32_LH                 3'b001
`define RV32_LW                 3'b010
`define RV32_LBU                3'b100
`define RV32_LHU                3'b101

// -----------------------------------------------------------------------------
// store defines
// -----------------------------------------------------------------------------

`define RV32_STORE              7'b0100011

`define RV32_SB                 3'b000
`define RV32_SH                 3'b001
`define RV32_SW                 3'b010

// -----------------------------------------------------------------------------
// mul/div defines
// -----------------------------------------------------------------------------

`define RV32_MUL                3'b000
`define RV32_MULH               3'b001
`define RV32_MULHSU             3'b010
`define RV32_MULHU              3'b011
`define RV32_DIV                3'b100
`define RV32_DIVU               3'b101
`define RV32_REM                3'b110
`define RV32_REMU               3'b111

// -----------------------------------------------------------------------------
// fence defines
// -----------------------------------------------------------------------------

`define RV32_FEN                7'b0001111

`define RV32_FENCE              3'b000
`define RV32_FENCEI             3'b001

// -----------------------------------------------------------------------------
// sys defines
// -----------------------------------------------------------------------------

`define RV32_SYS                7'b1110011

`define RV32_PRIV               3'b000
`define RV32_CSRRW              3'b001
`define RV32_CSRRS              3'b010
`define RV32_CSRRC              3'b011
`define RV32_CSRRWI             3'b101
`define RV32_CSRRSI             3'b110
`define RV32_CSRRCI             3'b111

`define RV32_SFENCEVMA          7'b0001001
`define RV32_ECALL              12'b000000000000
`define RV32_EBREAK             12'b000000000001
`define RV32_URET               12'b000000000010
`define RV32_SRET               12'b000100000010
`define RV32_MRET               12'b001100000010
`define RV32_WFI                12'b000100000101

// -----------------------------------------------------------------------------
// branch types defines
// -----------------------------------------------------------------------------

`define RV32_NO_BRANCH_TYPE     4'd0
`define RV32_BGE_TYPE           4'd1
`define RV32_BGEU_TYPE          4'd2
`define RV32_BEQ_TYPE           4'd3
`define RV32_BLT_TYPE           4'd4
`define RV32_BLTU_TYPE          4'd5
`define RV32_BNE_TYPE           4'd6
`define RV32_ISYNC_TYPE         4'd7

// -----------------------------------------------------------------------------
// NOP instruction
// -----------------------------------------------------------------------------

`define RV32_NOP_INSTR          32'h00000013

// -----------------------------------------------------------------------------
// FPU defines
// -----------------------------------------------------------------------------

`define RV32_FPU_ALU_NO         6'b000000

// -----------------------------------------------------------------------------
// mode defines
// -----------------------------------------------------------------------------

`define RV32_MACHINE_MODE       2'b11
`define RV32_SUPERVISOR_MODE    2'b01
`define RV32_USER_MODE          2'b00

// -----------------------------------------------------------------------------
// exception defines
// -----------------------------------------------------------------------------

`define RV32_EXC_INST_MISAL     8'd0
`define RV32_EXC_INST_ACC_FLT   8'd1
`define RV32_EXC_ILLEGAL        8'd2
`define RV32_EXC_BREAK          8'd3
`define RV32_EXC_LOAD_MISAL     8'd4
`define RV32_EXC_LOAD_ACC_FLT   8'd5
`define RV32_EXC_STORE_MISAL    8'd6
`define RV32_EXC_STORE_ACC_FLT  8'd7
`define RV32_EXC_CALL_U_MODE    8'd8
`define RV32_EXC_CALL_S_MODE    8'd9
`define RV32_EXC_CALL_M_MODE    8'd11
`define RV32_EXC_INST_PAGE_FLT  8'd12
`define RV32_EXC_LOAD_PAGE_FLT  8'd13
`define RV32_EXC_STPRE_PAGE_FLT 8'd15

`endif // __RV32_DEFINE__
