# Lab 2 - Decode

## Design Scope and Assumptions
In Scope: 
Implementation of the Instruction Decode (ID) state of a 32-bit MIPS pipeline using four components:
Control Unit, Register File, Sign Extender, and ID/EX Pipeline Latch


Out of Scope: 
Instruction fetching, execution, data memory access, write-back multiplexing, hazard detection, and forwarding logic

Assumption:
  - Uses 32-bit instructions and data path architecures
  - The Register File performs combinational (asynchronous) reads and updates values synchronously on the rising clock edge
  - Reset is active-high and asynchronous for clearing the Register File and the ID/EX Pipeline Latch
  - The Testbench uses a 10 ns clock period

Limitations:
  - Supports a subset of MIPS instructions: R-Format, LW, SW, and BEQ
  - The Control Unit only decodes instructions based on the 6-bit Opcode field [31:26]
  - Unmapped instruction opcodes fallback safely to a zeroed control state via default handling

## Requirements
| Requirement | Description | Verification Method | 
|---|---|---|
| REQ-01 | The Control Unit shall combinationally decode the 6-bit instruction opcode field with zero clock cycle lag | Control testbench and waveform |
| REQ-02 | The Register File shall support 32 general-purpose registers with asynchronous reads | Register File testbench and waveform |
| REQ-03 | The Sign Extender shall convert a 16-bit immediate value into a 32-bit sign-extended word | Sign Extend testbench and waveform |
| REQ-04 | The ID/EX Latch shall store control signals, data values, and instruction fields on the rising edge of the clock | ID/EX Latch testbench and waveform |
| REQ-05 | The complete ID stage shall connect all modules and correctly decode instructions into downstream control pipelines | Decode top-level testbench and waveform |


## Implementation
### Source Code
| File | Description |
|---|---|
| ['control.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/control.v) | Maps 6-bit opcodes to WB, M, and EX control lines |
| ['regfile.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/regfile.v) | Implements 32 general purpose registers |
| ['signExtend.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/signExtend.v) | Extends 16-bit immediate offsets to signed 32-bit values via replication |
| ['idExLatch.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/idExLatch.v) | Stores the decoded parameters on the positive clock edge |
| ['decode.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/decode.v) | Top module wrapping all four components together |
| ['decode_tb.v'](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/decode_tb.v) | Testbench for verifying the complete decode stage |

### Implementation Notes
- The Control Unit utilizes a combinational always @(*) process block to generate control lines with zero clock delay.
- The Register File handles reads via continuous assign paths to output data immediately upon address alteration.
- The ID/EX Latch updates its registered configurations synchronously using nonblocking assignments (<=) on the clock edge.
- The clock is generated in the testbench using forever #5 clk = ~clk;, producing a 10 ns clock period.

## Verificaton
### Verification Strategy
The design is verified using Verilog behavioral simulation and timing diagrams. Each component is tested individually to verify its functionality before being connected into the complete Decode Stage.

Verification covers: 
- Making sure the control unit instantly decodes our opcodes (R-type, LW, SW, BEQ) with zero clock delay
- Checking that reading from registers happens asynchronously, but saving data to them only happens on the rising clock edge.
- Testing that all our data values and control bits pass cleanly into the ID/EX latch when the clock ticks.
- Verifying that random/unmapped opcodes don't break our circuit and instead default safely to zero, especially during resets.

### Testbench and Waveform
![control Waveform](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/images/screenshot_control_tb.png)

The control Testbench source is available [*here*](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/control_tb.v).


![regfile Waveform](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/images/Screenshot_regfile_tb.png)

The regfile Testbench source is available [*here*](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/regfile_tb.v).


![signExtend Waveform](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/images/signExtended_tb_screenshot.png)

The signExtend Testbench source is available [*here*](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/signExtend_tb.v).


![decode Waveform](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/images/Decode%20Waveform.png)

The decode Testbench source is available [*here*](https://github.com/MatthewOkuma/ECE4300_Decode_Assignment/blob/main/Instruction%20Decode/decode_tb.v).

