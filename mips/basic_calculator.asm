# ==============================================================================
# Program: basic_calculator.asm
# Description: MIPS Basic Integer Calculator (Add, Sub, Mul, Div)
# Author: Nguyễn Phúc Vinh (MSSV: 202419019)
# Target Simulator: MARS (MIPS Assembler and Runtime Simulator)
#
# Register Allocation:
#   $v0 - Syscall service selector / integer return value
#   $a0 - Syscall argument (integer to print / string address to print)
#   $t0 - First input integer (a)
#   $t1 - Second input integer (b)
#   $t2 - Addition result (a + b)
#   $t3 - Subtraction result (a - b)
#   $t4 - Multiplication result (a * b)
#   $t5 - Division quotient (a / b)
#
# Syscall Services Used:
#   1  - print_int ($a0 = integer to print)
#   4  - print_string ($a0 = address of null-terminated string)
#   5  - read_int (returns value in $v0)
#   10 - exit (terminate program execution)
# ==============================================================================

.data
    # Prompts and headers
    header_msg:     .asciiz "========================================\n       MIPS BASIC CALCULATOR\n========================================\n"
    prompt_first:   .asciiz "Enter first integer: "
    prompt_second:  .asciiz "Enter second integer: "
    newline:        .asciiz "\n"

    # Result messages
    msg_add:        .asciiz "\nAddition: "
    msg_sub:        .asciiz "Subtraction: "
    msg_mul:        .asciiz "Multiplication: "
    msg_div:        .asciiz "Division: "
    msg_div_zero:   .asciiz "Cannot divide by zero\n"

.text
.globl main

main:
    # --------------------------------------------------------------------------
    # Step 1: Print title / header
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, header_msg        # Load address of header_msg into $a0
    syscall

    # --------------------------------------------------------------------------
    # Step 2: Read first integer (a)
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, prompt_first      # Load address of prompt_first
    syscall

    li   $v0, 5                 # Syscall 5: read_int
    syscall
    move $t0, $v0               # Store first integer (a) in $t0

    # --------------------------------------------------------------------------
    # Step 3: Read second integer (b)
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, prompt_second     # Load address of prompt_second
    syscall

    li   $v0, 5                 # Syscall 5: read_int
    syscall
    move $t1, $v0               # Store second integer (b) in $t1

    # --------------------------------------------------------------------------
    # Step 4: Perform Addition: a + b
    # --------------------------------------------------------------------------
    add  $t2, $t0, $t1          # $t2 = $t0 + $t1

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, msg_add           # Print "Addition: "
    syscall

    li   $v0, 1                 # Syscall 1: print_int
    move $a0, $t2               # Move addition result into $a0
    syscall

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, newline           # Print newline
    syscall

    # --------------------------------------------------------------------------
    # Step 5: Perform Subtraction: a - b
    # --------------------------------------------------------------------------
    sub  $t3, $t0, $t1          # $t3 = $t0 - $t1

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, msg_sub           # Print "Subtraction: "
    syscall

    li   $v0, 1                 # Syscall 1: print_int
    move $a0, $t3               # Move subtraction result into $a0
    syscall

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, newline           # Print newline
    syscall

    # --------------------------------------------------------------------------
    # Step 6: Perform Multiplication: a * b
    # MIPS architecture stores 64-bit product in HI and LO special registers.
    # We retrieve the lower 32 bits from LO register using mflo.
    # --------------------------------------------------------------------------
    mult $t0, $t1               # HI:LO = $t0 * $t1 (signed 32-bit multiplication)
    mflo $t4                    # $t4 = lower 32 bits from LO register

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, msg_mul           # Print "Multiplication: "
    syscall

    li   $v0, 1                 # Syscall 1: print_int
    move $a0, $t4               # Move product into $a0
    syscall

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, newline           # Print newline
    syscall

    # --------------------------------------------------------------------------
    # Step 7: Perform Division: a / b with zero-divisor check
    # Check if second integer $t1 == 0 before executing div instruction.
    # --------------------------------------------------------------------------
    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, msg_div           # Print "Division: "
    syscall

    beq  $t1, $zero, div_by_zero # If $t1 == 0, branch to div_by_zero label

    # Divisor is non-zero: perform division
    div  $t0, $t1               # LO = $t0 / $t1 (quotient), HI = $t0 % $t1 (remainder)
    mflo $t5                    # $t5 = quotient from LO

    li   $v0, 1                 # Syscall 1: print_int
    move $a0, $t5               # Move quotient into $a0
    syscall

    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, newline           # Print newline
    syscall

    j    exit_program           # Skip division-by-zero error handler

div_by_zero:
    li   $v0, 4                 # Syscall 4: print_string
    la   $a0, msg_div_zero      # Print "Cannot divide by zero\n"
    syscall

exit_program:
    # --------------------------------------------------------------------------
    # Step 8: Clean program termination
    # --------------------------------------------------------------------------
    li   $v0, 10                # Syscall 10: exit
    syscall
