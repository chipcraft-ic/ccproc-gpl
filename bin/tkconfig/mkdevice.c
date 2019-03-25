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
* File Name : mkdevice.c
* Author    : Krzysztof Marcinek
* ******************************************************************************
* $Date: 2019-03-23 15:30:25 +0100 (Sat, 23 Mar 2019) $
* $Revision: 436 $
*H*****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <string.h>

#define VAL(x)       strtoul(x,(char **)NULL,0)

#define MAX_CORES        16
#define MAX_GNSS_CORES   16
#define MAX_DMA          7

#define FULL_ADDRESS     32

FILE * fp;

int i;

/* ----------------------------------------------------------------------- */
/* -- Add new variables here                                               */
/* ----------------------------------------------------------------------- */

/* Synthesis */
int CONFIG_TARGET_FPGA = 0;
int CONFIG_TARGET_ASIC = 0;

/* Clock */
int CONFIG_CLK = 0;

/* DFT */
int CONFIG_DFT_MEM = 0;

/* Processor */

/* Integer unit */
int CONFIG_CORE_NUM = 1;
int CONFIG_RV32_EN = 0;
int CONFIG_BP = 0;
int CONFIG_MULDIV_EN = 0;
int CONFIG_MUL_SCHEME = 0;
int CONFIG_MADD_EN = 0;
int CONFIG_OPIS_EN = 0;
int CONFIG_CGCG_EN = 0;
int CONFIG_EXTCG_EN = 0;
int CONFIG_AROPT_EN = 0;
int CONFIG_FAST_EN = 0;
int CONFIG_ISA16_EN = 0;
int CONFIG_MI16_EN = 0;
int CONFIG_RV16_EN = 0;
int CONFIG_COP_EN = 0;
int CONFIG_ROM_START = 0;
int CONFIG_ROM_END = 1;
int CONFIG_RAM_START = 4;
int CONFIG_RAM_END = 7;
int CONFIG_MAX_MEM_BUS = 0;

/* Fault tolerance */
int CONFIG_LOCKSTEP_EN = 0;
int CONFIG_ICACHE_FTBITS = 0;
int CONFIG_DCACHE_FTBITS = 0;

/* FPU unit */
int CONFIG_FPU_EN = 0;
int CONFIG_FPU_NUM = 0;

/* Cache system */
int CONFIG_DMEM_SIZE = 0;
int CONFIG_IMEM_SIZE = 0;
int CONFIG_DMEM_BUS = 0;
int CONFIG_IMEM_BUS = 0;
int CONFIG_ICACHE_EN = 0;
int CONFIG_BOOT_EN = 0;
int CONFIG_BIG_ENDIAN = 1;
int CONFIG_FULLADDR_EN = 0;
int CONFIG_DMA_BURST_EN = 0;
int CONFIG_ICACHE_SIZE = 9;
int CONFIG_ICACHE_WAY = 1;
int CONFIG_ILINE_SIZE = 0;
int CONFIG_ILRR_ALG = 0;
int CONFIG_IRND_ALG = 1;
int CONFIG_RLDEL_EN = 0;
int CONFIG_DCTRL_USERS = 0;
int CONFIG_DCTRL_EN = 1;

int CONFIG_ICTRL_BASEADDR = 7;

int CONFIG_DCACHE_EN = 0;
int CONFIG_DCACHE_SIZE = 10;
int CONFIG_DLINE_SIZE = 1;
int CONFIG_DCACHE_WAY = 1;
int CONFIG_DLRR_ALG = 0;
int CONFIG_DRND_ALG = 1;
int CONFIG_DCACHE_IMPL = 0;

int CONFIG_DCTRL_BASEADDR = 7;

/* Debugging */
int CONFIG_SHOW_STALL = 0;
int CONFIG_SHOW_TIME = 0;
int CONFIG_DISASM_EN = 0;
int CONFIG_STAT_EN = 0;
int CONFIG_EMULATOR_EN = 0;
int CONFIG_EMULATOR_ZERO = 0;
int CONFIG_EMULATOR_VIRT = 0;
int CONFIG_DEBUG_EN = 0;
int CONFIG_DEBUG_START = 9;
int CONFIG_JTAG_EN = 0;
int CONFIG_JTAG_IDCODE = 0;
int CONFIG_CORE_BAUD = 20;

/* Peripherals */
int CONFIG_PERIPH_START = 3;
int CONFIG_PERIPH_RAM = 2;
int CONFIG_PERIPH_MAX = 12;

/* MT Controller */
int CONFIG_MT_BASEADDR = 1;

/* Power management */
int CONFIG_PMNG_EN = 0;
int CONFIG_PMNG_PWD_EN = 0;
int CONFIG_PMNG_PRESC_EN = 0;
int CONFIG_PMNG_BASEADDR = 2;

/* PMEM */
int CONFIG_PMEM_EN = 0;
int CONFIG_PMEM_SIZE = 0;

/* IRQ */
int CONFIG_IRQ_EN = 0;
int CONFIG_IRQ_EXC_EN = 0;
int CONFIG_IRQ_BASEADDR = 3;
int CONFIG_RST_VEC = 0;
int CONFIG_IRQ_VEC = 0;
int CONFIG_SYS_VEC = 0;
int CONFIG_EXC_VEC = 0;
int CONFIG_STACK_PROT_EN = 0;
int CONFIG_USER_MODE_EN = 0;
int CONFIG_IRQ_NUM = 0;
int CONFIG_EXT_IRQ_NUM = 0;
int CONFIG_MPU_EN = 0;
int CONFIG_MPU_EXEC_REGIONS = 4;
int CONFIG_MPU_DATA_REGIONS = 4;
int CONFIG_MPU_PERIPH_REGIONS = 2;
int CONFIG_CYCCNT_EN = 0;
int CONFIG_CYCCNT_SIZE = 33;

/* GNSS */
int CONFIG_GNSS_NUM = 4;
int CONFIG_GNSS_START_CORE = 0;
int CONFIG_GNSS_ISE_EN = 0;
int CONFIG_GNSS_CMEM_SIZE = 10240;

int CONFIG_GNSS_EN = 0;
int CONFIG_GNSS_BASEADDR = 4; // reserve also 5 for GNSS when 32 gnss channels
int CONFIG_GNSS_L1_EN = 0;
int CONFIG_GNSS_L5_EN = 0;
int CONFIG_GNSS_L2_EN = 0;

/* FFT */
int CONFIG_FFT_EN = 0;
int CONFIG_FFT_START_CORE = 0;
int CONFIG_FFT_SIZE = 8;
int CONFIG_FFT_BASEADDR = 8;
int CONFIG_FFT_MEMADDR = 34;

/* MBIST */
int CONFIG_MBIST_EN = 0;
int CONFIG_MBIST_BASEADDR = 9;
int CONFIG_MBIST_DC_COL_NUM = 1;
int CONFIG_MBIST_SP_COL_NUM = 1;

/* AMBA0 */
int CONFIG_AMBA_START = 8;
int CONFIG_DMA_NUM = 0;
int CONFIG_DMA_PERIPH = 0;
int CONFIG_AUART = 0;
int CONFIG_AUART_S = 1;
int CONFIG_32BT = 0;
int CONFIG_32CC = 0;
int CONFIG_32BT_S = 15;
int CONFIG_16BT = 0;
int CONFIG_16CC = 0;
int CONFIG_16BT_S = 17;
int CONFIG_SPI = 0;
int CONFIG_SPI_S = 10;
int CONFIG_SPI_SLV_EN = 0;
int CONFIG_I2C_MST = 0;
int CONFIG_I2C_MST_S = 22;
int CONFIG_I2C_SLV_EN = 0;
int CONFIG_I2C_SLV_S = 24;
int CONFIG_OCCAN = 0;
int CONFIG_OCCAN_S = 9;
int CONFIG_ONE_WIRE_EN = 0;
int CONFIG_ONE_WIRE_S = 26;
int CONFIG_BLE = 0;
int CONFIG_BLE_S = 11;
int CONFIG_GPIO = 0;
int CONFIG_GPIO_S = 10;
int CONFIG_GPIO_OVSN = 0;
int CONFIG_GPIO_OVSW = 0;
int CONFIG_GPIO_DS = 0;
int CONFIG_DMA_EN = 0;
int CONFIG_DMA_AGGR_EN = 0;
int CONFIG_MCARB_EN = 0;
int CONFIG_APB0_PRES = 0;
int CONFIG_APB2_PRES = 0;
int CONFIG_APBBRIDGE1_EN = 0;
int CONFIG_APBBRIDGE1_ADDR = 1;
int CONFIG_APBBRIDGE2_EN = 0;
int CONFIG_APBBRIDGE2_ADDR = 2;
int CONFIG_DMA_DWN = 0;
int CONFIG_DMA_DWN_FIFO_DEPTH = 0;
int CONFIG_DMA_UP = 0;
int CONFIG_DMA_UP_FIFO_DEPTH = 0;
int CONFIG_DMA_S = 8;
int CONFIG_WDT_EN = 0;
int CONFIG_WDT_S = 21;
int CONFIG_SYSTICK_EN = 0;
int CONFIG_SYSTICK_S = 19;
int CONFIG_RTC_EN = 0;
int CONFIG_RTC_S = 20;
int CONFIG_CFGREG_S = 2;
int CONFIG_CFGREG_EN = 0;
int CONFIG_CFGREG_AWIDTH = 1;
int CONFIG_ANALOG_IDCODE = 0;

/* AMBA2 */
int CONFIG_OCETH = 0;
int CONFIG_OCETH_S = 1;

