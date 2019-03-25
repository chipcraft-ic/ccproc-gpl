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
// File Name : mul.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-23 15:30:25 +0100 (Sat, 23 Mar 2019) $
// $Revision: 436 $
// -FHDR------------------------------------------------------------------------

`include "timescale.inc"



// -----------------------------------------------------------------------------
// iterative 32-bit signed/unsigned multiplier using 16-bit multiplications
// -----------------------------------------------------------------------------

module mul16x16(clk, rstn, start, madd, accu, op1, op2, hi, lo, finish, addA, addB, addRes, fast);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] RSHARE     = 32'd0;
parameter [31:0] MADD       = 32'd0;
parameter [31:0] FASTMODE   = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire              clk;
input wire              rstn;
input wire              start;
input wire              madd;
input wire  [63:0]      accu;
input wire  [32:0]      op1;
input wire  [32:0]      op2;
input wire              fast;
input wire  [32:0]      addRes;
output wire [31:0]      hi;
output wire [31:0]      lo;
output wire [31:0]      addA;
output wire [31:0]      addB;
output reg              finish;

// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam [2:0]    MUL_STATE_IDLE      = 3'd0;
localparam [2:0]    MUL_STATE_START     = 3'd1;
localparam [2:0]    MUL_STATE_ONE       = 3'd2;
localparam [2:0]    MUL_STATE_TWO       = 3'd3;
localparam [2:0]    MUL_STATE_SUM       = 3'd4;
localparam [2:0]    MUL_STATE_FINISH    = 3'd5;
localparam [2:0]    MUL_STATE_FAST      = 3'd6;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg         [2:0]       state;
reg         [16:0]      mul1;
reg         [16:0]      mul2;
reg         [31:0]      tlo;
reg         [31:0]      thi;

reg         [31:0]      fast_tlo;
reg                     fast_thi;
reg                     fast_exec;

reg         [31:0]      int_addA;
reg         [31:0]      int_addB;

reg                     stage_1_ov;
reg                     stage_2_ov;

reg         [32:0]      reg_op1;
reg         [32:0]      reg_op2;

wire        [31:0]      mulo;
wire        [32:0]      int_addRes_lo;
wire        [30:0]      int_addRes_hi;

wire signed [16:0]      mulA;
wire signed [16:0]      mulB;
wire signed [33:0]      mulQ;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign  mulA            = $signed(mul1);
assign  mulB            = $signed(mul2);

assign  mulo            = mulQ[31:0];
assign  mulQ            = mulA * mulB;

generate

// -----------------------------------------------------------------------------
// without fast mode
// -----------------------------------------------------------------------------

if (FASTMODE == 0) begin
    assign  hi          = thi[31:0];
    assign  lo          = tlo[31:0];
end

// -----------------------------------------------------------------------------
// fast mode - single cycle 16-bit multiplication
// -----------------------------------------------------------------------------

else begin
    assign  hi          = fast_exec ? {32{fast_thi}} : thi[31:0];
    assign  lo          = fast_exec ? fast_tlo[31:0] : tlo[31:0];
end
endgenerate

generate

// -----------------------------------------------------------------------------
// without resource sharing
// -----------------------------------------------------------------------------

if (RSHARE == 0) begin
    if (MADD == 0) begin
        assign  int_addRes_lo  = int_addA + int_addB;
        assign  int_addRes_hi  = 31'd0;
    end else begin
        assign  {int_addRes_hi,int_addRes_lo} = int_addA + int_addB;
    end
    assign  addA           = 32'd0;
    assign  addB           = 32'd0;
end

// -----------------------------------------------------------------------------
// with resource sharing
// -----------------------------------------------------------------------------

else begin
    assign  int_addRes_hi  = 31'd0;
    assign  int_addRes_lo  = addRes;
    assign  addA           = int_addA;
    assign  addB           = int_addB;
end

// -----------------------------------------------------------------------------
// unused signals
// -----------------------------------------------------------------------------

if (FASTMODE == 0) begin
    wire    fast_zero_bit = 1'b0;
    always @(*) begin
        fast_tlo <= {32{fast_zero_bit}};
        fast_thi <= fast_zero_bit;
        fast_exec <= fast_zero_bit;
    end
end
endgenerate

// -----------------------------------------------------------------------------
// main state machine
// -----------------------------------------------------------------------------

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        finish <= 1'b1;
        state <= MUL_STATE_IDLE;
        mul1 <= 17'd0;
        mul2 <= 17'd0;
        int_addA <= 32'd0;
        int_addB <= 32'd0;
        stage_1_ov <= 1'b0;
        stage_2_ov <= 1'b0;
        reg_op1 <= 33'd0;
        reg_op2 <= 33'd0;
        tlo <= 32'd0;
        thi <= 32'd0;
        if (FASTMODE == 1) begin
            fast_tlo <= 32'd0;
            fast_thi <= 1'b0;
            fast_exec <= 1'b0;
        end
    end else begin
        if (!finish) begin
            stage_2_ov <= mulQ[32];
            int_addB <= mulo[31:0];
            if (FASTMODE == 1) begin
                fast_thi <= mulo[31];
                fast_tlo[31:0] <= mulo[31:0];
            end
        end
        case (state)
        MUL_STATE_IDLE: begin
            if (start == 1'b1) begin
                finish <= 1'b0;
                stage_1_ov <= 1'b0;
                if (FASTMODE == 0) begin
                    state <= MUL_STATE_START;
                    mul1[16] <= 1'b0;
                    mul2[16] <= 1'b0;
                end else begin
                    if (!fast) begin
                        state <= MUL_STATE_START;
                        mul1[16] <= 1'b0;
                        mul2[16] <= 1'b0;
                        fast_exec <= 1'b0;
                    end else begin
                        state <= MUL_STATE_FAST;
                        mul1[16] <= op1[15];
                        mul2[16] <= op2[15];
                        fast_exec <= 1'b1;
                    end
                end
                mul1[15:0] <= op1[15:0];
                mul2[15:0] <= op2[15:0];
                reg_op1 <= op1;
                reg_op2 <= op2;
            end
        end
        MUL_STATE_START: begin
            state <= MUL_STATE_ONE;
            mul1[16:0] <= reg_op1[32:16];
            mul2[16:0] <= {1'b0,reg_op2[15:0]};
            tlo[15:0] <= mulo[15:0];
        end
        MUL_STATE_ONE: begin
            state <= MUL_STATE_TWO;
            mul1[16:0] <= {1'b0,reg_op1[15:0]};
            mul2[16:0] <= reg_op2[32:16];
            int_addA <= {{16{1'b0}},int_addB[31:16]};
        end
        MUL_STATE_TWO: begin
            state <= MUL_STATE_SUM;
            mul1[16:0] <= reg_op1[32:16];
            mul2[16:0] <= reg_op2[32:16];
            int_addA <= int_addRes_lo[31:0];
            if (stage_2_ov) begin
                stage_1_ov <= 1'b1;
            end
        end
        MUL_STATE_SUM: begin
            state <= MUL_STATE_FINISH;
            tlo[31:16] <= int_addRes_lo[15:0];
            if (stage_1_ov || stage_2_ov) begin
                int_addA[15:0] <= int_addRes_lo[31:16];
                if ({stage_1_ov,stage_2_ov} == 2'b11) begin
                    if (int_addRes_lo[32]) begin
                        int_addA[31:16] <= 16'hFFFF;
                    end else begin
                        int_addA[31:16] <= 16'hFFFE;
                    end
                end else begin
                    if (!int_addRes_lo[32]) begin
                        int_addA[31:16] <= 16'hFFFF;
                    end else begin
                        int_addA[31:16] <= 16'h0000;
                    end
                end
            end else begin
                int_addA <= {{15{1'b0}},int_addRes_lo[32:16]};
            end
        end
        MUL_STATE_FINISH: begin
            thi[31:0] <= int_addRes_lo[31:0];
            finish <= 1'b1;
            state <= MUL_STATE_IDLE;
        end
        MUL_STATE_FAST: begin
            if (FASTMODE == 0) begin
                state <= MUL_STATE_IDLE;
                finish <= 1'b1;
            end else begin
                finish <= 1'b1;
                state <= MUL_STATE_IDLE;
            end
        end
        default: begin
            state <= MUL_STATE_IDLE;
            finish <= 1'b1;
        end
        endcase
    end
end

// -----------------------------------------------------------------------------
// configuration sanity check
// -----------------------------------------------------------------------------

`ifndef GATE
initial begin
    if ((MADD == 1) && (RSHARE == 1)) begin
        $display("CONFIG_ERROR: Unsupported MADD/RSHARE configuration!");
        $finish;
    end
