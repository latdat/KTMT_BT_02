# ==============================================================================
# Program: basic_calculator.s
# Description: RISC-V Basic Integer Calculator (Add, Sub, Mul, Div)
# Author: Nguyễn Phúc Vinh (MSSV: 202419019)
# Target Simulator: RARS (RISC-V Assembler and Runtime Simulator)
# Architecture: RV32IM (RV32I Base Integer + M Extension for mul/div)
#
# Register Allocation (Standard RISC-V ABI Naming):
#   a7 - Environment call (ecall) service code
#   a0 - Syscall argument (integer / address) & return value for read_int
#   t0 - First input integer (a)
#   t1 - Second input integer (b)
#   t2 - Addition result (a + b)
#   t3 - Subtraction result (a - b)
#   t4 - Multiplication result (a * b)
#   t5 - Division quotient (a / b)
#
# RARS Environment Calls (ecall):
#   Service 1  (print_int)    : a7 = 1,  a0 = integer value to print
#   Service 4  (print_string) : a7 = 4,  a0 = address of null-terminated string
#   Service 5  (read_int)     : a7 = 5,  returns integer value in a0
#   Service 10 (exit)         : a7 = 10, terminates program execution
#
# Key Architectural Differences vs. MIPS:
#   1. Syscall / Ecall Service Register:
#      - MIPS uses $v0 for service selection.
#      - RISC-V uses a7 for service selection.
#   2. Multiplication & Division:
#      - MIPS: uses mult/div with special HI/LO registers (accessed via mfhi/mflo).
#      - RISC-V (M Extension): mul/div write result directly to a general register.
#   3. Register Prefixes:
#      - MIPS registers typically prefixed with '$' ($t0, $v0).
#      - RISC-V registers omit the '$' (t0, a7).
# ==============================================================================

.data
    # Prompts and headers
    header_msg:     .asciz "========================================\n      RISC-V BASIC CALCULATOR\n========================================\n"
    prompt_first:   .asciz "Enter first integer: "
    prompt_second:  .asciz "Enter second integer: "
    newline:        .asciz "\n"

    # Result messages
    msg_add:        .asciz "\nAddition: "
    msg_sub:        .asciz "Subtraction: "
    msg_mul:        .asciz "Multiplication: "
    msg_div:        .asciz "Division: "
    msg_div_zero:   .asciz "Cannot divide by zero\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # Step 1: Print title / header
    # MIPS:   li $v0, 4; la $a0, header_msg; syscall
    # RISC-V: li a7, 4;  la a0, header_msg;  ecall
    # --------------------------------------------------------------------------
    li   a7, 4                  # ecall service 4: print_string
    la   a0, header_msg         # Load address of header_msg into a0
    ecall

    # --------------------------------------------------------------------------
    # Step 2: Read first integer (a)
    # --------------------------------------------------------------------------
    li   a7, 4                  # Print prompt
    la   a0, prompt_first
    ecall

    li   a7, 5                  # ecall service 5: read_int
    ecall
    mv   t0, a0                 # In RISC-V, read_int returns in a0; save to t0

    # --------------------------------------------------------------------------
    # Step 3: Read second integer (b)
    # --------------------------------------------------------------------------
    li   a7, 4                  # Print prompt
    la   a0, prompt_second
    ecall

    li   a7, 5                  # ecall service 5: read_int
    ecall
    mv   t1, a0                 # Save second integer to t1

    # --------------------------------------------------------------------------
    # Step 4: Perform Addition: a + b
    # MIPS:   add $t2, $t0, $t1
    # RISC-V: add t2, t0, t1
    # --------------------------------------------------------------------------
    add  t2, t0, t1             # t2 = t0 + t1

    li   a7, 4                  # Print "Addition: "
    la   a0, msg_add
    ecall

    li   a7, 1                  # ecall service 1: print_int
    mv   a0, t2                 # Move addition result into a0
    ecall

    li   a7, 4                  # Print newline
    la   a0, newline
    ecall

    # --------------------------------------------------------------------------
    # Step 5: Perform Subtraction: a - b
    # MIPS:   sub $t3, $t0, $t1
    # RISC-V: sub t3, t0, t1
    # --------------------------------------------------------------------------
    sub  t3, t0, t1             # t3 = t0 - t1

    li   a7, 4                  # Print "Subtraction: "
    la   a0, msg_sub
    ecall

    li   a7, 1                  # Print integer
    mv   a0, t3
    ecall

    li   a7, 4                  # Print newline
    la   a0, newline
    ecall

    # --------------------------------------------------------------------------
    # Step 6: Perform Multiplication: a * b
    # MIPS:   mult $t0, $t1; mflo $t4
    # RISC-V: mul t4, t0, t1 (Standard 'M' extension directly puts product in t4)
    # --------------------------------------------------------------------------
    mul  t4, t0, t1             # t4 = (t0 * t1)[31:0]

    li   a7, 4                  # Print "Multiplication: "
    la   a0, msg_mul
    ecall

    li   a7, 1                  # Print integer
    mv   a0, t4
    ecall

    li   a7, 4                  # Print newline
    la   a0, newline
    ecall

    # --------------------------------------------------------------------------
    # Step 7: Perform Division: a / b with zero-divisor check
    # MIPS:   beq $t1, $zero, div_by_zero
    # RISC-V: beqz t1, div_by_zero  (or beq t1, zero, div_by_zero)
    # --------------------------------------------------------------------------
    li   a7, 4                  # Print "Division: "
    la   a0, msg_div
    ecall

    beqz t1, div_by_zero        # If t1 == 0, branch to div_by_zero error

    # Non-zero divisor: compute division
    # MIPS:   div $t0, $t1; mflo $t5
    # RISC-V: div t5, t0, t1 (Standard 'M' extension directly puts quotient in t5)
    div  t5, t0, t1             # t5 = t0 / t1

    li   a7, 1                  # Print integer
    mv   a0, t5
    ecall

    li   a7, 4                  # Print newline
    la   a0, newline
    ecall

    j    exit_program           # Jump to exit

div_by_zero:
    li   a7, 4                  # Print "Cannot divide by zero\n"
    la   a0, msg_div_zero
    ecall

exit_program:
    # --------------------------------------------------------------------------
    # Step 8: Clean program termination
    # MIPS:   li $v0, 10; syscall
    # RISC-V: li a7, 10;  ecall
    # --------------------------------------------------------------------------
    li   a7, 10                 # ecall service 10: exit
    ecall
