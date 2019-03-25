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
// File Name : can_apb.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2018-11-07 21:33:20 +0100 (Wed, 07 Nov 2018) $
// $Revision: 315 $
// -FHDR------------------------------------------------------------------------

module can_apb
#(
    parameter     [31:0]    DEFAULT_INTERRUPT_MAPPING     = 32'd0,
    parameter     [31:0]    TARGET_ASIC                   = 32'd0,
    parameter     [31:0]    TARGET_FPGA                   = 32'd0
)(
    PCLK,
    PCLKon,
    PRESETn,
    PSEL,
    PENABLE,
    PADDR,
    PWRITE,
    PWDATA,
    PREADY,
    PRDATA,
    can_interrupt,
    interrupt_MAPPING,
    clock_request,
    can_rx,
    can_tx,
    can_oe,
    test_mode
);

// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam [31:0] WIDTH     = 32'd32;
localparam [31:0] HWIDTH    = 32'd16;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire                  PCLK;
input wire                  PCLKon;
input wire                  PRESETn;
input wire                  PSEL;
input wire                  PENABLE;
input wire    [9:2]         PADDR;
input wire                  PWRITE;
input wire    [WIDTH-1:0]   PWDATA;
output reg                  PREADY;
output reg    [WIDTH-1:0]   PRDATA;
output wire                 can_interrupt;
output reg    [HWIDTH-2:0]  interrupt_MAPPING;
output wire                 clock_request;
input wire                  can_rx;
output wire                 can_tx;
output reg                  can_oe;
input wire                  test_mode;

// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam    [7:0]     CAN_CLOCK_REQUEST_ADDR        = 8'd64;
localparam    [7:0]     CAN_INTERRUPT_MAPPING_ADDR    = 8'd65;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg     [WIDTH-1:0]     local_reg_data;
reg                     local_reg_select;

reg                     clock_request_reg;
reg                     clock_request_synch;

wire                    PRESETn_synch;

wire    [WIDTH-1:0]     can_data;
wire                    can_cs;
wire                    can_bus_off_on;
wire                    can_inv_interrupt;
wire                    can_clk;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign  clock_request         = clock_request_reg | clock_request_synch;

assign  can_cs                = ((PSEL & PENABLE & PWRITE) | (PSEL & ~PWRITE & ~PENABLE)) & (PADDR != CAN_CLOCK_REQUEST_ADDR) & (PADDR != CAN_INTERRUPT_MAPPING_ADDR);
assign  can_interrupt         = ~can_inv_interrupt;
assign  can_data[WIDTH-1:8]   = {WIDTH-8{1'b0}};

// -----------------------------------------------------------------------------
// reset generator
// -----------------------------------------------------------------------------

rstgen #(
    .WIDTH(3),
    .TARGET_ASIC(TARGET_ASIC),
    .TARGET_FPGA(TARGET_FPGA))
rstgen_can (
    .clk(PCLKon),
    .rstn(PRESETn),
    .test_mode(test_mode),
    .in(1'b1),
    .out(PRESETn_synch));

// -----------------------------------------------------------------------------
// can controller
// -----------------------------------------------------------------------------

can_top
can_top_u (
    .rst_i(~PRESETn_synch),
    .addr_i(PADDR),
    .data_i(PWDATA[7:0]),
    .cs_i(can_cs),
    .we_i(PWRITE),
    .data_o(can_data[7:0]),
    .clk_i(PCLK),
    .rx_i(can_rx),
    .tx_o(can_tx),
    .bus_off_on(can_bus_off_on),
    .irq_on(can_inv_interrupt),
    .clkout_o(can_clk));

// -----------------------------------------------------------------------------
// can output enable logic
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (!PRESETn_synch) begin
        can_oe <= 1'b0;
    end else begin
        if (clock_request) begin
            can_oe <= ~can_bus_off_on;
        end else begin
            can_oe <= 1'b0;
        end
    end
end

// -----------------------------------------------------------------------------
// local registers read data
// -----------------------------------------------------------------------------

always @(posedge PCLK)
begin
    if (PSEL && !PWRITE && !PENABLE) begin
        if (PADDR == CAN_CLOCK_REQUEST_ADDR) begin
            local_reg_data <= {{31{1'b0}},clock_request_reg};
        end
        else if (PADDR == CAN_INTERRUPT_MAPPING_ADDR) begin
            local_reg_data <= {{16{1'b0}},interrupt_MAPPING,1'b0};
        end
    end
end

// -----------------------------------------------------------------------------
// PRDATA logic
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (!PRESETn_synch) begin
        PRDATA <= {WIDTH{1'b0}};
    end else begin
        if (!PREADY) begin
            if (local_reg_select) begin
                PRDATA <= local_reg_data;
            end else begin
                PRDATA <= can_data;
            end
        end else begin
            PRDATA <= {WIDTH{1'b0}};
        end
    end
end

// -----------------------------------------------------------------------------
// local registers select
// -----------------------------------------------------------------------------

always @(posedge PCLK)
begin
    if (PSEL && !PWRITE && !PENABLE) begin
        if ((PADDR == CAN_CLOCK_REQUEST_ADDR) || (PADDR == CAN_INTERRUPT_MAPPING_ADDR)) begin
            local_reg_select <= 1'b1;
        end else begin
            local_reg_select <= 1'b0;
        end
    end
end

// -----------------------------------------------------------------------------
// register power-on clock request
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (!PRESETn_synch) begin
        clock_request_synch <= 1'b1;
    end else begin
        clock_request_synch <= 1'b0;
    end
end

// -----------------------------------------------------------------------------
// PREADY logic
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (!PRESETn_synch) begin
        PREADY <= 1'b1;
    end else begin
        PREADY <= 1'b1;
        if (PSEL && !PENABLE && !PWRITE) begin
            PREADY <= 1'b0;
        end
    end
end

// -----------------------------------------------------------------------------
// clock request register
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (~PRESETn_synch) begin
        clock_request_reg <= 1'b0;
    end else begin
        if (PSEL && PENABLE && PWRITE) begin
            if (PADDR == CAN_CLOCK_REQUEST_ADDR) begin
                clock_request_reg <= PWDATA[0];
            end
        end
    end
end

// -----------------------------------------------------------------------------
// interrupt mapping register
// -----------------------------------------------------------------------------

always @(posedge PCLK or negedge PRESETn_synch)
begin
    if (!PRESETn_synch) begin
        interrupt_MAPPING <= DEFAULT_INTERRUPT_MAPPING[HWIDTH-2:0];
    end else begin
        if (PSEL && PENABLE && PWRITE) begin
            if (PADDR == CAN_INTERRUPT_MAPPING_ADDR) begin
                interrupt_MAPPING <= PWDATA[HWIDTH-1:1];
            end
        end
    end
end

endmodule
