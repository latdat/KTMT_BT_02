# ==============================================================================
# Program: advanced_calculator.s
# Description: RISC-V Advanced Integer Calculator with Control Flow
#              Demonstrates: Switch/Case, If/Else-If/Else, While Loop, For Loop,
#              Division-by-zero protection, and Input Validation.
# Author: Nguyễn Phúc Vinh (MSSV: 202419019)
# Target Simulator: RARS (RISC-V Assembler and Runtime Simulator)
# Architecture: RV32IM (RV32I Base Integer + M Extension for mul/div)
#
# Register Allocation (Standard RISC-V ABI Naming):
#   a7 - ecall service code
#   a0 - ecall argument & integer return value
#   s0 - User's menu choice
#   t0 - First operand (a) or general temporary register
#   t1 - Second operand (b) or loop boundary (N)
#   t2 - Loop counter / intermediate register
#   t3 - Arithmetic result (Add / Sub / Mul / Div quotient)
#
# RARS Environment Calls (ecall):
#   1  - print_int ($a0 in MIPS -> a0 in RISC-V)
#   4  - print_string ($a0 in MIPS -> a0 in RISC-V)
#   5  - read_int ($v0 in MIPS -> a0 in RISC-V)
#   10 - exit
# ==============================================================================

.data
    # --------------------------------------------------------------------------
    # Menu and Prompts
    # --------------------------------------------------------------------------
    menu_banner:
        .asciz "\n================================\n   RISC-V INTEGER CALCULATOR\n================================\n1. Add\n2. Subtract\n3. Multiply\n4. Divide\n5. Compare two numbers\n6. Demonstrate loop\n7. Exit\nChoose an option: "

    prompt_a:       .asciz "Enter first integer (a): "
    prompt_b:       .asciz "Enter second integer (b): "
    prompt_n:       .asciz "Enter positive integer N: "

    # --------------------------------------------------------------------------
    # Result and Informational Messages
    # --------------------------------------------------------------------------
    msg_res_add:    .asciz "Result (a + b) = "
    msg_res_sub:    .asciz "Result (a - b) = "
    msg_res_mul:    .asciz "Result (a * b) = "
    msg_res_div:    .asciz "Result (a / b) = "

    msg_div_zero:   .asciz "Error: division by zero. Cannot divide by 0.\n"
    msg_invalid:    .asciz "Invalid option. Please try again.\n"
    msg_exit:       .asciz "Exiting program. Goodbye!\n"

    # Comparison messages (If-Else-If-Else)
    msg_cmp_gt:     .asciz "First number is greater\n"
    msg_cmp_lt:     .asciz "Second number is greater\n"
    msg_cmp_eq:     .asciz "Two numbers are equal\n"

    # Loop demonstration messages
    msg_loop_start: .asciz "Loop sequence from 1 to N:\n"
    msg_loop_err:   .asciz "Error: N must be greater than 0.\n"
    space:          .asciz " "
    newline:        .asciz "\n"

.text
.globl main

main:

# ==============================================================================
# STRUCTURE C: WHILE LOOP (Menu Driver)
# High-Level Logic:
#   while (choice != 7) {
#       displayMenu();
#       choice = readChoice();
#       executeChoice(choice);
#   }
# Implemented using a loop label and an unconditional jump (j menu_loop) back.
#
# Contrast with MIPS:
#   MIPS:   j menu_loop
#   RISC-V: j menu_loop  (pseudo-instruction for: jal zero, menu_loop)
# ==============================================================================
menu_loop:
    # 1. Display Menu Banner
    # MIPS:   li $v0, 4; la $a0, menu_banner; syscall
    # RISC-V: li a7, 4;  la a0, menu_banner;  ecall
    li   a7, 4
    la   a0, menu_banner
    ecall

    # 2. Read User's Choice
    # MIPS:   li $v0, 5; syscall; move $s0, $v0
    # RISC-V: li a7, 5;  ecall;   mv   s0, a0
    li   a7, 5
    ecall
    mv   s0, a0                 # Save user choice in s0

