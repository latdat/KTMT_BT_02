# MIPS and RISC-V Assignment 2: Computer Architecture and Assembly Programming

## Student Information

- **Name:** Nguyễn Phúc Vinh
- **Student ID:** 202419019
- **Institution:** [TÊN TRƯỜNG] (Đại học Bách khoa Hà Nội)
- **Faculty / School:** [KHOA / VIỆN] (Viện Toán ứng dụng và Tin học - FAMI)
- **Course:** [TÊN HỌC PHẦN] ([MÃ HỌC PHẦN])
- **Lecturer:** [GIẢNG VIÊN]
- **Class:** [LỚP]
- **GitHub Repository:** [https://github.com/latdat/KTMT_BT_02](https://github.com/latdat/KTMT_BT_02)

---

## Assignment Objectives

The principal objectives of this assignment are:
1. **Task 1 — Insightful Investigation of ISAs:** Investigate the architectural design, register conventions (ABI), and operational characteristics of both the MIPS and RISC-V Instruction Set Architectures.
2. **Task 2 — Basic Integer Arithmetic in MIPS:** Implement an assembly program capable of reading two integers and computing their sum, difference, product, and quotient, with robust divide-by-zero detection.
3. **Task 3 — Decision-Making Control Flow in MIPS:** Upgrade the calculator into an interactive application demonstrating high-level decision-making structures:
   - Conditional selection (`if`, `if-else`, `if/else-if/else`)
   - Sequential dispatch (`switch / case` equivalent)
   - Iteration loops (`while` menu loop, counted `for` loop)
   - Robust boundary handling and error recovery
4. **Task 4 — Cross-Architecture Translation to RISC-V:** Port the logic of both MIPS programs to RISC-V assembly targeted for the RARS simulator, mapping registers, pseudo-instructions, and environment calls (`ecall`).
5. **Task 5 — Academic Reporting:** Synthesize the theoretical findings, source code implementations, comparison analysis, and verification plans into a comprehensive academic report.

---

## Project Structure

```text
mips-riscv-assignment/
│
├── README.md                      # Comprehensive project guide and instructions
├── main.tex                       # Root LaTeX source for 1-click Overleaf compilation
│
├── mips/
│   ├── basic_calculator.asm       # MIPS basic arithmetic (Add, Sub, Mul, Div)
│   └── advanced_calculator.asm    # MIPS advanced calculator with full control flow
│
├── riscv/
│   ├── basic_calculator.s         # RISC-V basic arithmetic for RARS simulator
│   └── advanced_calculator.s      # RISC-V advanced calculator with full control flow
│
├── tests/
│   └── test_cases.md              # Systematic test case specification matrix
│
└── report/
    └── report.tex                 # Academic report source file for local directory builds
```

---

## Requirements

To view, simulate, and compile this project, the following software tools are needed:
- **Operating System:** Windows, Linux, or macOS.
- **Java Runtime Environment (JRE / JDK):** Required to run MARS and RARS (Java 8 or newer recommended).
- **MIPS Simulator:** MARS (`Mars.jar`).
- **RISC-V Simulator:** RARS (`rars.jar`).
- **Text Editor / IDE:** Visual Studio Code, Notepad++, or any editor supporting assembly syntax highlighting.
- **LaTeX / PDF Viewer:** Overleaf (recommended online) or TeX Live / MiKTeX locally.

---

## Installing Java

Both MARS and RARS are Java-based applications packaged as executable `.jar` files.

1. Check if Java is installed by opening a terminal (Command Prompt, PowerShell, or bash) and typing:
   ```bash
   java -version
   ```
2. If Java is not recognized:
   - Download and install an official Java distribution (e.g., [Eclipse Adoptium Temurin](https://adoptium.net/) or Oracle JDK).
   - Ensure the `bin` directory of Java is added to your system `PATH`.

---

## Installing MARS (MIPS Simulator)

MARS (MIPS Assembler and Runtime Simulator) is an interactive lightweight simulator for MIPS assembly.

1. **Obtain MARS Jar:**
   - Download link: [Missouri State University CS MARS](https://courses.missouristate.edu/KenVollmar/mars/).
   - Save the file as `Mars.jar` in an accessible folder.
2. **Launch MARS:**
   ```bash
   java -jar Mars.jar
   ```
3. **Usage Steps:**
   - Go to `File -> Open` and browse to `mips/basic_calculator.asm` or `mips/advanced_calculator.asm`.
   - Click `Run -> Assemble` (or press `F3`).
   - Click `Run -> Go` (or press `F5`).
   - Interact with the console via the **Run I/O** tab.

---

## Installing RARS (RISC-V Simulator)

RARS (RISC-V Assembler, Runtime, and Simulator) provides an environment for simulating RISC-V programs (RV32I/RV64I).

1. **Obtain RARS Jar:**
   - Download link: [RARS Releases on GitHub](https://github.com/TheThirdOne/rars/releases).
   - Save the file as `rars.jar`.
2. **Launch RARS:**
   ```bash
   java -jar rars.jar
   ```
3. **Usage Steps:**
   - Go to `File -> Open` and open `riscv/basic_calculator.s` or `riscv/advanced_calculator.s`.
   - Click `Run -> Assemble` (or press `F3`).
   - Click `Run -> Go` (or press `F5`).
   - Enter input and observe program output in the **Run I/O** pane.

---

## Running MIPS Programs

### 1. Basic Calculator (`mips/basic_calculator.asm`)
1. Open `mips/basic_calculator.asm` in MARS.
2. Assemble (`F3`) and Run (`F5`).
3. Example run:
   ```text
   ========================================
          MIPS BASIC CALCULATOR
   ========================================
   Enter first integer: 20
   Enter second integer: 5

   Addition: 25
   Subtraction: 15
   Multiplication: 100
   Division: 4
   ```
4. Test zero division by entering `b = 0`:
   ```text
   Division: Cannot divide by zero
   ```

### 2. Advanced Calculator (`mips/advanced_calculator.asm`)
1. Open `mips/advanced_calculator.asm` in MARS.
2. Assemble (`F3`) and Run (`F5`).
3. Select any menu option (1 to 7).
4. For comparison (Option 5), enter two numbers and observe relationship messages (`First number is greater`, `Second number is greater`, `Two numbers are equal`).
5. For loop demo (Option 6), enter positive integer `N` to print numbers from `1` to `N`, or test invalid `N <= 0`.
6. Select Option 7 to terminate.

---

## Running RISC-V Programs

### 1. Basic Calculator (`riscv/basic_calculator.s`)
1. Open `riscv/basic_calculator.s` in RARS.
2. Assemble (`F3`) and Run (`F5`).
3. Follow prompts in the console; expected outputs match the MIPS counterpart exactly.

### 2. Advanced Calculator (`riscv/advanced_calculator.s`)
1. Open `riscv/advanced_calculator.s` in RARS.
2. Assemble (`F3`) and Run (`F5`).
3. Execute arithmetic, comparison, and loop options. Verify menu redisplay and clean termination.

---

## Test Cases

A formal test matrix containing 15 test cases with edge cases (negative numbers, zero operands, division by zero, invalid menu options) is documented in:
👉 [tests/test_cases.md](tests/test_cases.md)

---

## Compiling the Report

The LaTeX report is fully configured to compile with either **pdfLaTeX** or **XeLaTeX**.

### Option A — Overleaf (Recommended):
1. Upload the project folder to [Overleaf.com](https://www.overleaf.com).
2. Overleaf automatically detects `main.tex` at the root.
3. Click **Recompile** to produce the final PDF report.

### Option B — Local Command Line:
```bash
cd report
pdflatex report.tex
pdflatex report.tex
```
*(or use `xelatex report.tex`)*.
