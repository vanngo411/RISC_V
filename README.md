# RISC-V-CPU
A single cycle RISC-V CPU Core using Verilog

## Abstract
The RISC-V CPU cycle is the fundamental process by which instructions are fetched, decoded, executed, and results stored within a RISC-V processor. This paper presents an overview of the RISC-V CPU cycle, focusing on its key components and stages. Beginning with instruction fetch, the cycle proceeds to decode the fetched instructions, determining the operation to be performed and the associated operands. Subsequently, the instructions are executed using the Arithmetic Logic Unit (ALU) or other functional units, with results computed and stored as necessary. Throughout the cycle, control signals manage the flow of data and instructions, ensuring proper synchronization and operation. Additionally, considerations such as pipelining, branch prediction, and hazard handling are addressed to enhance performance and efficiency. Understanding the RISC-V CPU cycle is essential for designing and optimizing RISC-V processors for a wide range of applications, from embedded systems to high-performance computing.

![image](https://github.com/vanngo411/RISC_V/blob/main/BlockDiagram.png)

The different thing from the diagram above is a RAM that store 7 overwritten vlaues when logic RegWrite on. The main thing of top level to run promgram on Alchitry Au is show those values on 7 LEDs. Basically, for each RegWrite on, the overwritten vlaue will store in a Ram name RAM_for _LEDShowing and they will be driven by a clock divider  for each 4 seconds.
![image](https://github.com/vanngo411/RISC_V/blob/main/LED_Showup_Schematic.png)

This program is generated and run on Alchitry Au board
![image](https://github.com/vanngo411/RISC_V/blob/main/Alchitry_Au.png)

## Final datapath in Quartus Prime

The program represents the implementation of a RISC-V processor, encapsulated within the RICSV_TOP module. The CPU cycle begins with the fetching of instructions from memory, controlled by the program_counter module, which increments the program counter (PC) by 4 after each instruction. The fetched instruction is then decoded by the control unit (control module), determining the instruction type and configuring the various control signals such as memory read/write, ALU operation, and register write. The instruction operands are fetched from the register file (register_file module), and the ALU (alu module) executes arithmetic or logic operations based on the instruction type and operands. Additionally, an immediate value generator (immediate_Generator module) generates immediate values for certain instruction types. Depending on the instruction, data may be written back to the register file or memory. The CPU cycle is synchronized by the system clock (clk), with additional clock division implemented to generate a slower clock (clkx4) for certain operations. LED output is controlled by a RAM module (RAM_for_LEDShowing), which stores values to be displayed on LEDs. Overall, this code represents the essential components and functionality of a RISC-V CPU cycle, including instruction fetch, decode, execute, and write-back stages, along with control and data path elements necessary for proper operation.

![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20164305.png)

The control module plays a crucial role in the RISC-V CPU cycle by interpreting the opcode of each fetched instruction and generating control signals accordingly. Based on the opcode, it determines the instruction type and sets flags for operations such as memory read/write, ALU function selection, register file write enable, and branch control. This module ensures that the CPU executes instructions correctly by coordinating the flow of data and control signals throughout the processor, enabling efficient instruction execution and proper handling of program flow and data manipulation operations.

![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20164400.png)

## ModelSim Output Waveform
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163710.png)

For the first instruction, an "add" operation is executed where the CPU adds the contents of registers x10 and x25. The result, 125, matches the expected value, and this outcome is consistent with the output observed on the write_data pin. The second instruction is an "add immediate" operation, adding the immediate value 5 to the contents of register x1. As a result, x2 becomes 5, aligning with the expected outcome and the value observed on the write_data pin. In the third instruction, a store byte operation stores the content of register x6 at the address derived from the sum of 0 and the content of register x2. Since x2 contains 5, x6 is stored at address 5. This result aligns with expectations and the data observed on the write_data pin. Next, a "subtract" operation subtracts the contents of register x4 from x4 itself. This results in x4 being assigned the value -3. This outcome corresponds with expectations and the observed data on the write_data pin. In the fifth instruction, a load word operation loads the content of memory at the address obtained by adding 0 and the contents of register x10. Since x10 holds the value 125, the loaded value into x9 is also 125. This result aligns with expectations and the observed data on the write_data pin. For the sixth instruction, a branch if equal operation checks if registers x9 and x9 are equal. Since they are equal, the program counter is updated accordingly. This aligns with expectations and the observed data on the write_data pin. Lastly, another "add" operation adds the contents of registers x10 and x25, similar to the first instruction. As expected, this results in x10 being assigned the value 125, consistent with the observed data on the write_data pin. Overall, the simulation in ModelSim reflects the correct execution of instructions as per the defined operations. Each instruction performs as expected, with the computed results matching the values observed on relevant pins, confirming the accuracy of the CPU's operation under simulation.

## Synthesized design of the processor in Xilinx Vivado
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163544.png)


## Schematic for Top Level in Xilinx Vivado
![image](https://github.com/vanngo411/RISC_V/blob/main/Screenshot%202024-03-01%20163532.png)
