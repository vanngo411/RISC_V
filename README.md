# RISC-V-CPU
A single cycle RISC-V CPU Core using Verilog

## Abstract
The RISC-V CPU cycle is the fundamental process by which instructions are fetched, decoded, executed, and results stored within a RISC-V processor. This paper presents an overview of the RISC-V CPU cycle, focusing on its key components and stages. Beginning with instruction fetch, the cycle proceeds to decode the fetched instructions, determining the operation to be performed and the associated operands. Subsequently, the instructions are executed using the Arithmetic Logic Unit (ALU) or other functional units, with results computed and stored as necessary. Throughout the cycle, control signals manage the flow of data and instructions, ensuring proper synchronization and operation. Additionally, considerations such as pipelining, branch prediction, and hazard handling are addressed to enhance performance and efficiency. Understanding the RISC-V CPU cycle is essential for designing and optimizing RISC-V processors for a wide range of applications, from embedded systems to high-performance computing.

![image](https://github.com/vanngo411/RISC_V/blob/main/BlockDiagram.png)

The different thing from the diagram above is a RAM that store 7 overwritten vlaues when logic RegWrite on. The main thing of top level to run promgram on Alchitry Au is show those values on 7 LEDs. Basically, for each RegWrite on, the overwritten vlaue will store in a Ram name RAM_for _LEDShowing and they will be driven by a clock divider  for each 4 seconds.
![image](https://github.com/vanngo411/RISC_V/blob/main/LED_Showup_Schematic.png)

## Final datapath in Quartus Prime
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20164305.png)
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20164400.png)
## ModelSim Output Waveform
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163710.png)

## Synthesized design of the processor in Xilinx Vivado
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163544.png)

## Schematic for Top Level in Xilinx Vivado
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163532.png)