# ==============================================================================
# STRUCTURE A: SWITCH / CASE EQUIVALENT
# High-Level Logic:
#   switch(choice) {
#       case 1: do_add();      break;
#       case 2: do_sub();      break;
#       case 3: do_mul();      break;
#       case 4: do_div();      break;
#       case 5: do_compare();  break;
#       case 6: do_loop();     break;
#       case 7: do_exit();     break;
#       default: do_invalid(); break;
#   }
# In RISC-V, just as in MIPS, switch/case is implemented via sequential conditional
# branches comparing choice register against constant literals.
# ==============================================================================
case_1:
    li   t0, 1
    beq  s0, t0, do_add

case_2:
    li   t0, 2
    beq  s0, t0, do_subtract

case_3:
    li   t0, 3
    beq  s0, t0, do_multiply

case_4:
    li   t0, 4
    beq  s0, t0, do_divide

case_5:
    li   t0, 5
    beq  s0, t0, do_compare

case_6:
    li   t0, 6
    beq  s0, t0, do_loop

case_7:
    li   t0, 7
    beq  s0, t0, do_exit

default_case:
    # --------------------------------------------------------------------------
    # STRUCTURE F: INVALID OPTION HANDLER
    # --------------------------------------------------------------------------
    li   a7, 4
    la   a0, msg_invalid
    ecall
    j    menu_loop              # Return to menu loop

# ==============================================================================
# OPTION 1: ADDITION (a + b)
# ==============================================================================
do_add:
    # Read first integer
    li   a7, 4
    la   a0, prompt_a
    ecall
    li   a7, 5
    ecall
    mv   t0, a0

    # Read second integer
    li   a7, 4
    la   a0, prompt_b
    ecall
    li   a7, 5
    ecall
    mv   t1, a0

    # Compute sum
    # MIPS:   add $t3, $t0, $t1
    # RISC-V: add t3, t0, t1
    add  t3, t0, t1

    # Print result
    li   a7, 4
    la   a0, msg_res_add
    ecall
    li   a7, 1
    mv   a0, t3
    ecall
    li   a7, 4
    la   a0, newline
    ecall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 2: SUBTRACTION (a - b)
# ==============================================================================
do_subtract:
    # Read first integer
    li   a7, 4
    la   a0, prompt_a
    ecall
    li   a7, 5
    ecall
    mv   t0, a0

    # Read second integer
    li   a7, 4
    la   a0, prompt_b
    ecall
    li   a7, 5
    ecall
    mv   t1, a0

    # Compute difference
    # MIPS:   sub $t3, $t0, $t1
    # RISC-V: sub t3, t0, t1
    sub  t3, t0, t1

    # Print result
    li   a7, 4
    la   a0, msg_res_sub
    ecall
    li   a7, 1
    mv   a0, t3
    ecall
    li   a7, 4
    la   a0, newline
    ecall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 3: MULTIPLICATION (a * b)
# ==============================================================================
do_multiply:
    # Read first integer
    li   a7, 4
    la   a0, prompt_a
    ecall
    li   a7, 5
    ecall
    mv   t0, a0

    # Read second integer
    li   a7, 4
    la   a0, prompt_b
    ecall
    li   a7, 5
    ecall
    mv   t1, a0

    # Multiply:
    # MIPS:   mult $t0, $t1; mflo $t3
    # RISC-V: mul t3, t0, t1 (Standard 'M' extension writes directly to t3)
    mul  t3, t0, t1

    # Print result
    li   a7, 4
    la   a0, msg_res_mul
    ecall
    li   a7, 1
    mv   a0, t3
    ecall
    li   a7, 4
    la   a0, newline
    ecall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 4: DIVISION (a / b) with DIVISION-BY-ZERO PROTECTION (Structure E)
