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
// File Name : onewire_apb.v
// Author    : Krzysztof Marcinek
// -----------------------------------------------------------------------------
// $Date: 2019-03-12 23:20:59 +0100 (Tue, 12 Mar 2019) $
// $Revision: 421 $
// -FHDR------------------------------------------------------------------------

module onewire_apb
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
    one_wire_interrupt,
    interrupt_MAPPING,
    clock_request,
    one_wire_rx,
    one_wire_tx,
    one_wire_oe,
    test_mode
);


// -----------------------------------------------------------------------------
// local parameters
// -----------------------------------------------------------------------------

localparam    [31:0]    WIDTH     = 32'd32;
localparam    [31:0]    HWIDTH    = 32'd16;

localparam    [7:0]     ONE_WIRE_CLOCK_REQUEST_ADDR        = 2'd2;
localparam    [7:0]     ONE_WIRE_INTERRUPT_MAPPING_ADDR    = 2'd3;

// -----------------------------------------------------------------------------
// ports
// -----------------------------------------------------------------------------

input wire                  PCLK;
input wire                  PCLKon;
input wire                  PRESETn;
input wire                  PSEL;
input wire                  PENABLE;
input wire    [3:2]         PADDR;
input wire                  PWRITE;
input wire    [WIDTH-1:0]   PWDATA;
output reg                  PREADY;
output reg    [WIDTH-1:0]   PRDATA;
output wire                 one_wire_interrupt;
output reg    [HWIDTH-2:0]  interrupt_MAPPING;
output wire                 clock_request;
input wire                  one_wire_rx;
output wire                 one_wire_tx;
output wire                 one_wire_oe;
input wire                  test_mode;

// -----------------------------------------------------------------------------
// local regs and wires
// -----------------------------------------------------------------------------

reg     [WIDTH-1:0]     local_reg_data;
reg                     local_reg_select;

reg                     clock_request_reg;
reg                     clock_request_synch;

wire                    PRESETn_synch;

wire                    one_wire_ren;
wire                    one_wire_wen;
wire                    one_wire_adr;
wire    [WIDTH-1:0]     one_wire_rdt;
wire                    one_wire_clk;
wire                    one_wire_e;

// -----------------------------------------------------------------------------
// assigns
// -----------------------------------------------------------------------------

assign  one_wire_oe           = one_wire_tx | one_wire_e;

assign  clock_request         = clock_request_reg | clock_request_synch;

assign  one_wire_ren          = (PSEL & ~PWRITE & ~PENABLE) & (PADDR != ONE_WIRE_CLOCK_REQUEST_ADDR) & (PADDR != ONE_WIRE_INTERRUPT_MAPPING_ADDR);
assign  one_wire_wen          = (PSEL & PENABLE & PWRITE)   & (PADDR != ONE_WIRE_CLOCK_REQUEST_ADDR) & (PADDR != ONE_WIRE_INTERRUPT_MAPPING_ADDR);

// -----------------------------------------------------------------------------
// reset generation
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
// one wire controller
// -----------------------------------------------------------------------------

sockit_owm
one_wire_u (
    .clk(PCLK),
    .rst(~PRESETn_synch),
    .bus_ren(one_wire_ren),
    .bus_wen(one_wire_wen),
    .bus_adr(PADDR[2]),
    .bus_wdt(PWDATA),
    .bus_rdt(one_wire_rdt),
    .bus_irq(one_wire_interrupt),
    .owr_p(one_wire_tx),
    .owr_e(one_wire_e),
    .owr_i(one_wire_rx));

// -----------------------------------------------------------------------------
// local registers read data
// -----------------------------------------------------------------------------

always @(posedge PCLK)
begin
    if (PSEL && !PWRITE && !PENABLE) begin
        if (PADDR == ONE_WIRE_CLOCK_REQUEST_ADDR) begin
            local_reg_data <= {{31{1'b0}},clock_request_reg};
        end
        else if (PADDR == ONE_WIRE_INTERRUPT_MAPPING_ADDR) begin
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
                PRDATA <= one_wire_rdt;
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
        if ((PADDR == ONE_WIRE_CLOCK_REQUEST_ADDR) || (PADDR == ONE_WIRE_INTERRUPT_MAPPING_ADDR)) begin
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
            if (PADDR == ONE_WIRE_CLOCK_REQUEST_ADDR) begin
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
            if (PADDR == ONE_WIRE_INTERRUPT_MAPPING_ADDR) begin
                interrupt_MAPPING <= PWDATA[HWIDTH-1:1];
            end
        end
    end
end

endmodule
