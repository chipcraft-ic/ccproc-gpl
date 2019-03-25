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
* File Name : memgen.c
* Author    : Krzysztof Marcinek
* ******************************************************************************
* $Date: 2019-03-14 14:47:55 +0100 (Thu, 14 Mar 2019) $
* $Revision: 427 $
*H*****************************************************************************/

#include <dirent.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <getopt.h>

int ascii2reg(int cchar) {
    if ((cchar > 47) && (cchar < 58))
        return cchar - 48;
    if ((cchar > 64) && (cchar < 71))
        return cchar - 65 + 10;
    if ((cchar > 96) && (cchar < 103))
        return cchar - 97 + 10;
}

int main(int argc, char * argv[]) {
    FILE * f;

    char fpath[255];
    char c;
    int zero, tend, dtype, count;
    int i, j, addr, paddr, inst;
    int size = 128;
    int little = 0;
    int word;
    int boot = 0;
    int valid_dtype;
    char * mem1;
    char * mem2;
    char buffer[7];
    char **positionals;

    static const struct option longopts[] = {
        {"size", required_argument, NULL, 's'},
        {"boot", no_argument,       NULL, 'b'},
        {"endian", no_argument,     NULL, 'e'},
        {}
    };

    fpath[0] = '\0';
    for (;;) {
        int opt = getopt_long(argc, argv, "bs:e:", longopts, NULL);
        if (opt == -1)
            break;
        switch (opt) {
        case 's':
            size = atoi(optarg);
            break;
        case 'e':
            if (optarg[0] == 'L')
                little = 1;
            break;
        case 'b':
            boot = 1;
            break;
        default:
            fprintf(stdout, "Got unexpected option!\n", optarg);
            return 1;
        }
    }
    positionals = &argv[optind];
    for (; *positionals; positionals++){
        strcat(fpath, *positionals);
        break;
    }

    if (fpath[0] == '\0') {
        printf("Missing source srec file\n");
        exit(1);
    }
    f = fopen(fpath, "r");
    if (!f) {
        printf("could not open file %s\n", fpath);
        exit(1);
    }

    mem1 = malloc(size * 1024);
    if (mem1 == NULL) {
        printf("too low memory\n");
        exit(1);
    }
    mem2 = malloc(size * 1024);
    if (mem2 == NULL) {
        printf("too low memory\n");
        free(mem1);
        exit(1);
    }
    memset(mem1, 'F', size * 1024);
    memset(mem2, 'F', size * 1024);

    tend = 0;
    c = fgetc(f);
    while (c > 0) {
        if (c == 83) { // 'S'

            dtype = fgetc(f);

            valid_dtype = 0;
            if (dtype == 51) { // '3' - 32-bit address data
                j = 8;
                valid_dtype = 1;
            }
            if (dtype == 50) { // '2' - 24-bit address data
                j = 6;
                valid_dtype = 1;
            }
            if (dtype == 49) { // '1' - 16-bit address data
                j = 4;
                valid_dtype = 1;
            }

            if (valid_dtype == 1) {
                c = fgetc(f);
                count = ascii2reg(c);
                count = count << 4;
                c = fgetc(f);
                count = count + ascii2reg(c);
                addr = 0;

                for (i = 0; i < j; i = i + 1) {
                    c = fgetc(f);
                    addr = addr << 4;
                    addr = addr + ascii2reg(c);
                }

                if (addr > size * 1024) {
                    tend = 1;
                    addr = paddr;
                } else {
                    inst = (count - 1 - (j / 2)) / 4;
                    for (i = 0; i < inst; i = i + 1) {
                        for (j = 0; j < 4; j = j + 1) {
                            c = fgetc(f);
                            mem1[addr + j] = c;
                            c = fgetc(f);
                            mem2[addr + j] = c;
                        }
                        addr = addr + 4;
                        paddr = addr;
                    }
                }
            }

        }
        c = fgetc(f);
    }

    sprintf(buffer, "%08X", (int) addr & 0xffffffff);

    if (boot == 0) {
        for (i = 0; i < 4; i++) {
            mem1[16 + i] = buffer[i * 2];
            mem2[16 + i] = buffer[i * 2 + 1];
        }
    }

    for (i = 0; i < size * 256; i++) {
        if (little == 0){
            for (j = 0; j < 4; j++) {
                putc(mem1[4 * i + j],stdout);
                putc(mem2[4 * i + j],stdout);
            }
        }
        else {
            for (j = 3; j >= 0; j--) {
                putc(mem1[4 * i + j],stdout);
                putc(mem2[4 * i + j],stdout);
            }
        }
        putc('\n',stdout);
    }
    fclose(f);
    free(mem1);
    free(mem2);
}