# ==============================================================================
do_divide:
    # Read first integer (dividend)
    li   a7, 4
    la   a0, prompt_a
    ecall
    li   a7, 5
    ecall
    mv   t0, a0

    # Read second integer (divisor)
    li   a7, 4
    la   a0, prompt_b
    ecall
    li   a7, 5
    ecall
    mv   t1, a0

    # --------------------------------------------------------------------------
    # STRUCTURE E: Check if divisor (t1) == 0 before performing division
    # MIPS:   beq  $t1, $zero, div_zero_error
    # RISC-V: beqz t1, div_zero_error  (or beq t1, zero, div_zero_error)
    # --------------------------------------------------------------------------
    beqz t1, div_zero_error

    # Divisor != 0: Safe to divide
    # MIPS:   div $t0, $t1; mflo $t3
    # RISC-V: div t3, t0, t1
    div  t3, t0, t1

    # Print result
    li   a7, 4
    la   a0, msg_res_div
    ecall
    li   a7, 1
    mv   a0, t3
    ecall
    li   a7, 4
    la   a0, newline
    ecall

    j    menu_loop              # Return to menu loop

div_zero_error:
    li   a7, 4
    la   a0, msg_div_zero      # Print error message
    ecall
    j    menu_loop              # Return to menu loop without crashing

# ==============================================================================
# STRUCTURE B: IF / ELSE-IF / ELSE (Compare Two Numbers)
# High-Level Logic:
#   if (a == b) {
#       print("Two numbers are equal");
#   } else if (a > b) {
#       print("First number is greater");
#   } else {
#       print("Second number is greater");
#   }
#
# Contrast with MIPS:
#   MIPS:   beq $t0, $t1, label; bgt $t0, $t1, label
#   RISC-V: beq t0, t1, label;   bgt t0, t1, label (pseudo for blt t1, t0, label)
# ==============================================================================
do_compare:
    # Read first integer
    li   a7, 4
    la   a0, prompt_a
    ecall
    li   a7, 5
    ecall
    mv   t0, a0

    # Read second integer
    li   a7, 4
    la   a0, prompt_b
    ecall
    li   a7, 5
    ecall
    mv   t1, a0

    # Branch Condition 1: if (a == b) -> branch to equal
    beq  t0, t1, cmp_equal

    # Branch Condition 2: if (a > b) -> branch to greater
    bgt  t0, t1, cmp_greater

    # Else Condition: a < b
    li   a7, 4
    la   a0, msg_cmp_lt        # "Second number is greater"
    ecall
    j    menu_loop

cmp_greater:
    li   a7, 4
    la   a0, msg_cmp_gt        # "First number is greater"
    ecall
    j    menu_loop

cmp_equal:
    li   a7, 4
    la   a0, msg_cmp_eq        # "Two numbers are equal"
    ecall
    j    menu_loop

# ==============================================================================
# STRUCTURE D: COUNTED LOOP (Demonstrate Loop)
# High-Level Logic:
#   if (N <= 0) {
#       print("Error: N must be greater than 0");
#   } else {
#       for (counter = 1; counter <= N; counter++) {
#           print(counter);
#           print(" ");
#       }
#       print("\n");
#   }
#
# Contrast with MIPS:
#   MIPS:   blez $t1, loop_invalid_n
#   RISC-V: blez t1, loop_invalid_n  (pseudo for bge zero, t1, loop_invalid_n)
# ==============================================================================
do_loop:
    # Read N
    li   a7, 4
    la   a0, prompt_n
    ecall
    li   a7, 5
    ecall
    mv   t1, a0                # t1 = N (upper bound)

    # Check if N <= 0 (Input Validation)
    blez t1, loop_invalid_n

    # Valid N > 0: Initialize counter = 1
    li   t2, 1                 # t2 = loop counter = 1

    li   a7, 4
    la   a0, msg_loop_start
    ecall

loop_body:
    # Check termination condition: if counter > N, exit loop
    bgt  t2, t1, loop_done

    # Print current counter value
    li   a7, 1
    mv   a0, t2
    ecall

    # Print separator space
    li   a7, 4
    la   a0, space
    ecall

    # Increment counter: counter = counter + 1
    addi t2, t2, 1

    # Jump to next iteration
    j    loop_body

loop_done:
    li   a7, 4
    la   a0, newline
    ecall
    j    menu_loop              # Return to menu loop

loop_invalid_n:
    li   a7, 4
    la   a0, msg_loop_err
    ecall
    j    menu_loop              # Return to menu loop

# ==============================================================================
# EXIT PROGRAM
# ==============================================================================
do_exit:
    li   a7, 4
    la   a0, msg_exit
    ecall

    li   a7, 10                 # ecall service 10: Exit program
    ecall
