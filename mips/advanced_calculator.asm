# ==============================================================================
# Program: advanced_calculator.asm
# Description: MIPS Advanced Integer Calculator with Control Flow
#              Demonstrates: Switch/Case, If/Else-If/Else, While Loop, For Loop,
#              Division-by-zero protection, and Input Validation.
# Author: Nguyễn Phúc Vinh (MSSV: 202419019)
# Target Simulator: MARS (MIPS Assembler and Runtime Simulator)
#
# Register Allocation:
#   $v0 - Syscall service selector / integer input value
#   $a0 - Syscall argument (integer / address)
#   $s0 - User's menu choice
#   $t0 - First operand (a) or general temporary register
#   $t1 - Second operand (b) or loop boundary (N)
#   $t2 - Loop counter / intermediate result
#   $t3 - Arithmetic result (Add / Sub / Mul / Div quotient)
#
# Syscall Services:
#   1  - print_int ($a0 = value)
#   4  - print_string ($a0 = string address)
#   5  - read_int (result in $v0)
#   10 - exit
# ==============================================================================

.data
    # --------------------------------------------------------------------------
    # Menu and Prompts
    # --------------------------------------------------------------------------
    menu_banner:
        .asciiz "\n================================\n    MIPS INTEGER CALCULATOR\n================================\n1. Add\n2. Subtract\n3. Multiply\n4. Divide\n5. Compare two numbers\n6. Demonstrate loop\n7. Exit\nChoose an option: "

    prompt_a:       .asciiz "Enter first integer (a): "
    prompt_b:       .asciiz "Enter second integer (b): "
    prompt_n:       .asciiz "Enter positive integer N: "

    # --------------------------------------------------------------------------
    # Result and Informational Messages
    # --------------------------------------------------------------------------
    msg_res_add:    .asciiz "Result (a + b) = "
    msg_res_sub:    .asciiz "Result (a - b) = "
    msg_res_mul:    .asciiz "Result (a * b) = "
    msg_res_div:    .asciiz "Result (a / b) = "
    
    msg_div_zero:   .asciiz "Error: division by zero. Cannot divide by 0.\n"
    msg_invalid:    .asciiz "Invalid option. Please try again.\n"
    msg_exit:       .asciiz "Exiting program. Goodbye!\n"

    # Comparison messages (If-Else-If-Else)
    msg_cmp_gt:     .asciiz "First number is greater\n"
    msg_cmp_lt:     .asciiz "Second number is greater\n"
    msg_cmp_eq:     .asciiz "Two numbers are equal\n"

    # Loop demonstration messages
    msg_loop_start: .asciiz "Loop sequence from 1 to N:\n"
    msg_loop_err:   .asciiz "Error: N must be greater than 0.\n"
    space:          .asciiz " "
    newline:        .asciiz "\n"

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
# Implemented using a loop label and an unconditional jump back to the start.
# ==============================================================================
menu_loop:
    # 1. Display Menu Banner
    li   $v0, 4
    la   $a0, menu_banner
    syscall

    # 2. Read User's Choice
    li   $v0, 5
    syscall
    move $s0, $v0               # Save user choice in $s0

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
# In MIPS Assembly, switch/case is implemented via sequential conditional branches
# (beq) comparing the choice register against constant literals, jumping to handler
# labels, with a fall-through to the default label.
# ==============================================================================
case_1:
    li   $t0, 1
    beq  $s0, $t0, do_add

case_2:
    li   $t0, 2
    beq  $s0, $t0, do_subtract

case_3:
    li   $t0, 3
    beq  $s0, $t0, do_multiply

case_4:
    li   $t0, 4
    beq  $s0, $t0, do_divide

case_5:
    li   $t0, 5
    beq  $s0, $t0, do_compare

case_6:
    li   $t0, 6
    beq  $s0, $t0, do_loop

case_7:
    li   $t0, 7
    beq  $s0, $t0, do_exit

default_case:
    # --------------------------------------------------------------------------
    # STRUCTURE F: INVALID OPTION HANDLER
    # --------------------------------------------------------------------------
    li   $v0, 4
    la   $a0, msg_invalid
    syscall
    j    menu_loop              # Return to menu loop

