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
// File Name : edge_detector.v
// Author    : Maciej Plasota
// -----------------------------------------------------------------------------
// $Date: 2017-04-04 16:52:50 +0200 (Tue, 04 Apr 2017) $
// $Revision: 22 $
// -FHDR------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//  Rising edge detector model
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect rising edge on
//
//  OUTPUTS:
//  rising_edge - positive pulse (1 clock cycle) appears on rising egde detection
// -----------------------------------------------------------------------------

module rising_edge_detector(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output reg rising_edge
);

reg prev_value;

//previous signal value register
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_value <= 1'b1;
    end else begin
        if(enable == 1'b1) begin
            prev_value <= DataIn;
        end else begin
            prev_value <= 1'b1;
        end
    end
end

always @* begin
    if((prev_value == 1'b0) && (DataIn == 1'b1) && (enable == 1'b1)) begin
        rising_edge = 1'b1;
    end else begin
        rising_edge = 1'b0;
    end
end

endmodule

// -----------------------------------------------------------------------------
//  Falling edge detector model
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect falling edge on
//
//  OUTPUTS:
//  falling_edge - positive pulse (1 clock cycle) appears on falling egde detection
// -----------------------------------------------------------------------------*/
module falling_edge_detector(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output reg falling_edge
);

reg prev_value;
//previous signal value register
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_value <= 1'b0;
    end else begin
        if(enable == 1'b1) begin
            prev_value <= DataIn;
        end else begin
            prev_value <= 1'b0;
        end
    end
end

always @* begin
    if((prev_value == 1'b1) && (DataIn == 1'b0) && (enable == 1'b1)) begin
        falling_edge = 1'b1;
    end else begin
        falling_edge = 1'b0;
    end
end

endmodule

// -----------------------------------------------------------------------------
//  Rising edge detector model (with dataout from the flip-flop)
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect rising edge on
//
//  OUTPUTS:
//  rising_edge - positive pulse (1 clock cycle) appears on rising egde detection
//  DataOut - output from the flip-flop
// -----------------------------------------------------------------------------*/
module rising_edge_detector_with_dataout(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output reg DataOut,
    output reg rising_edge
);

reg prev_value;

//previous signal value register
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_value <= 1'b1;
        DataOut <= 1'b0;
    end else begin
        if(enable == 1'b1) begin
            prev_value <= DataIn;
            DataOut <= DataIn;
        end else begin
            prev_value <= 1'b1;
            DataOut <= 1'b0;
        end
    end
end

always @* begin
    if((prev_value == 1'b0) && (DataIn == 1'b1) && (enable == 1'b1)) begin
        rising_edge = 1'b1;
    end else begin
        rising_edge = 1'b0;
    end
end

endmodule

// -----------------------------------------------------------------------------
//  Falling edge detector model (with dataout from the flip-flop)
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect falling edge on
//
//  OUTPUTS:
//  falling_edge - positive pulse (1 clock cycle) appears on falling egde detection
//  DataOut - output from the flip-flop
// -----------------------------------------------------------------------------*/
module falling_edge_detector_with_dataout(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output wire DataOut,
    output reg falling_edge
);

reg prev_value;
//previous signal value register
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_value <= 1'b0;
    end else begin
        if(enable == 1'b1) begin
            prev_value <= DataIn;
        end else begin
            prev_value <= 1'b0;
        end
    end
end

always @* begin
    if((prev_value == 1'b1) && (DataIn == 1'b0) && (enable == 1'b1)) begin
        falling_edge = 1'b1;
    end else begin
        falling_edge = 1'b0;
    end
end

assign DataOut = falling_edge;

endmodule

// -----------------------------------------------------------------------------
//  Rising and falling edges detector model
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect rising or falling edge on
//
//  OUTPUTS:
//  rising_edge - positive pulse (1 clock cycle) appears on rising egde detection
//  falling_edge - positive pulse (1 clock cycle) appears on falling egde detection
// -----------------------------------------------------------------------------*/
module edge_detector(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output reg rising_edge,
    output reg falling_edge
);

//////////////////////////////
// Falling edge detection model
reg prev_fe_value;
//previous signal value register for falling edge detection
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_fe_value <= 1'b0;
    end else begin
        if(enable == 1'b1) begin
            prev_fe_value <= DataIn;
        end else begin
            prev_fe_value <= 1'b0;
        end
    end
end

always @* begin
    if((prev_fe_value == 1'b1) && (DataIn == 1'b0) && (enable == 1'b1)) begin
        falling_edge = 1'b1;
    end else begin
        falling_edge = 1'b0;
    end
end

//////////////////////////////
// Rising edge detection model
reg prev_re_value;
//previous signal value register for rising edge detection
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_re_value <= 1'b1;
    end else begin
        if(enable == 1'b1) begin
            prev_re_value <= DataIn;
        end else begin
            prev_re_value <= 1'b1;
        end
    end
end

always @* begin
    if((prev_re_value == 1'b0) && (DataIn == 1'b1) && (enable == 1'b1)) begin
        rising_edge = 1'b1;
    end else begin
        rising_edge = 1'b0;
    end
end

endmodule

// -----------------------------------------------------------------------------
//  Rising and falling edges detector model (with dataout from the flip-flop)
// -----------------------------------------------------------------------------
//  INPUTS:
//  clk - clock
//  nRST - reset (active low)
//  enable - enable (active high)
//  DataIn - data line to detect rising or falling edge on
//
//  OUTPUTS:
//  rising_edge - positive pulse (1 clock cycle) appears on rising egde detection
//  falling_edge - positive pulse (1 clock cycle) appears on falling egde detection
//  DataOut - output from the flip-flop
// -----------------------------------------------------------------------------*/
module edge_detector_with_dataout(
    input wire clk,
    input wire nRST,
    input wire enable,
    input wire DataIn,
    output wire DataOut,
    output reg rising_edge,
    output reg falling_edge
);

//////////////////////////////
// Falling edge detection model
reg prev_fe_value;
//previous signal value register for falling edge detection
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_fe_value <= 1'b0;
    end else begin
        if(enable == 1'b1) begin
            prev_fe_value <= DataIn;
        end else begin
            prev_fe_value <= 1'b0;
        end
    end
end

always @* begin
    if((prev_fe_value == 1'b1) && (DataIn == 1'b0) && (enable == 1'b1)) begin
        falling_edge = 1'b1;
    end else begin
        falling_edge = 1'b0;
    end
end

//////////////////////////////
// Rising edge detection model
reg prev_re_value;
//previous signal value register for rising edge detection
always @(posedge clk or negedge nRST) begin
    if(nRST == 1'b0) begin
        prev_re_value <= 1'b1;
    end else begin
        if(enable == 1'b1) begin
            prev_re_value <= DataIn;
        end else begin
            prev_re_value <= 1'b1;
        end
    end
end

always @* begin
    if((prev_re_value == 1'b0) && (DataIn == 1'b1) && (enable == 1'b1)) begin
        rising_edge = 1'b1;
    end else begin
        rising_edge = 1'b0;
    end
end

assign DataOut = prev_fe_value;

endmodule