end
`endif

endmodule



// -----------------------------------------------------------------------------
// single cycle 32-bit multiplication
// -----------------------------------------------------------------------------

module mul32x32(op1, op2, en, hi, lo);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] MADD   = 32'd0;
parameter [31:0] OPIS   = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire  [32:0]      op1;
input wire  [32:0]      op2;
input wire              en;
output wire [31:0]      hi;
output wire [31:0]      lo;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

wire  [32:0]      op1en;
wire  [32:0]      op2en;

wire  [1:0]       dummy;

generate

// -----------------------------------------------------------------------------
// operand isolation
// -----------------------------------------------------------------------------

    if (OPIS == 1) begin
        assign    op1en = en ? op1 : 33'd0;
        assign    op2en = en ? op2 : 33'd0;
    end

// -----------------------------------------------------------------------------
// without operand isolation
// -----------------------------------------------------------------------------

    else begin
        assign    op1en = op1;
        assign    op2en = op2;
    end
endgenerate

// -----------------------------------------------------------------------------
// assign output
// -----------------------------------------------------------------------------

assign    {dummy,hi,lo} = $unsigned(mult32($signed(op1en), $signed(op2en)));

// -----------------------------------------------------------------------------
// configuration sanity check
// -----------------------------------------------------------------------------

`ifndef GATE
initial begin
    if (MADD == 1) begin
        $display("CONFIG_ERROR: Unsupported MADD configuration!");
        $finish;
    end