# ==============================================================================
# OPTION 1: ADDITION (a + b)
# ==============================================================================
do_add:
    # Read first integer
    li   $v0, 4
    la   $a0, prompt_a
    syscall
    li   $v0, 5
    syscall
    move $t0, $v0

    # Read second integer
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0

    # Compute sum
    add  $t3, $t0, $t1

    # Print result
    li   $v0, 4
    la   $a0, msg_res_add
    syscall
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 2: SUBTRACTION (a - b)
# ==============================================================================
do_subtract:
    # Read first integer
    li   $v0, 4
    la   $a0, prompt_a
    syscall
    li   $v0, 5
    syscall
    move $t0, $v0

    # Read second integer
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0

    # Compute difference
    sub  $t3, $t0, $t1

    # Print result
    li   $v0, 4
    la   $a0, msg_res_sub
    syscall
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 3: MULTIPLICATION (a * b)
# ==============================================================================
do_multiply:
    # Read first integer
    li   $v0, 4
    la   $a0, prompt_a
    syscall
    li   $v0, 5
    syscall
    move $t0, $v0

    # Read second integer
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0

    # Multiply: result stored in HI:LO special registers
    mult $t0, $t1
    mflo $t3                    # Retrieve lower 32-bit product

    # Print result
    li   $v0, 4
    la   $a0, msg_res_mul
    syscall
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    j    menu_loop              # Break and return to while loop

# ==============================================================================
# OPTION 4: DIVISION (a / b) with DIVISION-BY-ZERO PROTECTION (Structure E)
# ==============================================================================
do_divide:
    # Read first integer (dividend)
    li   $v0, 4
    la   $a0, prompt_a
    syscall
    li   $v0, 5
    syscall
    move $t0, $v0

    # Read second integer (divisor)
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0

    # --------------------------------------------------------------------------
    # STRUCTURE E: Check if divisor ($t1) == 0 before performing division
    # --------------------------------------------------------------------------
    beq  $t1, $zero, div_zero_error

    # Divisor != 0: Safe to divide
    div  $t0, $t1
    mflo $t3                    # Quotient stored in LO register

    # Print result
    li   $v0, 4
    la   $a0, msg_res_div
    syscall
    li   $v0, 1
    move $a0, $t3
    syscall
    li   $v0, 4
    la   $a0, newline
    syscall

    j    menu_loop              # Return to menu loop

div_zero_error:
    li   $v0, 4
    la   $a0, msg_div_zero      # Print error message
    syscall
    j    menu_loop              # Return to menu loop without crashing

# ==============================================================================
# STRUCTURE B: IF / ELSE-IF / ELSE (Compare Two Numbers)
# High-Level Logic:
#   if (a > b) {
#       print("First number is greater");
#   } else if (a < b) {
#       print("Second number is greater");
#   } else {
#       print("Two numbers are equal");
#   }
# ==============================================================================
do_compare:
    # Read first integer
    li   $v0, 4
    la   $a0, prompt_a
    syscall
    li   $v0, 5
    syscall
    move $t0, $v0

    # Read second integer
    li   $v0, 4
    la   $a0, prompt_b
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0

    # Branch Condition 1: if (a == b) -> branch to equal
    beq  $t0, $t1, cmp_equal

    # Branch Condition 2: if (a > b) -> branch to greater
    # In MIPS, bgt $t0, $t1, cmp_greater (pseudo-instruction)
    bgt  $t0, $t1, cmp_greater

    # Else Condition: a < b
    li   $v0, 4
    la   $a0, msg_cmp_lt        # "Second number is greater"
    syscall
    j    menu_loop

cmp_greater:
    li   $v0, 4
    la   $a0, msg_cmp_gt        # "First number is greater"
    syscall
    j    menu_loop

cmp_equal:
    li   $v0, 4
    la   $a0, msg_cmp_eq        # "Two numbers are equal"
    syscall
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
# ==============================================================================
do_loop:
    # Read N
    li   $v0, 4
    la   $a0, prompt_n
    syscall
    li   $v0, 5
    syscall
    move $t1, $v0               # $t1 = N (upper bound)

    # Check if N <= 0 (Input Validation)
    blez $t1, loop_invalid_n    # If $t1 <= 0, branch to error

    # Valid N > 0: Initialize counter = 1
    li   $t2, 1                 # $t2 = loop counter = 1

    li   $v0, 4
    la   $a0, msg_loop_start
    syscall

loop_body:
    # Check termination condition: if counter > N, exit loop
    bgt  $t2, $t1, loop_done

    # Print current counter value
    li   $v0, 1
    move $a0, $t2
    syscall

    # Print separator space
    li   $v0, 4
    la   $a0, space
    syscall

    # Increment counter: counter = counter + 1
    addi $t2, $t2, 1

    # Jump to next iteration
    j    loop_body

loop_done:
    li   $v0, 4
    la   $a0, newline
    syscall
    j    menu_loop              # Return to menu loop

loop_invalid_n:
    li   $v0, 4
    la   $a0, msg_loop_err
    syscall
    j    menu_loop              # Return to menu loop

# ==============================================================================
# EXIT PROGRAM
# ==============================================================================
do_exit:
    li   $v0, 4
    la   $a0, msg_exit
    syscall

    li   $v0, 10                # Syscall 10: Exit program
    syscall