char tmps[32];

int comp_clog2(int x) {
    int i;

    if (x == 0)
        return 0;

    x--;
    for (i = 0; x != 0; i++) x >>= 1;
    if (i == 0)
        return 1;
    else
        return (i);
}

main() {

    char lbuf[1024], * value;

    fp = fopen("configpar.vh", "w+");
    if (!fp) {
        printf("could not open file configpar.vh\n");
        exit(1);
    }
    while (!feof(stdin)) {
        lbuf[0] = 0;
        fgets(lbuf, 1023, stdin);
        if (strncmp(lbuf, "CONFIG", 6) == 0) {
            value = strchr(lbuf, '=');
            value[0] = 0;
            value++;
            while ((strlen (value) > 0) &&
                      ((value[strlen (value) - 1] == '\n')
                    || (value[strlen (value) - 1] == '\r')
                    || (value[strlen (value) - 1] == '"')
                     )) value[strlen (value) - 1] = 0;
            if ((strlen(value) > 0) && (value[0] == '"')) {
                value++;
            }

            /* ----------------------------------------------------------------------- */
            /* -- Evaluate variables value                                             */
            /* ----------------------------------------------------------------------- */

            /* Synthesis */
            else if (strcmp("CONFIG_TARGET_TECH_0", lbuf) == 0) {
                CONFIG_TARGET_FPGA = 0;
                CONFIG_TARGET_ASIC = 0;
            } else if (strcmp("CONFIG_TARGET_TECH_1", lbuf) == 0) {
                CONFIG_TARGET_FPGA = 1;
                CONFIG_TARGET_ASIC = 0;
            } else if (strcmp("CONFIG_TARGET_TECH_2", lbuf) == 0) {
                CONFIG_TARGET_FPGA = 0;
                CONFIG_TARGET_ASIC = 1;
            } else if (strcmp("CONFIG_TARGET_TECH_3", lbuf) == 0) {
                CONFIG_TARGET_FPGA = 0;
                CONFIG_TARGET_ASIC = 2;
            }

            /* Clock */
            else if (strcmp("CONFIG_CLK_06", lbuf) == 0) {
                CONFIG_CLK = 625;
            } else if (strcmp("CONFIG_CLK_05", lbuf) == 0) {
                CONFIG_CLK = 500;
            } else if (strcmp("CONFIG_CLK_04", lbuf) == 0) {
                CONFIG_CLK = 300;
            } else if (strcmp("CONFIG_CLK_03", lbuf) == 0) {
                CONFIG_CLK = 250;
            } else if (strcmp("CONFIG_CLK_02", lbuf) == 0) {
                CONFIG_CLK = 200;
            } else if (strcmp("CONFIG_CLK_01", lbuf) == 0) {
                CONFIG_CLK = 100;
            } else if (strcmp("CONFIG_CLK_0", lbuf) == 0) {
                CONFIG_CLK = 80;
            } else if (strcmp("CONFIG_CLK_1", lbuf) == 0) {
                CONFIG_CLK = 50;
            } else if (strcmp("CONFIG_CLK_2", lbuf) == 0) {
                CONFIG_CLK = 40;
            } else if (strcmp("CONFIG_CLK_3", lbuf) == 0) {
                CONFIG_CLK = 25;
            } else if (strcmp("CONFIG_CLK_4", lbuf) == 0) {
                CONFIG_CLK = 20;
            } else if (strcmp("CONFIG_CLK_5", lbuf) == 0) {
                CONFIG_CLK = 17;
            } else if (strcmp("CONFIG_CLK_6", lbuf) == 0) {
                CONFIG_CLK = 13;
            } else if (strcmp("CONFIG_CLK_7", lbuf) == 0) {
                CONFIG_CLK = 10;
            } else if (strcmp("CONFIG_CLK_8", lbuf) == 0) {
                CONFIG_CLK = 8;
            } else if (strcmp("CONFIG_CLK_9", lbuf) == 0) {
                CONFIG_CLK = 7;
            }

            /* DFT */
            else if (strcmp("CONFIG_DFT_MEM", lbuf) == 0) {
                CONFIG_DFT_MEM = 1;
            }

            /* Processor */

            /* Integer unit */
            else if (strcmp("CONFIG_ISA_0", lbuf) == 0) {
                CONFIG_RV32_EN = 0;
            } else if (strcmp("CONFIG_ISA_1", lbuf) == 0) {
                CONFIG_RV32_EN = 1;
            } else if (strcmp("CONFIG_ISA_2", lbuf) == 0) {
                CONFIG_RV32_EN = 2;
            } else if (strcmp("CONFIG_BP_0", lbuf) == 0) {
                CONFIG_BP = 0;
            } else if (strcmp("CONFIG_BP_1", lbuf) == 0) {
                CONFIG_BP = 1;
            } else if (strcmp("CONFIG_BP_2", lbuf) == 0) {
                CONFIG_BP = 2;
            } else if (strcmp("CONFIG_BP_3", lbuf) == 0) {
                CONFIG_BP = 3;
            } else if (strcmp("CONFIG_CORE_NUM", lbuf) == 0) {
                CONFIG_CORE_NUM = atoi(value);
                if (CONFIG_CORE_NUM > MAX_CORES)
                    CONFIG_CORE_NUM = MAX_CORES;
                if (atoi(value) == 0)
                    CONFIG_CORE_NUM = 1;
            } else if (strcmp("CONFIG_MULDIV_EN", lbuf) == 0) {
                CONFIG_MULDIV_EN = 1;
            } else if (strcmp("CONFIG_MADD_EN", lbuf) == 0) {
                CONFIG_MADD_EN = 1;
            } else if (strcmp("CONFIG_OPIS_EN", lbuf) == 0) {
                CONFIG_OPIS_EN = 1;
            } else if (strcmp("CONFIG_CGCG_EN", lbuf) == 0) {
                CONFIG_CGCG_EN = 1;
            } else if (strcmp("CONFIG_AROPT_EN", lbuf) == 0) {
                CONFIG_AROPT_EN = 1;
            } else if (strcmp("CONFIG_FAST_EN", lbuf) == 0) {
                CONFIG_FAST_EN = 1;
            } else if (strcmp("CONFIG_ISA16_EN", lbuf) == 0) {
                CONFIG_ISA16_EN = 1;
            } else if (strcmp("CONFIG_COP_EN", lbuf) == 0) {
                CONFIG_COP_EN = 1;
            } else if (strcmp("CONFIG_MUL_SCH_0", lbuf) == 0) {
                CONFIG_MUL_SCHEME = 0;
            } else if (strcmp("CONFIG_MUL_SCH_1", lbuf) == 0) {
                CONFIG_MUL_SCHEME = 1;
            }

            /* FPU */
            else if (strcmp("CONFIG_FPU_EN", lbuf) == 0) {
                CONFIG_FPU_EN = 1;
            } else if (strcmp("CONFIG_FPU_NUM", lbuf) == 0) {
                CONFIG_FPU_NUM = atoi(value);
                if (CONFIG_FPU_NUM > MAX_CORES)
                    CONFIG_FPU_NUM = MAX_CORES;
            }

            /* Cache system */
            else if (strcmp("CONFIG_ROM_START", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_ROM_START = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_ROM_END", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_ROM_END = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_RAM_START", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_RAM_START = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_RAM_END", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_RAM_END = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_IMEM_0", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 0;
            } else if (strcmp("CONFIG_IMEM_1", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 10;
            } else if (strcmp("CONFIG_IMEM_2", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 11;
            } else if (strcmp("CONFIG_IMEM_3", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 12;
            } else if (strcmp("CONFIG_IMEM_4", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 13;
            } else if (strcmp("CONFIG_IMEM_5", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 14;
            } else if (strcmp("CONFIG_IMEM_6", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 15;
            } else if (strcmp("CONFIG_IMEM_7", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 16;
            } else if (strcmp("CONFIG_IMEM_8", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 17;
            } else if (strcmp("CONFIG_IMEM_9", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 18;
            } else if (strcmp("CONFIG_IMEM_10", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 19;
            } else if (strcmp("CONFIG_IMEM_11", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 20;
            } else if (strcmp("CONFIG_IMEM_12", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 21;
            } else if (strcmp("CONFIG_IMEM_13", lbuf) == 0) {
                CONFIG_IMEM_SIZE = 22;
            } else if (strcmp("CONFIG_DMEM_0", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 0;
            } else if (strcmp("CONFIG_DMEM_1", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 10;
            } else if (strcmp("CONFIG_DMEM_2", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 11;
            } else if (strcmp("CONFIG_DMEM_3", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 12;
            } else if (strcmp("CONFIG_DMEM_4", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 13;
            } else if (strcmp("CONFIG_DMEM_5", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 14;
            } else if (strcmp("CONFIG_DMEM_6", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 15;
            } else if (strcmp("CONFIG_DMEM_7", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 16;
            } else if (strcmp("CONFIG_DMEM_8", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 17;
            } else if (strcmp("CONFIG_DMEM_9", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 18;
            } else if (strcmp("CONFIG_DMEM_10", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 19;
            } else if (strcmp("CONFIG_DMEM_11", lbuf) == 0) {
                CONFIG_DMEM_SIZE = 20;
            } else if (strcmp("CONFIG_FULLADDR_EN", lbuf) == 0) {
                CONFIG_FULLADDR_EN = 1;
            } else if (strcmp("CONFIG_DMS_BURST_EN", lbuf) == 0) {
                CONFIG_DMA_BURST_EN = 1;
            } else if (strcmp("CONFIG_ICACHE_EN", lbuf) == 0) {
                CONFIG_ICACHE_EN = 1;
            } else if (strcmp("CONFIG_BOOT_EN", lbuf) == 0) {
                CONFIG_BOOT_EN = 1;
            } else if (strcmp("CONFIG_ICACHE_WAY_1", lbuf) == 0) {
                CONFIG_ICACHE_WAY = 1;
            } else if (strcmp("CONFIG_ICACHE_WAY_2", lbuf) == 0) {
                CONFIG_ICACHE_WAY = 2;
            } else if (strcmp("CONFIG_ICACHE_WAY_4", lbuf) == 0) {
                CONFIG_ICACHE_WAY = 4;
            } else if (strcmp("CONFIG_DCACHE_WAY_1", lbuf) == 0) {
                CONFIG_DCACHE_WAY = 1;
            } else if (strcmp("CONFIG_DCACHE_WAY_2", lbuf) == 0) {
                CONFIG_DCACHE_WAY = 2;
            } else if (strcmp("CONFIG_DCACHE_WAY_4", lbuf) == 0) {
                CONFIG_DCACHE_WAY = 4;
            } else if (strcmp("CONFIG_ICACHE_SIZE_0", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 9;
            } else if (strcmp("CONFIG_ICACHE_SIZE_1", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 10;
            } else if (strcmp("CONFIG_ICACHE_SIZE_2", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 11;
            } else if (strcmp("CONFIG_ICACHE_SIZE_3", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 12;
            } else if (strcmp("CONFIG_ICACHE_SIZE_4", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 13;
            } else if (strcmp("CONFIG_ICACHE_SIZE_5", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 14;
            } else if (strcmp("CONFIG_ICACHE_SIZE_6", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 15;
            } else if (strcmp("CONFIG_ICACHE_SIZE_7", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 16;
            } else if (strcmp("CONFIG_ICACHE_SIZE_8", lbuf) == 0) {
                CONFIG_ICACHE_SIZE = 17;
            } else if (strcmp("CONFIG_RLDEL_EN", lbuf) == 0) {
                CONFIG_RLDEL_EN = 1;
            } else if (strcmp("CONFIG_ICTRL_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_ICTRL_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_DCTRL_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_DCTRL_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_ILINE_SIZE_0", lbuf) == 0) {
                CONFIG_ILINE_SIZE = 0;
            } else if (strcmp("CONFIG_ILINE_SIZE_1", lbuf) == 0) {
                CONFIG_ILINE_SIZE = 1;
            } else if (strcmp("CONFIG_ILINE_SIZE_2", lbuf) == 0) {
                CONFIG_ILINE_SIZE = 2;
            } else if (strcmp("CONFIG_ILINE_SIZE_3", lbuf) == 0) {
                CONFIG_ILINE_SIZE = 3;
            } else if (strcmp("CONFIG_ILINE_SIZE_4", lbuf) == 0) {
                CONFIG_ILINE_SIZE = 4;
            } else if (strcmp("CONFIG_ILRR_ALG", lbuf) == 0) {
                CONFIG_ILRR_ALG = 1;
                CONFIG_IRND_ALG = 0;
            } else if (strcmp("CONFIG_IRND_ALG", lbuf) == 0) {
                CONFIG_ILRR_ALG = 0;
                CONFIG_IRND_ALG = 1;
            } else if (strcmp("CONFIG_DLRR_ALG", lbuf) == 0) {
                CONFIG_DLRR_ALG = 1;
                CONFIG_DRND_ALG = 0;
            } else if (strcmp("CONFIG_DRND_ALG", lbuf) == 0) {
                CONFIG_DLRR_ALG = 0;
                CONFIG_DRND_ALG = 1;
            } else if (strcmp("CONFIG_DCACHE_EN", lbuf) == 0) {
                CONFIG_DCACHE_EN = 1;
            } else if (strcmp("CONFIG_DCACHE_SIZE_0", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 9;
            } else if (strcmp("CONFIG_DCACHE_SIZE_1", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 10;
            } else if (strcmp("CONFIG_DCACHE_SIZE_2", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 11;
            } else if (strcmp("CONFIG_DCACHE_SIZE_3", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 12;
            } else if (strcmp("CONFIG_DCACHE_SIZE_4", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 13;
            } else if (strcmp("CONFIG_DCACHE_SIZE_5", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 14;
            } else if (strcmp("CONFIG_DCACHE_SIZE_6", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 15;
            } else if (strcmp("CONFIG_DCACHE_SIZE_7", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 16;
            } else if (strcmp("CONFIG_DCACHE_SIZE_8", lbuf) == 0) {
                CONFIG_DCACHE_SIZE = 17;
            } else if (strcmp("CONFIG_DLINE_SIZE_0", lbuf) == 0) {
                CONFIG_DLINE_SIZE = 0;
            } else if (strcmp("CONFIG_DLINE_SIZE_1", lbuf) == 0) {
                CONFIG_DLINE_SIZE = 1;
            } else if (strcmp("CONFIG_DLINE_SIZE_2", lbuf) == 0) {
                CONFIG_DLINE_SIZE = 2;
            } else if (strcmp("CONFIG_DLINE_SIZE_3", lbuf) == 0) {
                CONFIG_DLINE_SIZE = 3;
            } else if (strcmp("CONFIG_DCACHE_IMPL_0", lbuf) == 0) {
                CONFIG_DCACHE_IMPL = 0;
            } else if (strcmp("CONFIG_DCACHE_IMPL_1", lbuf) == 0) {
                CONFIG_DCACHE_IMPL = 1;
            } else if (strcmp("CONFIG_DCACHE_IMPL_2", lbuf) == 0) {
                CONFIG_DCACHE_IMPL = 2;
            }

            /* Fault tolerance */
            else if (strcmp("CONFIG_LOCKSTEP_EN", lbuf) == 0) {
                CONFIG_LOCKSTEP_EN = 1;
            }
            else if (strcmp("CONFIG_ICACHE_FT_EN", lbuf) == 0) {
                CONFIG_ICACHE_FTBITS = 4;
            }
            else if (strcmp("CONFIG_DCACHE_FT_EN", lbuf) == 0) {
                CONFIG_DCACHE_FTBITS = 7;
            }

            /* Debugging */
            else if (strcmp("CONFIG_SHOW_STALL", lbuf) == 0) {
                CONFIG_SHOW_STALL = 1;
            } else if (strcmp("CONFIG_SHOW_TIME", lbuf) == 0) {
                CONFIG_SHOW_TIME = 1;
            } else if (strcmp("CONFIG_DISASM_EN", lbuf) == 0) {
                CONFIG_DISASM_EN = 1;
            } else if (strcmp("CONFIG_STAT_EN", lbuf) == 0) {
                CONFIG_STAT_EN = 1;
            } else if (strcmp("CONFIG_EMULATOR_EN", lbuf) == 0) {
                CONFIG_EMULATOR_EN = 1;
            } else if (strcmp("CONFIG_EMULATOR_ZERO", lbuf) == 0) {
                CONFIG_EMULATOR_ZERO = 1;
            } else if (strcmp("CONFIG_EMULATOR_VIRT", lbuf) == 0) {
                CONFIG_EMULATOR_VIRT = 1;
            } else if (strcmp("CONFIG_DEBUG_EN", lbuf) == 0) {
                CONFIG_DEBUG_EN = 1;
            } else if (strcmp("CONFIG_DEBUG_START", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_DEBUG_START = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_JTAG_EN", lbuf) == 0) {
                CONFIG_JTAG_EN = 1;
            } else if (strcmp("CONFIG_JTAG_IDCODE", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_JTAG_IDCODE = VAL(tmps) & 0xffffffff;
            } else if (strcmp("CONFIG_CORE_BAUD", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_CORE_BAUD = VAL(tmps) & 0xfffff;
            }

            /* Peripherals */
            else if (strcmp("CONFIG_PERIPH_START", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_PERIPH_START = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_PERIPH_RAM", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_PERIPH_RAM = VAL(tmps) & 0xf;
            } else if (strcmp("CONFIG_AMBA_START", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_AMBA_START = VAL(tmps) & 0xf;
            }

            /* MT Controller */
            else if (strcmp("CONFIG_MT_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_MT_BASEADDR = VAL(tmps) & 0xfff;
            }

            /* Power management */
            else if (strcmp("CONFIG_PMNG_EN", lbuf) == 0) {
                CONFIG_PMNG_EN = 1;
            } else if (strcmp("CONFIG_PMNG_PWD_EN", lbuf) == 0) {
                CONFIG_PMNG_PWD_EN = 1;
            } else if (strcmp("CONFIG_PMNG_PRESC_EN", lbuf) == 0) {
                CONFIG_PMNG_PRESC_EN = 1;
            } else if (strcmp("CONFIG_PMNG_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_PMNG_BASEADDR = VAL(tmps) & 0xfff;
            }

            /* Peripherlal RAM memory */
            else if (strcmp("CONFIG_PMEM_EN", lbuf) == 0) {
                CONFIG_PMEM_EN = 1;
            } else if (strcmp("CONFIG_PMEM_SIZE_0", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 9;
            } else if (strcmp("CONFIG_PMEM_SIZE_1", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 10;
            } else if (strcmp("CONFIG_PMEM_SIZE_2", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 11;
            } else if (strcmp("CONFIG_PMEM_SIZE_3", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 12;
            } else if (strcmp("CONFIG_PMEM_SIZE_4", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 13;
            } else if (strcmp("CONFIG_PMEM_SIZE_5", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 14;
            } else if (strcmp("CONFIG_PMEM_SIZE_6", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 15;
            } else if (strcmp("CONFIG_PMEM_SIZE_7", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 16;
            } else if (strcmp("CONFIG_PMEM_SIZE_8", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 17;
            } else if (strcmp("CONFIG_PMEM_SIZE_9", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 18;
            } else if (strcmp("CONFIG_PMEM_SIZE_10", lbuf) == 0) {
                CONFIG_PMEM_SIZE = 19;
            }

            /* IRQ */
            else if (strcmp("CONFIG_IRQ_EN", lbuf) == 0) {
                CONFIG_IRQ_EN = 1;
            } else if (strcmp("CONFIG_IRQ_EXC_EN", lbuf) == 0) {
                CONFIG_IRQ_EXC_EN = 1;
            } else if (strcmp("CONFIG_IRQ_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_IRQ_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_STACK_PROT_EN", lbuf) == 0) {
                CONFIG_STACK_PROT_EN = 1;
            } else if (strcmp("CONFIG_USER_MODE_EN", lbuf) == 0) {
                CONFIG_USER_MODE_EN = 1;
            } else if (strcmp("CONFIG_RST_VEC", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_RST_VEC = VAL(tmps) & 0x3ffffff;
            } else if (strcmp("CONFIG_IRQ_VEC", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_IRQ_VEC = VAL(tmps) & 0x3ffffff;
            } else if (strcmp("CONFIG_SYS_VEC", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_SYS_VEC = VAL(tmps) & 0x3ffffff;
            } else if (strcmp("CONFIG_EXC_VEC", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_EXC_VEC = VAL(tmps) & 0x3ffffff;
            } else if (strcmp("CONFIG_MPU_EN", lbuf) == 0) {
                CONFIG_MPU_EN = 1;
            } else if (strcmp("CONFIG_MPU_EXEC_REGIONS", lbuf) == 0) {
                CONFIG_MPU_EXEC_REGIONS = atoi(value);
            } else if (strcmp("CONFIG_MPU_DATA_REGIONS", lbuf) == 0) {
                CONFIG_MPU_DATA_REGIONS = atoi(value);
            } else if (strcmp("CONFIG_MPU_PERIPH_REGIONS", lbuf) == 0) {
                CONFIG_MPU_PERIPH_REGIONS = atoi(value);
            } else if (strcmp("CONFIG_CYCCNT_EN", lbuf) == 0) {
                CONFIG_CYCCNT_EN = 1;
            } else if (strcmp("CONFIG_CYCCNT_SIZE", lbuf) == 0) {
                CONFIG_CYCCNT_SIZE = atoi(value);
                if (CONFIG_CYCCNT_SIZE > 64)
                    CONFIG_CYCCNT_SIZE = 64;
                if (CONFIG_CYCCNT_SIZE < 33)
                    CONFIG_CYCCNT_SIZE = 33;
            }

            /* GNSS */
            else if (strcmp("CONFIG_GNSS_NUM", lbuf) == 0) {
                if (atoi(value) == 0)
                    CONFIG_GNSS_NUM = 4;
                CONFIG_GNSS_NUM = atoi(value);
                if (CONFIG_GNSS_NUM>MAX_GNSS_CORES)
                    CONFIG_GNSS_NUM = MAX_GNSS_CORES;
            } else if (strcmp("CONFIG_GNSS_START_CORE", lbuf) == 0) {
                CONFIG_GNSS_START_CORE = atoi(value);
                if (CONFIG_GNSS_START_CORE >= CONFIG_CORE_NUM)
                    CONFIG_GNSS_START_CORE = 0;
            } else if (strcmp("CONFIG_GNSS_CMEM_SIZE", lbuf) == 0) {
                if (atoi(value) == 0)
                    CONFIG_GNSS_CMEM_SIZE = 10240;
                CONFIG_GNSS_CMEM_SIZE = atoi(value);
                if (CONFIG_GNSS_CMEM_SIZE > 204800)
                    CONFIG_GNSS_CMEM_SIZE = 10240;
            } else if (strcmp("CONFIG_GNSS_ISE_EN", lbuf) == 0) {
                CONFIG_GNSS_ISE_EN = 1;
            } else if (strcmp("CONFIG_GNSS_EN", lbuf) == 0) {
                CONFIG_GNSS_EN = 1;
            } else if (strcmp("CONFIG_GNSS_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_GNSS_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_GNSS_L1_EN", lbuf) == 0) {
                CONFIG_GNSS_L1_EN = 1;
            } else if (strcmp("CONFIG_GNSS_L5_EN", lbuf) == 0) {
                CONFIG_GNSS_L5_EN = 1;
            } else if (strcmp("CONFIG_GNSS_L2_EN", lbuf) == 0) {
                CONFIG_GNSS_L2_EN = 1;
            }

            /* FFT */
            else if (strcmp("CONFIG_FFT_EN", lbuf) == 0) {
                CONFIG_FFT_EN = 1;
            } else if (strcmp("CONFIG_FFT_START_CORE", lbuf) == 0) {
                CONFIG_FFT_START_CORE = atoi(value);
                if (CONFIG_FFT_START_CORE >= CONFIG_CORE_NUM)
                    CONFIG_FFT_START_CORE = 0;
            } else if (strcmp("CONFIG_FFT_SIZE_1", lbuf) == 0) {
                CONFIG_FFT_SIZE = 8;
            } else if (strcmp("CONFIG_FFT_SIZE_2", lbuf) == 0) {
                CONFIG_FFT_SIZE = 9;
            } else if (strcmp("CONFIG_FFT_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_FFT_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_FFT_MEMADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_FFT_MEMADDR = VAL(tmps) & 0xfff;
            }

            /* MBIST */
            else if (strcmp("CONFIG_MBIST_EN", lbuf) == 0) {
                CONFIG_MBIST_EN = 1;
            } else if (strcmp("CONFIG_MBIST_BASEADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_MBIST_BASEADDR = VAL(tmps) & 0xfff;
            } else if (strcmp("CONFIG_MBIST_DC_COL_NUM", lbuf) == 0) {
                CONFIG_MBIST_DC_COL_NUM = atoi(value);
                if (CONFIG_MBIST_DC_COL_NUM <= 2) CONFIG_MBIST_DC_COL_NUM=2;
            } else if (strcmp("CONFIG_MBIST_SP_COL_NUM", lbuf) == 0) {
                CONFIG_MBIST_SP_COL_NUM = atoi(value);
                if (CONFIG_MBIST_SP_COL_NUM <= 2) CONFIG_MBIST_SP_COL_NUM=2;
            }

            /* AMBA0 */
            else if (strcmp("CONFIG_DMA_NUM", lbuf) == 0) {
                CONFIG_DMA_NUM = atoi(value);
                if (CONFIG_DMA_NUM > MAX_DMA)
                    CONFIG_DMA_NUM = MAX_DMA;
            } else if (strcmp("CONFIG_AUART_00", lbuf) == 0) {
                CONFIG_AUART = 0;
            } else if (strcmp("CONFIG_AUART_01", lbuf) == 0) {
                CONFIG_AUART = 1;
            } else if (strcmp("CONFIG_AUART_02", lbuf) == 0) {
                CONFIG_AUART = 2;
            } else if (strcmp("CONFIG_AUART_03", lbuf) == 0) {
                CONFIG_AUART = 3;
            } else if (strcmp("CONFIG_AUART_04", lbuf) == 0) {
                CONFIG_AUART = 4;
            } else if (strcmp("CONFIG_AUART_05", lbuf) == 0) {
                CONFIG_AUART = 5;
            } else if (strcmp("CONFIG_AUART_06", lbuf) == 0) {
                CONFIG_AUART = 6;
            } else if (strcmp("CONFIG_AUART_07", lbuf) == 0) {
                CONFIG_AUART = 7;
            } else if (strcmp("CONFIG_AUART_08", lbuf) == 0) {
                CONFIG_AUART = 8;
            } else if (strcmp("CONFIG_32BT_00", lbuf) == 0) {
                CONFIG_32BT = 0;
            } else if (strcmp("CONFIG_32BT_01", lbuf) == 0) {
                CONFIG_32BT = 1;
            } else if (strcmp("CONFIG_32BT_02", lbuf) == 0) {
                CONFIG_32BT = 2;
            } else if (strcmp("CONFIG_32BT_03", lbuf) == 0) {
                CONFIG_32BT = 3;
            } else if (strcmp("CONFIG_32CC_00", lbuf) == 0) {
                CONFIG_32CC = 0;
            } else if (strcmp("CONFIG_32CC_01", lbuf) == 0) {
                CONFIG_32CC = 1;
            } else if (strcmp("CONFIG_32CC_02", lbuf) == 0) {
                CONFIG_32CC = 2;
            } else if (strcmp("CONFIG_32CC_03", lbuf) == 0) {
                CONFIG_32CC = 3;
            } else if (strcmp("CONFIG_32CC_04", lbuf) == 0) {
                CONFIG_32CC = 4;
            } else if (strcmp("CONFIG_16BT_00", lbuf) == 0) {
                CONFIG_16BT = 0;
            } else if (strcmp("CONFIG_16BT_01", lbuf) == 0) {
                CONFIG_16BT = 1;
            } else if (strcmp("CONFIG_16BT_02", lbuf) == 0) {
                CONFIG_16BT = 2;
            } else if (strcmp("CONFIG_16BT_03", lbuf) == 0) {
                CONFIG_16BT = 3;
            } else if (strcmp("CONFIG_16CC_00", lbuf) == 0) {
                CONFIG_16CC = 0;
            } else if (strcmp("CONFIG_16CC_01", lbuf) == 0) {
                CONFIG_16CC = 1;
            } else if (strcmp("CONFIG_16CC_02", lbuf) == 0) {
                CONFIG_16CC = 2;
            } else if (strcmp("CONFIG_16CC_03", lbuf) == 0) {
                CONFIG_16CC = 3;
            } else if (strcmp("CONFIG_16CC_04", lbuf) == 0) {
                CONFIG_16CC = 4;
            } else if (strcmp("CONFIG_GPIO_00", lbuf) == 0) {
                CONFIG_GPIO = 0;
            } else if (strcmp("CONFIG_GPIO_04", lbuf) == 0) {
                CONFIG_GPIO = 4;
            } else if (strcmp("CONFIG_GPIO_08", lbuf) == 0) {
                CONFIG_GPIO = 8;
            } else if (strcmp("CONFIG_GPIO_12", lbuf) == 0) {
                CONFIG_GPIO = 12;
            } else if (strcmp("CONFIG_GPIO_16", lbuf) == 0) {
                CONFIG_GPIO = 16;
            } else if (strcmp("CONFIG_GPIO_20", lbuf) == 0) {
                CONFIG_GPIO = 20;
            } else if (strcmp("CONFIG_GPIO_24", lbuf) == 0) {
                CONFIG_GPIO = 24;
            } else if (strcmp("CONFIG_GPIO_28", lbuf) == 0) {
                CONFIG_GPIO = 28;
            } else if (strcmp("CONFIG_GPIO_32", lbuf) == 0) {
                CONFIG_GPIO = 32;
            } else if (strcmp("CONFIG_I2C_MST_00", lbuf) == 0) {
                CONFIG_I2C_MST = 0;
            } else if (strcmp("CONFIG_I2C_MST_01", lbuf) == 0) {
                CONFIG_I2C_MST = 1;
            } else if (strcmp("CONFIG_I2C_MST_02", lbuf) == 0) {
                CONFIG_I2C_MST = 2;
            } else if (strcmp("CONFIG_I2C_SLV_EN", lbuf) == 0) {
                CONFIG_I2C_SLV_EN = 1;
            } else if (strcmp("CONFIG_ONE_WIRE_EN", lbuf) == 0) {
                CONFIG_ONE_WIRE_EN = 1;
            } else if (strcmp("CONFIG_OCCAN_00", lbuf) == 0) {
                CONFIG_OCCAN = 0;
            } else if (strcmp("CONFIG_OCCAN_01", lbuf) == 0) {
                CONFIG_OCCAN = 1;
            } else if (strcmp("CONFIG_OCCAN_02", lbuf) == 0) {
                CONFIG_OCCAN = 2;
            } else if (strcmp("CONFIG_BLE_00", lbuf) == 0) {
                CONFIG_BLE = 0;
            } else if (strcmp("CONFIG_BLE_01", lbuf) == 0) {
                CONFIG_BLE = 1;
            } else if (strcmp("CONFIG_BLE_02", lbuf) == 0) {
                CONFIG_BLE = 2;
            } else if (strcmp("CONFIG_OCCAN_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_OCCAN_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_BLE_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_BLE_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_SPI_00", lbuf) == 0) {
                CONFIG_SPI = 0;
            } else if (strcmp("CONFIG_SPI_01", lbuf) == 0) {
                CONFIG_SPI = 1;
            } else if (strcmp("CONFIG_SPI_02", lbuf) == 0) {
                CONFIG_SPI = 2;
            } else if (strcmp("CONFIG_SPI_03", lbuf) == 0) {
                CONFIG_SPI = 3;
            } else if (strcmp("CONFIG_SPI_04", lbuf) == 0) {
                CONFIG_SPI = 4;
            } else if (strcmp("CONFIG_SPI_SLV_EN", lbuf) == 0) {
                CONFIG_SPI_SLV_EN = 1;
            } else if (strcmp("CONFIG_AUART_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_AUART_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_32BT_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_32BT_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_16BT_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_16BT_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_SPI_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_SPI_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_I2C_MST_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_I2C_MST_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_I2C_SLV_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_I2C_SLV_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_ONE_WIRE_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_ONE_WIRE_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_GPIO_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_GPIO_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_GPIO_DS_1", lbuf) == 0) {
                CONFIG_GPIO_DS = 1;
            } else if (strcmp("CONFIG_GPIO_DS_2", lbuf) == 0) {
                CONFIG_GPIO_DS = 2;
            } else if (strcmp("CONFIG_GPIO_OV_00", lbuf) == 0) {
                CONFIG_GPIO_OVSN = 0;
                CONFIG_GPIO_OVSW = 0;
            } else if (strcmp("CONFIG_GPIO_OV_01", lbuf) == 0) {
                CONFIG_GPIO_OVSN = 1;
                CONFIG_GPIO_OVSW = 1;
            } else if (strcmp("CONFIG_GPIO_OV_03", lbuf) == 0) {
                CONFIG_GPIO_OVSN = 3;
                CONFIG_GPIO_OVSW = 2;
            } else if (strcmp("CONFIG_DMA_EN", lbuf) == 0) {
                CONFIG_DMA_EN = 1;
            } else if (strcmp("CONFIG_DMA_AGGR_EN", lbuf) == 0) {
                CONFIG_DMA_AGGR_EN = 1;
            } else if (strcmp("CONFIG_MCARB_EN", lbuf) == 0) {
                CONFIG_MCARB_EN = 1;
            } else if (strcmp("CONFIG_APB0_PRES", lbuf) == 0) {
                CONFIG_APB0_PRES = atoi(value);
                CONFIG_APB0_PRES &= 0xf;
            } else if (strcmp("CONFIG_APB2_PRES", lbuf) == 0) {
                CONFIG_APB2_PRES = atoi(value);
                CONFIG_APB2_PRES &= 0xf;
            } else if (strcmp("CONFIG_APBBRIDGE1_EN", lbuf) == 0) {
                CONFIG_APBBRIDGE1_EN = 1;
            } else if (strcmp("CONFIG_APBBRIDGE1_ADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_APBBRIDGE1_ADDR = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_APBBRIDGE2_EN", lbuf) == 0) {
                CONFIG_APBBRIDGE2_EN = 1;
            } else if (strcmp("CONFIG_APBBRIDGE2_ADDR", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_APBBRIDGE2_ADDR = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_CFGREG_EN", lbuf) == 0) {
                CONFIG_CFGREG_EN = 1;
            } else if (strcmp("CONFIG_WDT_EN", lbuf) == 0) {
                CONFIG_WDT_EN = 1;
            } else if (strcmp("CONFIG_WDT_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_WDT_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_SYSTICK_EN", lbuf) == 0) {
                CONFIG_SYSTICK_EN = 1;
            } else if (strcmp("CONFIG_SYSTICK_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_SYSTICK_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_RTC_EN", lbuf) == 0) {
                CONFIG_RTC_EN = 1;
            } else if (strcmp("CONFIG_RTC_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_RTC_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_DMA_DWN_01", lbuf) == 0) {
                CONFIG_DMA_DWN = 1;
            } else if (strcmp("CONFIG_DMA_DWN_02", lbuf) == 0) {
                CONFIG_DMA_DWN = 2;
            } else if (strcmp("CONFIG_DMA_DWN_03", lbuf) == 0) {
                CONFIG_DMA_DWN = 3;
            } else if (strcmp("CONFIG_DMA_DWN_04", lbuf) == 0) {
                CONFIG_DMA_DWN = 4;
            } else if (strcmp("CONFIG_DMA_DWN_05", lbuf) == 0) {
                CONFIG_DMA_DWN = 5;
            } else if (strcmp("CONFIG_DMA_DWN_06", lbuf) == 0) {
                CONFIG_DMA_DWN = 6;
            } else if (strcmp("CONFIG_DMA_DWN_FIFO_DEPTH_00", lbuf) == 0) {
                CONFIG_DMA_DWN_FIFO_DEPTH = 0;
            } else if (strcmp("CONFIG_DMA_DWN_FIFO_DEPTH_02", lbuf) == 0) {
                CONFIG_DMA_DWN_FIFO_DEPTH = 2;
            } else if (strcmp("CONFIG_DMA_DWN_FIFO_DEPTH_04", lbuf) == 0) {
                CONFIG_DMA_DWN_FIFO_DEPTH = 4;
            } else if (strcmp("CONFIG_DMA_DWN_FIFO_DEPTH_06", lbuf) == 0) {
                CONFIG_DMA_DWN_FIFO_DEPTH = 6;
            } else if (strcmp("CONFIG_DMA_DWN_FIFO_DEPTH_08", lbuf) == 0) {
                CONFIG_DMA_DWN_FIFO_DEPTH = 8;
            } else if (strcmp("CONFIG_DMA_UP_01", lbuf) == 0) {
                CONFIG_DMA_UP = 1;
            } else if (strcmp("CONFIG_DMA_UP_02", lbuf) == 0) {
                CONFIG_DMA_UP = 2;
            } else if (strcmp("CONFIG_DMA_UP_03", lbuf) == 0) {
                CONFIG_DMA_UP = 3;
            } else if (strcmp("CONFIG_DMA_UP_04", lbuf) == 0) {
                CONFIG_DMA_UP = 4;
            } else if (strcmp("CONFIG_DMA_UP_05", lbuf) == 0) {
                CONFIG_DMA_UP = 5;
            } else if (strcmp("CONFIG_DMA_UP_06", lbuf) == 0) {
                CONFIG_DMA_UP = 6;
            } else if (strcmp("CONFIG_DMA_UP_07", lbuf) == 0) {
                CONFIG_DMA_UP = 7;
            } else if (strcmp("CONFIG_DMA_UP_08", lbuf) == 0) {
                CONFIG_DMA_UP = 8;
            } else if (strcmp("CONFIG_DMA_UP_FIFO_DEPTH_00", lbuf) == 0) {
                CONFIG_DMA_UP_FIFO_DEPTH = 0;
            } else if (strcmp("CONFIG_DMA_UP_FIFO_DEPTH_02", lbuf) == 0) {
                CONFIG_DMA_UP_FIFO_DEPTH = 2;
            } else if (strcmp("CONFIG_DMA_UP_FIFO_DEPTH_04", lbuf) == 0) {
                CONFIG_DMA_UP_FIFO_DEPTH = 4;
            } else if (strcmp("CONFIG_DMA_UP_FIFO_DEPTH_06", lbuf) == 0) {
                CONFIG_DMA_UP_FIFO_DEPTH = 6;
            } else if (strcmp("CONFIG_DMA_UP_FIFO_DEPTH_08", lbuf) == 0) {
                CONFIG_DMA_UP_FIFO_DEPTH = 8;
            } else if (strcmp("CONFIG_DMA_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_DMA_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_CFGREG_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_CFGREG_S = VAL(tmps) & 0xff;
            } else if (strcmp("CONFIG_CFGREG_AWIDTH", lbuf) == 0) {
                CONFIG_CFGREG_AWIDTH = atoi(value);
            } else if (strcmp("CONFIG_ANALOG_IDCODE", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_ANALOG_IDCODE = VAL(tmps) & 0xffffffff;
            }

            /* AMBA2 */
            else if (strcmp("CONFIG_OCETH_00", lbuf) == 0) {
                CONFIG_OCETH = 0;
            } else if (strcmp("CONFIG_OCETH_01", lbuf) == 0) {
                CONFIG_OCETH = 1;
            } else if (strcmp("CONFIG_OCETH_02", lbuf) == 0) {
                CONFIG_OCETH = 2;
            } else if (strcmp("CONFIG_OCETH_S", lbuf) == 0) {
                strcpy(tmps, "0x");
                strcat(tmps, value);
                CONFIG_OCETH_S = VAL(tmps) & 0xff;
            }

        }
    }

    // force interrupt controller base address
    CONFIG_IRQ_BASEADDR = 3;

    // calculate data controller users
    CONFIG_DCTRL_USERS = (CONFIG_FFT_EN == 0) & (CONFIG_GNSS_EN == 0) ? CONFIG_CORE_NUM : CONFIG_CORE_NUM + 1;
    CONFIG_DCTRL_USERS += CONFIG_DMA_NUM;
    CONFIG_DCTRL_USERS += CONFIG_DEBUG_EN;

    // force data controller
    CONFIG_DCTRL_EN = 1;

    // -------------------------------------------
    // -------------------------------------------
    CONFIG_IRQ_NUM = 16;
    // -------------------------------------------
    // -------------------------------------------

    CONFIG_EXT_IRQ_NUM = CONFIG_IRQ_NUM - 1;

    CONFIG_MAX_MEM_BUS = CONFIG_IMEM_SIZE;
    if (CONFIG_DMEM_SIZE > CONFIG_MAX_MEM_BUS)
        CONFIG_MAX_MEM_BUS = CONFIG_DMEM_SIZE;
    if (CONFIG_PMEM_SIZE > CONFIG_MAX_MEM_BUS)
        CONFIG_MAX_MEM_BUS = CONFIG_PMEM_SIZE;

    CONFIG_IMEM_BUS = CONFIG_IMEM_SIZE;
    CONFIG_DMEM_BUS = CONFIG_DMEM_SIZE;

    if (CONFIG_FULLADDR_EN == 1) {
        CONFIG_IMEM_BUS = FULL_ADDRESS;
        CONFIG_DMEM_BUS = FULL_ADDRESS;
        CONFIG_MAX_MEM_BUS = FULL_ADDRESS;
    }

    CONFIG_DMA_PERIPH = CONFIG_AUART + CONFIG_SPI + CONFIG_I2C_MST + CONFIG_I2C_SLV_EN;

    // force MI32 parameters
    if(CONFIG_RV32_EN == 0) {
        if (CONFIG_ISA16_EN) {
            CONFIG_MI16_EN = 1;
        }
        CONFIG_BIG_ENDIAN = 1;
        CONFIG_PERIPH_RAM = 2;
        CONFIG_PERIPH_START = 3;
        CONFIG_AMBA_START = 8;
        CONFIG_DEBUG_START = 9;
        CONFIG_RST_VEC = 0;
        CONFIG_IRQ_VEC = 10;
        CONFIG_SYS_VEC = 12;
        CONFIG_EXC_VEC = 14;
    }

    // force RV32 parameters
    if(CONFIG_RV32_EN > 0) {
        if (CONFIG_ISA16_EN) {
            CONFIG_RV16_EN = 1;
        }
        CONFIG_BIG_ENDIAN = 0;
        CONFIG_PERIPH_RAM = 13;
        CONFIG_PERIPH_START = 15;
        CONFIG_AMBA_START = 14;
        CONFIG_DEBUG_START = 12;
        CONFIG_RST_VEC = 256;
        CONFIG_IRQ_VEC = 65;
        CONFIG_SYS_VEC = 65;
        CONFIG_EXC_VEC = 65;
    }

    fprintf(fp, "// +FHDR------------------------------------------------------------------------\n\
//\n\
// Copyright (c) 2017 ChipCraft Sp. z o.o. All rights reserved\n\
//\n\
// -----------------------------------------------------------------------------\n\
// File Name : configpar.vh\n\
// Author    : Krzysztof Marcinek\n\
// -----------------------------------------------------------------------------\n\
// Automatically generated by tkonfig/mkdevice\n\
// -FHDR------------------------------------------------------------------------\n\
");

    /* ----------------------------------------------------------------------- */
    /* -- Print variables to file                                              */
    /* ----------------------------------------------------------------------- */

    fprintf(fp, "\n    //Synthesis");
    fprintf(fp, "\n    .CFG_TARGET_FPGA(32'd%d),", CONFIG_TARGET_FPGA);
    fprintf(fp, "\n    .CFG_TARGET_ASIC(32'd%d),", CONFIG_TARGET_ASIC);

    fprintf(fp, "\n\n    //Clock generation");
    fprintf(fp, "\n    .CFG_CLK(32'd%d),", CONFIG_CLK);

    fprintf(fp, "\n\n    //DFT features");

    fprintf(fp, "\n    .CFG_DFT_MEM(32'd%d),", CONFIG_DFT_MEM);

    fprintf(fp, "\n\n    //Processor");
    fprintf(fp, "\n\n    //Integer unit");
    fprintf(fp, "\n    .CFG_CORE_NUM(32'd%d),", CONFIG_CORE_NUM);
    fprintf(fp, "\n    .CFG_DCTRL_EN(32'd%d),", CONFIG_DCTRL_EN);
    fprintf(fp, "\n    .CFG_DCTRL_USERS(32'd%d),", CONFIG_DCTRL_USERS);
    fprintf(fp, "\n    .CFG_BP_SCHEME(32'd%d),", CONFIG_BP);
    fprintf(fp, "\n    .CFG_RV32_EN(32'd%d),", CONFIG_RV32_EN);
    fprintf(fp, "\n    .CFG_MULDIV_EN(32'd%d),", CONFIG_MULDIV_EN);
    fprintf(fp, "\n    .CFG_MUL_SCHEME(32'd%d),", CONFIG_MUL_SCHEME);
    fprintf(fp, "\n    .CFG_MADD_EN(32'd%d),", CONFIG_MADD_EN);
    fprintf(fp, "\n    .CFG_OPIS_EN(32'd%d),", CONFIG_OPIS_EN);
    fprintf(fp, "\n    .CFG_CGCG_EN(32'd%d),", CONFIG_CGCG_EN);
    fprintf(fp, "\n    .CFG_AROPT_EN(32'd%d),", CONFIG_AROPT_EN);
    fprintf(fp, "\n    .CFG_FAST_EN(32'd%d),", CONFIG_FAST_EN);
    fprintf(fp, "\n    .CFG_MI16_EN(32'd%d),", CONFIG_MI16_EN);
    fprintf(fp, "\n    .CFG_RV16_EN(32'd%d),", CONFIG_RV16_EN);
    fprintf(fp, "\n    .CFG_COP_EN(32'd%d),", CONFIG_GNSS_ISE_EN ? 0 : CONFIG_COP_EN);
    fprintf(fp, "\n    .CFG_ROM_START(32'd%d),", CONFIG_ROM_START);
    fprintf(fp, "\n    .CFG_ROM_END(32'd%d),", CONFIG_ROM_END);
    fprintf(fp, "\n    .CFG_RAM_START(32'd%d),", CONFIG_RAM_START);
    fprintf(fp, "\n    .CFG_RAM_END(32'd%d),", CONFIG_RAM_END);
    fprintf(fp, "\n    .CFG_GNSS_ISE_EN(32'd%d),", CONFIG_GNSS_ISE_EN);
    fprintf(fp, "\n    .CFG_GNSS_NUM(32'd%d),", CONFIG_GNSS_NUM);
    fprintf(fp, "\n    .CFG_GNSS_NUM_LOG(32'd%d),", comp_clog2(CONFIG_GNSS_NUM));
    fprintf(fp, "\n    .CFG_GNSS_START_CORE(32'd%d),", CONFIG_GNSS_START_CORE);
    fprintf(fp, "\n    .CFG_GNSS_CMEM_SIZE(32'd%d),", CONFIG_GNSS_CMEM_SIZE);
    fprintf(fp, "\n    .CFG_GNSS_CMEM_SIZE_LOG(32'd%d),", comp_clog2(CONFIG_GNSS_CMEM_SIZE) - 5);

    fprintf(fp, "\n\n    //Fault tolerance");
    fprintf(fp, "\n    .CFG_LOCKSTEP_EN(32'd%d),", CONFIG_LOCKSTEP_EN);
    fprintf(fp, "\n    .CFG_ICACHE_FTBITS(32'd%d),", CONFIG_ICACHE_FTBITS);
    fprintf(fp, "\n    .CFG_DCACHE_FTBITS(32'd%d),", CONFIG_DCACHE_FTBITS);

    fprintf(fp, "\n\n    //FPU unit");
    fprintf(fp, "\n    .CFG_FPU_EN(32'd%d),", CONFIG_FPU_EN);
    fprintf(fp, "\n    .CFG_FPU_NUM(32'd%d),", CONFIG_FPU_NUM);

    fprintf(fp, "\n\n    //Cache system");
    fprintf(fp, "\n    .CFG_BIG_ENDIAN(32'd%d),", CONFIG_BIG_ENDIAN);
    fprintf(fp, "\n    .CFG_IMEM_SIZE(32'd%d),", CONFIG_IMEM_SIZE);
    fprintf(fp, "\n    .CFG_DMEM_SIZE(32'd%d),", CONFIG_DMEM_SIZE);
    fprintf(fp, "\n    .CFG_IMEM_BUS(32'd%d),", CONFIG_IMEM_BUS);
    fprintf(fp, "\n    .CFG_DMEM_BUS(32'd%d),", CONFIG_DMEM_BUS);
    fprintf(fp, "\n    .CFG_ICACHE_EN(32'd%d),", CONFIG_ICACHE_EN);
    fprintf(fp, "\n    .CFG_BOOT_EN(32'd%d),", CONFIG_BOOT_EN);
    fprintf(fp, "\n    .CFG_ICACHE_SIZE(32'd%d),", CONFIG_ICACHE_SIZE);
    fprintf(fp, "\n    .CFG_ICACHE_WAY(32'd%d),", CONFIG_ICACHE_WAY);
    fprintf(fp, "\n    .CFG_ICACHE_LRR(32'd%d),", CONFIG_ICACHE_WAY > 1 ? CONFIG_ILRR_ALG : 0);
    fprintf(fp, "\n    .CFG_ICACHE_RND(32'd%d),", CONFIG_ICACHE_WAY > 1 ? CONFIG_IRND_ALG : 0);
    fprintf(fp, "\n    .CFG_ILINE_SIZE(32'd%d),", CONFIG_ILINE_SIZE);
    fprintf(fp, "\n    .CFG_RLDEL_EN(32'd%d),", CONFIG_RLDEL_EN);
    fprintf(fp, "\n    .CFG_MAX_MEM_BUS(32'd%d),", CONFIG_MAX_MEM_BUS);
    fprintf(fp, "\n    .CFG_FULLADDR_EN(32'd%d),", CONFIG_FULLADDR_EN);
    fprintf(fp, "\n    .CFG_DMA_BURST_EN(32'd%d),", CONFIG_DMA_BURST_EN);
    fprintf(fp, "\n    .CFG_ICTRL_BASEADDR(32'd%d),", CONFIG_ICTRL_BASEADDR);

    fprintf(fp, "\n    .CFG_DCTRL_BASEADDR(32'd%d),", CONFIG_DCTRL_BASEADDR);

    fprintf(fp, "\n    .CFG_DCACHE_EN(32'd%d),", CONFIG_DCACHE_EN);
    fprintf(fp, "\n    .CFG_DCACHE_SIZE(32'd%d),", CONFIG_DCACHE_SIZE);
    fprintf(fp, "\n    .CFG_DCACHE_WAY(32'd%d),", CONFIG_DCACHE_WAY);
    fprintf(fp, "\n    .CFG_DCACHE_LRR(32'd%d),", CONFIG_DCACHE_WAY > 1 ? CONFIG_DLRR_ALG : 0);
    fprintf(fp, "\n    .CFG_DCACHE_RND(32'd%d),", CONFIG_DCACHE_WAY > 1 ? CONFIG_DRND_ALG : 0);
    fprintf(fp, "\n    .CFG_DLINE_SIZE(32'd%d),", CONFIG_DLINE_SIZE);
    fprintf(fp, "\n    .CFG_DCACHE_IMPL(32'd%d),", CONFIG_DCACHE_IMPL);

    fprintf(fp, "\n\n    //Peripherals");
    fprintf(fp, "\n    .CFG_PERIPH_START(32'd%d),", CONFIG_PERIPH_START);
    fprintf(fp, "\n    .CFG_PERIPH_RAM(32'd%d),", CONFIG_PERIPH_RAM);
    fprintf(fp, "\n    .CFG_PERIPH_MAX(32'd%d),", CONFIG_PERIPH_MAX);

    fprintf(fp, "\n\n    //MT Controller");
    fprintf(fp, "\n    .CFG_MT_BASEADDR(32'd%d),", CONFIG_MT_BASEADDR);

    fprintf(fp, "\n\n    //Power management");
    fprintf(fp, "\n    .CFG_PMNG_EN(32'd%d),", CONFIG_PMNG_EN);
    fprintf(fp, "\n    .CFG_PMNG_PWD_EN(32'd%d),", CONFIG_PMNG_PWD_EN);
    fprintf(fp, "\n    .CFG_PMNG_PRESC_EN(32'd%d),", CONFIG_PMNG_PRESC_EN);
    fprintf(fp, "\n    .CFG_PMNG_BASEADDR(32'd%d),", CONFIG_PMNG_BASEADDR);

    fprintf(fp, "\n\n    //IRQ");
    fprintf(fp, "\n    .CFG_IRQ_EN(32'd%d),", CONFIG_IRQ_EN);
    fprintf(fp, "\n    .CFG_IRQ_NUM(32'd%d),", CONFIG_IRQ_NUM);
    fprintf(fp, "\n    .CFG_EXT_IRQ_NUM(32'd%d),", CONFIG_EXT_IRQ_NUM);
    fprintf(fp, "\n    .CFG_IRQ_EXC_EN(32'd%d),", CONFIG_IRQ_EXC_EN);
    fprintf(fp, "\n    .CFG_IRQ_BASEADDR(32'd%d),", CONFIG_IRQ_BASEADDR);
    fprintf(fp, "\n    .CFG_RST_VEC(32'd%d),", CONFIG_RST_VEC);
    fprintf(fp, "\n    .CFG_IRQ_VEC(32'd%d),", CONFIG_IRQ_VEC);
    fprintf(fp, "\n    .CFG_SYS_VEC(32'd%d),", CONFIG_SYS_VEC);
    fprintf(fp, "\n    .CFG_EXC_VEC(32'd%d),", CONFIG_EXC_VEC);
    fprintf(fp, "\n    .CFG_STACK_PROT_EN(32'd%d),", CONFIG_STACK_PROT_EN);
    fprintf(fp, "\n    .CFG_USER_MODE_EN(32'd%d),", CONFIG_USER_MODE_EN);
    fprintf(fp, "\n    .CFG_MPU_EN(32'd%d),", CONFIG_MPU_EN);
    fprintf(fp, "\n    .CFG_MPU_EXEC_REGIONS(32'd%d),", CONFIG_MPU_EXEC_REGIONS);
    fprintf(fp, "\n    .CFG_MPU_DATA_REGIONS(32'd%d),", CONFIG_MPU_DATA_REGIONS);
    fprintf(fp, "\n    .CFG_MPU_PERIPH_REGIONS(32'd%d),", CONFIG_MPU_PERIPH_REGIONS);
    fprintf(fp, "\n    .CFG_CYCCNT_EN(32'd%d),", CONFIG_CYCCNT_EN);
    fprintf(fp, "\n    .CFG_CYCCNT_SIZE(32'd%d),", CONFIG_CYCCNT_SIZE);

    fprintf(fp, "\n\n    //GNSS");
    fprintf(fp, "\n    .CFG_GNSS_EN(32'd%d),", CONFIG_GNSS_EN);
    fprintf(fp, "\n    .CFG_GNSS_BASEADDR(32'd%d),", CONFIG_GNSS_BASEADDR);
    fprintf(fp, "\n    .CFG_GNSS_L1_EN(32'd%d),", CONFIG_GNSS_L1_EN);
    fprintf(fp, "\n    .CFG_GNSS_L5_EN(32'd%d),", CONFIG_GNSS_L5_EN);
    fprintf(fp, "\n    .CFG_GNSS_L2_EN(32'd%d),", CONFIG_GNSS_L2_EN);

    fprintf(fp, "\n\n    //FFT");
    fprintf(fp, "\n    .CFG_FFT_EN(32'd%d),", CONFIG_FFT_EN);
    fprintf(fp, "\n    .CFG_FFT_START_CORE(32'd%d),", CONFIG_FFT_START_CORE);
    fprintf(fp, "\n    .CFG_FFT_SIZE(32'd%d),", CONFIG_FFT_SIZE);
    fprintf(fp, "\n    .CFG_FFT_BASEADDR(32'd%d),", CONFIG_FFT_BASEADDR);
    fprintf(fp, "\n    .CFG_FFT_MEMADDR(32'd%d),", CONFIG_FFT_MEMADDR);

    fprintf(fp, "\n\n    //MBIST");
    fprintf(fp, "\n    .CFG_MBIST_EN(32'd%d),", CONFIG_MBIST_EN);
    fprintf(fp, "\n    .CFG_MBIST_BASEADDR(32'd%d),", CONFIG_MBIST_BASEADDR);
    fprintf(fp, "\n    .CFG_MBIST_DC_COL_NUM(32'd%d),", CONFIG_MBIST_DC_COL_NUM);
    fprintf(fp, "\n    .CFG_MBIST_SP_COL_NUM(32'd%d),", CONFIG_MBIST_SP_COL_NUM);

    fprintf(fp, "\n\n    //Peripheral RAM");
    fprintf(fp, "\n    .CFG_PMEM_EN(32'd%d),", CONFIG_PMEM_EN);
    fprintf(fp, "\n    .CFG_PMEM_SIZE(32'd%d),", CONFIG_PMEM_SIZE);

    fprintf(fp, "\n\n    //Debugging");
    fprintf(fp, "\n    .CFG_DISASM_EN(32'd%d),", CONFIG_DISASM_EN);
    fprintf(fp, "\n    .CFG_SHOW_STALL(32'd%d),", CONFIG_SHOW_STALL);
    fprintf(fp, "\n    .CFG_SHOW_TIME(32'd%d),", CONFIG_SHOW_TIME);
    fprintf(fp, "\n    .CFG_STAT_EN(32'd%d),", CONFIG_STAT_EN);
    fprintf(fp, "\n    .CFG_EMULATOR_EN(32'd%d),", CONFIG_EMULATOR_EN);
    fprintf(fp, "\n    .CFG_EMULATOR_ZERO(32'd%d),", CONFIG_EMULATOR_ZERO);
    fprintf(fp, "\n    .CFG_EMULATOR_VIRT(32'd%d),", CONFIG_EMULATOR_VIRT);
    fprintf(fp, "\n    .CFG_DEBUG_EN(32'd%d),", CONFIG_DEBUG_EN);
    fprintf(fp, "\n    .CFG_DEBUG_START(32'd%d),", CONFIG_DEBUG_START);
    fprintf(fp, "\n    .CFG_JTAG_EN(32'd%d),", CONFIG_JTAG_EN);
    fprintf(fp, "\n    .CFG_JTAG_IDCODE(32'd%d),", CONFIG_JTAG_IDCODE);
    fprintf(fp, "\n    .CFG_CORE_BAUD(32'd%d),", CONFIG_CORE_BAUD);

    fprintf(fp, "\n\n    //AMBA0");
    fprintf(fp, "\n    .CFG_AMBA_START(32'd%d),", CONFIG_AMBA_START);
    fprintf(fp, "\n    .CFG_DMA_NUM(32'd%d),", CONFIG_DMA_NUM);
    fprintf(fp, "\n    .CFG_AUART_NUM(32'd%d),", CONFIG_AUART);
    fprintf(fp, "\n    .CFG_AUART_S(32'd%d),", CONFIG_AUART_S);
    fprintf(fp, "\n    .CFG_32BT_NUM(32'd%d),", CONFIG_32BT);
    fprintf(fp, "\n    .CFG_32CC_NUM(32'd%d),", CONFIG_32CC);
    fprintf(fp, "\n    .CFG_16BT_NUM(32'd%d),", CONFIG_16BT);
    fprintf(fp, "\n    .CFG_16CC_NUM(32'd%d),", CONFIG_16CC);
    fprintf(fp, "\n    .CFG_32BT_S(32'd%d),", CONFIG_32BT_S);
    fprintf(fp, "\n    .CFG_16BT_S(32'd%d),", CONFIG_16BT_S);
    fprintf(fp, "\n    .CFG_SPI_NUM(32'd%d),", CONFIG_SPI);
    fprintf(fp, "\n    .CFG_SPI_S(32'd%d),", CONFIG_SPI_S);
    fprintf(fp, "\n    .CFG_SPI_SLV_EN(32'd%d),", CONFIG_SPI_SLV_EN);
    fprintf(fp, "\n    .CFG_I2C_MST_NUM(32'd%d),", CONFIG_I2C_MST);
    fprintf(fp, "\n    .CFG_I2C_MST_S(32'd%d),", CONFIG_I2C_MST_S);
    fprintf(fp, "\n    .CFG_I2C_SLV_EN(32'd%d),", CONFIG_I2C_SLV_EN);
    fprintf(fp, "\n    .CFG_I2C_SLV_S(32'd%d),", CONFIG_I2C_SLV_S);
    fprintf(fp, "\n    .CFG_ONE_WIRE_EN(32'd%d),", CONFIG_ONE_WIRE_EN);
    fprintf(fp, "\n    .CFG_ONE_WIRE_S(32'd%d),", CONFIG_ONE_WIRE_S);
    fprintf(fp, "\n    .CFG_OCCAN_NUM(32'd%d),", CONFIG_OCCAN);
    fprintf(fp, "\n    .CFG_OCCAN_S(32'd%d),", CONFIG_OCCAN_S);
    fprintf(fp, "\n    .CFG_BLE_NUM(32'd%d),", CONFIG_BLE);
    fprintf(fp, "\n    .CFG_BLE_S(32'd%d),", CONFIG_BLE_S);
    fprintf(fp, "\n    .CFG_GPIO_NUM(32'd%d),", CONFIG_GPIO);
    fprintf(fp, "\n    .CFG_GPIO_S(32'd%d),", CONFIG_GPIO_S);
    fprintf(fp, "\n    .CFG_WDT_EN(32'd%d),", CONFIG_WDT_EN);
    fprintf(fp, "\n    .CFG_WDT_S(32'd%d),", CONFIG_WDT_S);
    fprintf(fp, "\n    .CFG_SYSTICK_EN(32'd%d),", CONFIG_SYSTICK_EN);
    fprintf(fp, "\n    .CFG_SYSTICK_S(32'd%d),", CONFIG_SYSTICK_S);
    fprintf(fp, "\n    .CFG_RTC_EN(32'd%d),", CONFIG_RTC_EN);
    fprintf(fp, "\n    .CFG_RTC_S(32'd%d),", CONFIG_RTC_S);
    fprintf(fp, "\n    .CFG_GPIO_DS(32'd%d),", CONFIG_GPIO_DS);
    fprintf(fp, "\n    .CFG_GPIO_OVSN(32'd%d),", CONFIG_GPIO_OVSN);
    fprintf(fp, "\n    .CFG_GPIO_OVSW(32'd%d),", CONFIG_GPIO_OVSW);
    fprintf(fp, "\n    .CFG_CFGREG_EN(32'd%d),", CONFIG_CFGREG_EN);
    fprintf(fp, "\n    .CFG_DMA_EN(32'd%d),", CONFIG_DMA_EN);
    fprintf(fp, "\n    .CFG_DMA_AGGR_EN(32'd%d),", CONFIG_DMA_AGGR_EN);
    fprintf(fp, "\n    .CFG_MCARB_EN(32'd%d),", CONFIG_MCARB_EN);
    fprintf(fp, "\n    .CFG_APB0_PRES(32'd%d),", CONFIG_APB0_PRES);
    fprintf(fp, "\n    .CFG_APB2_PRES(32'd%d),", CONFIG_APB2_PRES);
    fprintf(fp, "\n    .CFG_APBBRIDGE1_EN(32'd%d),", CONFIG_APBBRIDGE1_EN);
    fprintf(fp, "\n    .CFG_APBBRIDGE1_ADDR(32'd%d),", CONFIG_APBBRIDGE1_ADDR);
    fprintf(fp, "\n    .CFG_APBBRIDGE2_EN(32'd%d),", CONFIG_APBBRIDGE2_EN);
    fprintf(fp, "\n    .CFG_APBBRIDGE2_ADDR(32'd%d),", CONFIG_APBBRIDGE2_ADDR);
    fprintf(fp, "\n    .CFG_DMA_DWN(32'd%d),", CONFIG_DMA_DWN);
    fprintf(fp, "\n    .CFG_DMA_DWN_FIFO_DEPTH(32'd%d),", CONFIG_DMA_DWN_FIFO_DEPTH);
    fprintf(fp, "\n    .CFG_DMA_UP(32'd%d),", CONFIG_DMA_UP);
    fprintf(fp, "\n    .CFG_DMA_UP_FIFO_DEPTH(32'd%d),", CONFIG_DMA_UP_FIFO_DEPTH);
    fprintf(fp, "\n    .CFG_DMA_PERIPH_NUM(32'd%d),", CONFIG_DMA_PERIPH);
    fprintf(fp, "\n    .CFG_DMA_S(32'd%d),", CONFIG_DMA_S);
    fprintf(fp, "\n    .CFG_CFGREG_S(32'd%d),", CONFIG_CFGREG_S);
    fprintf(fp, "\n    .CFG_CFGREG_AWIDTH(32'd%d),", CONFIG_CFGREG_AWIDTH);
    fprintf(fp, "\n    .CFG_ANALOG_IDCODE(32'd%d),", CONFIG_ANALOG_IDCODE);

    fprintf(fp, "\n\n    //AMBA2");
    fprintf(fp, "\n    .CFG_OCETH_NUM(32'd%d),", CONFIG_OCETH);
    fprintf(fp, "\n    .CFG_OCETH_S(32'd%d)", CONFIG_OCETH_S);
    fprintf(fp, "\n\
\n\
// -----------------------------------------------------------------------------\n\
// end of automatic configuration\n\
// -----------------------------------------------------------------------------\n\
\n\
");
    fclose(fp);
    return (0);
}
