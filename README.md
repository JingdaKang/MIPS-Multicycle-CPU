# MIPS Multicycle CPU

A Verilog multicycle MIPS CPU coursework implementation with a datapath, control logic, shared components, and instruction-memory examples.

## Requirements

A Verilog simulator such as ModelSim or Icarus Verilog. Use the provided design notes for the supported instruction subset.

## Getting started

Create a simulator project using the design files under `Ctrl/`, `Datapath/`, `Define/`, and `Generatic/`, then add `mips.v` and `mips_tb.v`. Select `mips_tb` as the simulation top and run from the repository root so `code.txt` can be loaded.

## Project structure

| Path | Purpose |
| --- | --- |
| `mips.v` | CPU top-level module |
| `mips_tb.v` | Clock/reset and program-loading testbench |
| `Ctrl` | Control logic |
| `Datapath` | Datapath components |
| `Define` | Shared definitions |
| `Generatic` | Shared hardware components |
| `code.txt` | Instruction-memory example |

## Configuration and limitations

The testbench contains a timescale directive inside the module, which is rejected by Icarus. It also uses a continuously toggling clock without a completion assertion; bound simulation time and inspect the program trace. No passing regression suite is claimed.

## Development and validation

Confirm reset behavior, instruction progression, and expected register/memory results for the sample program. Consult the included Word-format design notes before changing instruction encodings.

## License

No root-level license file is included. Check source-specific notices and obtain permission before redistribution or reuse.
