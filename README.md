CCPROC
======

Usage in terminal
-----------------

CCPROC library uses environment variables for its configuration.

Essential environment variables:

* `CCPROC_HOME` - CCPROC root directory, e.g. `/home/user/ccsdk`
* `CCSDK_HOME` - CCSDK root directory for MI32 architecture SDK, e.g. `/home/user/ccsdk`
* `CCRV32_HOME` - CCRV32 root directory for RV32 architecture SDK, e.g. `/home/user/ccrv32`

For basic usage informations type `make help` in one of delivered designs located in `designs` folder, e.g:

    $ cd designs/asic-soc-template
    $ make help

Usage with Verilator
------------------

For basic usage informations with Verilator type `make help` in `asic-core-template` or `simulator` design located in `designs` folder:

    $ cd designs/simulator
    $ make help

Usage with Eclipse
------------------

For setting up processor library in Eclipse environment please read [eclipse/README.md](./eclipse/README.md) file.

Usage with Windows
------------------

If you work under Windows please read [windows/README.md](./windows/README.md) file.

Directory structure
-------------------

Directory        | Description
---------------- | -----------
`bin`            | configuration tools
`desings`        | sample designs for ASICS and FPGAs
`eclipse`        | helper files to work with Eclipse
`lib`            | components Verilog RTL sources
`lint`           | helper files for linting
`software`       | software tools
`verif`          | verification tools
`windows`        | helper files to work with Windows