end
`endif

// -----------------------------------------------------------------------------
// mult32 function
// -----------------------------------------------------------------------------

function signed [65:0] mult32;
input signed [32:0] A;
input signed [32:0] B;
begin
    mult32 = A * B;
end
endfunction

endmodule



// -----------------------------------------------------------------------------
// 32-bit signed/unsigned multiplier using four hardware 16-bit multipliers
// -----------------------------------------------------------------------------

module fpga_mul16x16(clk, rstn, start, madd, accu, op1, op2, fast, hi, lo, finish);

// -----------------------------------------------------------------------------
// parameters
// -----------------------------------------------------------------------------

parameter [31:0] MADD = 32'd0;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire          clk;
input wire          rstn;
input wire          start;
input wire          fast;
input wire          madd;
input wire  [63:0]  accu;
input wire  [32:0]  op1;
input wire  [32:0]  op2;
output reg  [31:0]  hi;
output reg  [31:0]  lo;
output reg          finish;

// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam [2:0]    MUL_STATE_IDLE      = 3'd0;
localparam [2:0]    MUL_STATE_START     = 3'd1;
localparam [2:0]    MUL_STATE_COMP      = 3'd2;
localparam [2:0]    MUL_STATE_FINISH    = 3'd3;
localparam [2:0]    MUL_STATE_FAST      = 3'd4;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg     [2:0]       state;

reg     [33:0]      mul1;
reg     [33:0]      mul2;
reg     [33:0]      mul3;
reg     [33:0]      mul4;
reg     [33:0]      mul5;

reg     [32:0]      int_op1;
reg     [32:0]      int_op2;

wire    [63:0]      addB;
wire    [63:0]      mul;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign  addB    = {{14{mul3[33]}},mul3,{16{1'b0}}};
assign  mul     = {mul1[31:0],mul2[31:0]};

// -----------------------------------------------------------------------------
// main state machine
// -----------------------------------------------------------------------------

always @(posedge clk or negedge rstn)
begin
    if (!rstn) begin
        finish <= 1'b1;
        state <= MUL_STATE_IDLE;
        mul1 <= 34'd0;
        mul2 <= 34'd0;
        mul3 <= 34'd0;
        mul4 <= 34'd0;
        mul5 <= 34'd0;
        int_op1 <= 33'd0;
        int_op2 <= 33'd0;
        hi <= 32'd0;
        lo <= 32'd0;
    end else begin
        if ((start == 1'b1) && (finish == 1'b1)) begin
            finish <= 1'b0;
            if (!fast) begin
                state <= MUL_STATE_START;
            end else begin
                state <= MUL_STATE_FAST;
                mul5 <= mult17({op1[15],op1[15:0]},{op2[15],op2[15:0]});
            end
            int_op1 <= op1;
            int_op2 <= op2;
        end else begin
            case (state)
            MUL_STATE_IDLE: begin
            end
            MUL_STATE_START: begin
                state <= MUL_STATE_COMP;
                mul1 <= $unsigned(mult17(int_op1[32:16],int_op2[32:16]));
                mul2 <= $unsigned(mult17({1'b0,int_op1[15:0]},{1'b0,int_op2[15:0]}));
                mul3 <= $unsigned(mult17({1'b0,int_op1[15:0]},int_op2[32:16]));
                mul4 <= $unsigned(mult17(int_op1[32:16],{1'b0,int_op2[15:0]}));
            end
            MUL_STATE_COMP: begin
                state <= MUL_STATE_FINISH;
                mul3 <= mul3 + mul4;
            end
            MUL_STATE_FINISH: begin
                {hi,lo} <= mul + addB;
                finish <= 1'b1;
                state <= MUL_STATE_IDLE;
            end
            MUL_STATE_FAST: begin
                lo[31:0] <= mul5[31:0];
                hi[31:0] <= {{32{mul5[31]}}};
                finish <= 1'b1;
                state <= MUL_STATE_IDLE;
            end
            default: begin
                finish <= 1'b1;
                state <= MUL_STATE_IDLE;
            end
            endcase
        end
    end
end

// -----------------------------------------------------------------------------
// mult17 function
// -----------------------------------------------------------------------------

function signed [33:0] mult17;
input signed [16:0] A;
input signed [16:0] B;
begin
    mult17 = A * B;
end
endfunction

endmodule
