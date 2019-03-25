/*H*****************************************************************************
*
* Copyright (c) 2017 ChipCraft Sp. z o.o. All rights reserved
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, version 2.
*
* This program is distributed in the hope that it will be useful, but
* WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
* General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>
*
* ******************************************************************************
* File Name : core_template.cpp
* Author    : Krzysztof Marcinek
* ******************************************************************************
* $Date: 2019-03-23 21:05:15 +0100 (Sat, 23 Mar 2019) $
* $Revision: 437 $
*H*****************************************************************************/

#include "Vtestbench.h"
#include "Vtestbench_testbench.h"
#include "Vtestbench_uart_receiver_sim__N1_C2.h"
#include "Vtestbench_uart_veri_receiver_sim.h"
#include "verilated.h"

#if VM_TRACE
    #include "verilated_vcd_c.h"
#endif

int main(int argc, char **argv, char **env){

    Verilated::commandArgs(argc, argv);
    Vtestbench* top = new Vtestbench;

    vluint64_t main_time = 0;

    #if VM_TRACE
        Verilated::traceEverOn(true);
        VerilatedVcdC* tfp = new VerilatedVcdC;
        top->trace(tfp, 99);
        tfp->open("vlsim.vcd");
    #endif

    top->rstn = 1;
    top->clk = 0;

    top->dbg_request = 0;
    top->dbg_data = 0;

    top->uart_request = 0;
    top->uart_data = 0;

    int rx_ready_last = 0;
    int dbg_rx_ready_last = 0;

    for (unsigned i = 0; i < 10; ++i)
    {
        top->clk = !top->clk;
        top->eval();
    }
    top->rstn = 0;
    for (unsigned i = 0; i < 100; ++i)
    {
        top->clk = !top->clk;
        top->eval();
    }
    top->rstn = 1;

    printf("\nStarting asic-core-template...\n\n");
    fflush(stdout);

    while (!Verilated::gotFinish() && (top->dbg_term == 0)){

        top->clk = !top->clk;
        top->eval();

        // receive from dbg
        if (top->testbench->dbg_u_console->rx_ready == 1){
            if (dbg_rx_ready_last == 0){
                VL_PRINTF("<DBG:0x%x>",top->testbench->dbg_u_console->rx_data);
                fflush(stdout);
                dbg_rx_ready_last = 1;
            }
        } else{
            dbg_rx_ready_last = 0;
        }

        // receive from uart
        if (top->testbench->amba_ux_console->rx_ready == 1){
            if (rx_ready_last == 0){
                VL_PRINTF("%c",top->testbench->amba_ux_console->rx_data);
                fflush(stdout);
                rx_ready_last = 1;
            }
        } else{
            rx_ready_last = 0;
        }

        #if VM_TRACE
            tfp->dump(main_time);
        #endif

        main_time++;

    }

        #if VM_TRACE
            tfp->close();
        #endif

    delete top;

    VL_PRINTF("\n main time %d\n\n",main_time);

    exit(0);
}
