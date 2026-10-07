# Test Cases Specification: MIPS and RISC-V Integer Calculator

**Student:** Nguyễn Phúc Vinh  
**Student ID:** 202419019  
**Assignment:** Assignment 2 — MIPS and RISC-V Architectures  
**Verification Target:** MARS Simulator (MIPS) / RARS Simulator (RISC-V)  
**GitHub Repository:** [https://github.com/latdat/KTMT_BT_02](https://github.com/latdat/KTMT_BT_02)

---

## 1. Overview and Testing Methodology

This test document defines the comprehensive verification test cases for both the Basic and Advanced Calculator programs implemented in MIPS (`basic_calculator.asm`, `advanced_calculator.asm`) and RISC-V (`basic_calculator.s`, `advanced_calculator.s`).

---

## 2. Test Case Matrix

| Test ID | Input | Operation | Expected Output | Actual Output | Status |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **TC01** | `a = 10`, `b = 5` | Basic Arithmetic (Positive Integers) | `Addition: 15`<br>`Subtraction: 5`<br>`Multiplication: 50`<br>`Division: 2` | `Addition: 15`<br>`Subtraction: 5`<br>`Multiplication: 50`<br>`Division: 2` | **PASS** |
| **TC02** | `a = -10`, `b = 5` | Basic Arithmetic (Negative Dividend) | `Addition: -5`<br>`Subtraction: -15`<br>`Multiplication: -50`<br>`Division: -2` | `Addition: -5`<br>`Subtraction: -15`<br>`Multiplication: -50`<br>`Division: -2` | **PASS** |
| **TC03** | `a = 10`, `b = -5` | Basic Arithmetic (Negative Divisor) | `Addition: 5`<br>`Subtraction: 15`<br>`Multiplication: -50`<br>`Division: -2` | `Addition: 5`<br>`Subtraction: 15`<br>`Multiplication: -50`<br>`Division: -2` | **PASS** |
| **TC04** | `a = -10`, `b = -5` | Basic Arithmetic (Both Negative) | `Addition: -15`<br>`Subtraction: -5`<br>`Multiplication: 50`<br>`Division: 2` | `Addition: -15`<br>`Subtraction: -5`<br>`Multiplication: 50`<br>`Division: 2` | **PASS** |
| **TC05** | `a = 0`, `b = 5` | Basic Arithmetic (Zero Dividend) | `Addition: 5`<br>`Subtraction: -5`<br>`Multiplication: 0`<br>`Division: 0` | `Addition: 5`<br>`Subtraction: -5`<br>`Multiplication: 0`<br>`Division: 0` | **PASS** |
| **TC06** | `a = 10`, `b = 0` | Division by Zero Protection | `Division: Cannot divide by zero` | `Division: Cannot divide by zero` | **PASS** |
| **TC07** | `a = 0`, `b = 0` | Zero Operands & Zero Divisor | `Division: Cannot divide by zero` | `Division: Cannot divide by zero` | **PASS** |
| **TC08** | `a = 7`, `b = 7` | Advanced: Compare (Equal Numbers) | `Two numbers are equal` | `Two numbers are equal` | **PASS** |
| **TC09** | `a = 15`, `b = 4` | Advanced: Compare (First > Second) | `First number is greater` | `First number is greater` | **PASS** |
| **TC10** | `a = -3`, `b = 8` | Advanced: Compare (First < Second) | `Second number is greater` | `Second number is greater` | **PASS** |
| **TC11** | `N = 5` | Advanced: Loop Demo (Positive N) | `Loop sequence from 1 to N:`<br>`1 2 3 4 5` | `Loop sequence from 1 to N:`<br>`1 2 3 4 5` | **PASS** |
| **TC12** | `N = 0` | Advanced: Loop Demo (Zero Boundary) | `Error: N must be greater than 0.` | `Error: N must be greater than 0.` | **PASS** |
| **TC13** | `N = -5` | Advanced: Loop Demo (Negative Input) | `Error: N must be greater than 0.` | `Error: N must be greater than 0.` | **PASS** |
| **TC14** | `choice = 9` (or `0`, `-1`) | Advanced: Menu Invalid Option | `Invalid option. Please try again.`<br>(Redisplays menu) | `Invalid option. Please try again.`<br>(Redisplays menu) | **PASS** |
| **TC15** | `choice = 7` | Advanced: Clean Exit | `Exiting program. Goodbye!`<br>(Simulator halts cleanly) | `Exiting program. Goodbye!`<br>(Simulator halts cleanly) | **PASS** |

---

## 3. Test Verification Procedure in Simulators

### Verification in MARS (MIPS)
1. Launch MARS: `java -jar Mars.jar`.
2. Open target file: `File -> Open` -> Select `mips/basic_calculator.asm` or `mips/advanced_calculator.asm`.
3. Assemble: Press `F3` (or click `Run -> Assemble`).
4. Execute: Press `F5` (or click `Run -> Go`).
5. In the **MARS Messages / Run I/O** tab, enter the specified input values sequentially.
6. Verify output against the Expected Output column.

### Verification in RARS (RISC-V)
1. Launch RARS: `java -jar rars.jar`.
2. Open target file: `File -> Open` -> Select `riscv/basic_calculator.s` or `riscv/advanced_calculator.s`.
3. Assemble: Click `Run -> Assemble` (or press `F3`).
4. Execute: Click `Run -> Go` (or press `F5`).
5. In the **Run I/O** console, enter test inputs.
6. Verify output against the Expected Output column.
