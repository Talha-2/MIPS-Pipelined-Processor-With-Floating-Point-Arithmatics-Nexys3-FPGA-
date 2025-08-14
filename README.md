
# Pipelined Processor with Floating Point Accelerator

## Overview

This project implements a **five-stage pipelined processor** with hazard handling (stalls and forwarding) capable of executing R-type, I-type, and J-type instructions. A **floating-point accelerator (FPU)** is integrated for addition, subtraction, multiplication, and division using the IEEE 754 single-precision format. The processor is designed for **simulation, synthesis, and FPGA deployment**.

The project emphasizes **modular design**, advanced hazard detection, and verification through simulations and FPGA testing.
<img width="940" height="513" alt="image" src="https://github.com/user-attachments/assets/d6bed9d3-c165-4048-9239-46ace18718cc" />

---

## Features

- **Five-Stage Pipeline**: Fetch → Decode → Execute → Memory → Writeback  
- **Instruction Support**:  
  - R-type: add, sub, mul  
  - I-type: load, store, branch  
  - J-type: jump  
- **Hazard Handling**: Stall insertion and data forwarding  
- **Floating-Point Unit (FPU)**: IEEE 754 single-precision operations  
- **FPGA Implementation**: Outputs visualized on seven-segment displays  
- **Modular Design**: Components easily extended or modified  

---

## Modules

- **PC** – Program counter for instruction fetch  
- **Instruction Memory** – Stores and provides instructions  
- **Control Unit** – Generates control signals  
- **Pipeline Registers** – IF/ID, ID/EX, EX/MEM, MEM/WB  
- **Hazard Detection Unit** – Detects hazards and inserts stalls  
- **Forwarding Unit** – Resolves data hazards  
- **ALU / ALU Control** – Integer arithmetic and logic operations  
- **FP_ALU** – Floating-point operations  
- **Register File** – Extended to support floating-point registers  
- **Data Memory** – Read/write memory  
- **SevenSegmentDisplay** – Displays values on FPGA  
- **Top Module** – Integrates all components  

---

## Floating-Point Implementation

- **Extended Register File** stores floating-point values  
- Supports **addition, subtraction, multiplication, division** in IEEE 754 format  
- **Opcode 17** is used to identify floating-point instructions  

---

## Simulations & Results

### Processor Simulation

- PC increments sequentially with correct branch/jump handling  
- ALU operations verified:  
  - `add 4 + 4 = 8`  
  - `sub 2 - 5 = -3`  
  - `mul 3 * 3 = 9`  
- Hazards detected and handled correctly  

### Floating-Point Simulation

| Operation | Result | Hex Representation |
|-----------|--------|------------------|
| 2.5 + 3.1 | 5.6    | 40b33333         |
| 2.5 - 3.1 | -0.6   | bf666664         |
| 2.2 * 1.4 | 3.08   | 40451eb8         |

### FPGA Output Screenshots

- **Seven-segment display showing ALU results**  

<img width="834" height="545" alt="image" src="https://github.com/user-attachments/assets/5d6e4e23-610e-4247-917c-c308ccd05ee0" />


- **Floating-point results on FPGA**  

<img width="734" height="505" alt="image" src="https://github.com/user-attachments/assets/71e754d1-0a2e-4ecc-bd54-87c356b27e9e" />


### Device Utilization

- Logic Utilization: 1%  
- Slice LUTs: 60%  

---

## Project Structure

```

Pipelined-Processor/
├── README.md
├── Project_Report.pdf
├── src/                     # Verilog source files
├── tb/                      # Testbenches
├── mem/                     # Memory initialization files
├── constraints/             # FPGA constraints

````

---

## Setup & Usage

### Prerequisites

- Verilog simulator (ModelSim / Vivado Simulator)  
- FPGA tool (Xilinx ISE / Vivado)  
- FPGA board (e.g., Nexys / Basys)  

### Installation

```bash
git clone https://github.com/ahmad292-6000/Pipelined-Processor.git
cd Pipelined-Processor
````

* Open project in your FPGA toolchain
* Load memory files:

  * `mem/Instruction_mem.txt`
  * `mem/Register_file.txt`

### Running Simulations

* Use `tb/Processor_tb.v` as the top-level testbench
* Verify pipeline behavior, hazard handling, and FPU operations

### FPGA Implementation

* Use `constraints/processor_ucf.ucf` for pin mapping
* Synthesize `src/Top_Module.v`
* Program FPGA; use switches to select display outputs

---


## Conclusion

This project demonstrates a **robust pipelined processor with floating-point acceleration**, validated through simulations and FPGA deployment. Its **modular design** allows for easy extension and reliable computation.

For more details, refer to the [project report](CSA_Project_Report.pdf).

```

```
