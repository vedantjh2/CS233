# #define MAX_GRIDSIZE 16
# #define MAX_MAXDOTS 15

# /*** begin of the solution to the puzzle ***/

# // encode each domino as an int
# int encode_domino(unsigned char dots1, unsigned char dots2, int max_dots) {
#     return dots1 < dots2 ? dots1 * max_dots + dots2 + 1 : dots2 * max_dots + dots1 + 1;
# }
.globl encode_domino
encode_domino:

first_encode:
        bge $a0, $a1, second_encode
        mul $t0, $a0, $a2
        add $t1, $a1, 1
        add $v0, $t0, $t1
        j ending_encode
second_encode:
        mul $t0, $a1, $a2
        add $t1, $a0, 1
        add $v0, $t0, $t1

ending_encode:
        jr      $ra

# // main solve function, recurse using backtrack
# // puzzle is the puzzle question struct
# // solution is an array that the function will fill the answer in
# // row, col are the current location
# // dominos_used is a helper array of booleans (represented by a char)
# //   that shows which dominos have been used at this stage of the search
# //   use encode_domino() for indexing
# int solve(dominosa_question* puzzle,  $s0
#           unsigned char* solution,    $s1
#           int row,                    $s2
#           int col) {                  $s3
#
#     int num_rows = puzzle->num_rows; offset 0
#     int num_cols = puzzle->num_cols; offset 4
#     int max_dots = puzzle->max_dots; offset 8
#     int next_row = ((col == num_cols - 1) ? row + 1 : row); $s4
#     int next_col = (col + 1) % num_cols; $s5
#     unsigned char* dominos_used = puzzle->dominos_used; offset load address
#
#     if (row >= num_rows || col >= num_cols) { return 1; }
#     if (solution[row * num_cols + col] != 0) { 
#         return solve(puzzle, solution, next_row, next_col); 
#     }
#
#     unsigned char curr_dots = puzzle->board[row * num_cols + col]; la $t, 12($s0) -- address of puzzle->borad -- offsetting to the new int
#
#     if (row < num_rows - 1 && solution[(row + 1) * num_cols + col] == 0) {
#    $s6  int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[(row + 1) * num_cols + col],
#                                         max_dots); 
#
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[(row + 1) * num_cols + col] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[(row + 1) * num_cols + col] = 0;
#         }
#     }
#     if (col < num_cols - 1 && solution[row * num_cols + (col + 1)] == 0) {
#         int domino_code = encode_domino(curr_dots,
#                                         puzzle->board[row * num_cols + (col + 1)],
#                                         max_dots);
#         if (dominos_used[domino_code] == 0) {
#             dominos_used[domino_code] = 1;
#             solution[row * num_cols + col] = domino_code;
#             solution[row * num_cols + (col + 1)] = domino_code;
#             if (solve(puzzle, solution, next_row, next_col)) {
#                 return 1;
#             }
#             dominos_used[domino_code] = 0;
#             solution[row * num_cols + col] = 0;
#             solution[row * num_cols + (col + 1)] = 0;
#         }
#     }
#     return 0;
# }
.globl solve
solve:
        # Plan out your registers and their lifetimes ahead of time. You will almost certainly run out of registers if you
        # do not plan how you will use them. If you find yourself reusing too much code, consider using the stack to store
        # some variables like &solution[row * num_cols + col] (caller-saved convention).
        sub $sp, $sp, 36
        sw $ra, 0($sp)
        sw $s0, 4($sp)
        sw $s1, 8($sp)
        sw $s2, 12($sp)
        sw $s3, 16($sp)
        sw $s4, 20($sp)
        sw $s5, 24($sp)
        sw $s6, 28($sp)
        sw $s7, 32($sp)

        add $s0, $a0, 0         #puzzle
        add $s1, $a1, 0         #solution
        add $s2, $a2, 0         #row
        add $s3, $a3, 0         #col

        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        add $t3, $s0, 264       #dominos_used = puzzle->dominos_used; do 264,use load addresss ref above 
        sub $t9, $t1, 1


        bne $s3, $t9, next_row
        add $s4, $s2, 1         #next_row=row+1
        j next_col
next_row:
        add $s4, $s2, 0
next_col:
        add $t4, $s3, 1         #(col + 1)
        rem $s5, $t4, $t1       #next_col = (col + 1) % num_col

        

        bge $s2, $t0, if_1       #t0 = puzzle->num_rows    s2 = row
        blt $s3, $t1, post_if_1

if_1:
        li $v0, 1               #ret 1
        j ending_solve

post_if_1:
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t4, $t4, $s1       #offset solution[row * num_cols + col]
        lb $t4, 0($t4)

if_2:
        beq $t4, $0, post_if_2
        add $a2, $s4, 0
        add $a3, $s5, 0
        jal solve
        j ending_solve

post_if_2:
        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        add $t3, $s0, 264       #dominos_used = puzzle->dominos_used;
        
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s0, 12        #address of puzzle->board
        add $t6, $t5, $t4       #puzzle->board + (row * num_cols + col)
        lb $t7, 0($t6)          #$t7 = unsigned char curr_dots =  puzzle->board[row * num_cols + col]
        add $t8, $t4, $t1       #(row+1) * num_cols + col

big_if_1:
        sub $t9, $t0, 1
        bge $s2, $t9, big_if_2
        add $t9, $s1, $t8       #solution[(row + 1) * num_cols + col] 
        lb $t0, 0($t9)
        bne $t0, $0, big_if_2
        move $a0, $t7
        add $t6, $t5, $t8,      #t6 = puzzle->board[(row + 1) * num_cols + col]
        lb $t6, 0($t6)
        move $a1, $t6
        move $a2, $t2
        jal encode_domino
        move $s6, $v0           #domino_code
        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        add $t3, $s0, 264         #dominos_used = puzzle->dominos_used;
        add $s7, $t3, $s6       #s7 = dominos_used[domino_code]
        lb $t9, 0($s7)

inner_if_1:
        bne $t9, $0, big_if_2
        li $t5, 1
        sb $t5, 0($s7)
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s1, $t4       #t5=solution[row * num_cols + col]
        sb $s6, 0($t5)          #solution[row * num_cols + col] = domino_code
        add $t8, $t4, $t1       #(row+1) * num_cols + col
        add $t6, $s1, $t8       #t6=solution[(row + 1) * num_cols + col]
        sb $s6, 0($t6)          #solution[(row + 1) * num_cols + col] = domino_code

if_number_bruh_1:
        move $a0, $s0
        move $a1, $s1
        move $a2, $s4
        move $a3, $s5
        jal solve
        beq $v0, $0, inner_if_1_after
        li $t0, 1
        move $v0, $t0
        j ending_solve 
        



inner_if_1_after:
        sb $0, 0($s7)           #dominos_used[domino_code] = 0;
        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s1, $t4       #t5=solution[row * num_cols + col]
        sb $0, 0($t5)           #solution[row * num_cols + col] = 0
        add $t8, $t4, $t1       #(row+1) * num_cols + col
        add $t6, $s1, $t8       #t6=solution[(row + 1) * num_cols + col]
        sb $0, 0($t6)           #solution[(row + 1) * num_cols + col] = 0
        

big_if_2:

        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        add $t3, $s0, 264       #dominos_used = puzzle->dominos_used;
        
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s0, 12        #address of puzzle->board
        add $t6, $t5, $t4       #puzzle->board + (row * num_cols + col)
        lb $t7, 0($t6)          #$t7 = unsigned char curr_dots =  puzzle->board[row * num_cols + col]
        add $t8, $t4, 1         #row * num_cols + col +1

        sub $t9, $t1, 1         #num_cols - 1
        bge $s3, $t9, before_ending
        add $t9, $s1, $t8       #solution[row * num_cols + col +1] 
        lb $t0, 0($t9)
        bne $t0, $0, before_ending
        move $a0, $t7
        add $t6, $t5, $t8      #t6 = puzzle->board[row * num_cols + col +1]
        lb $t6, 0($t6)
        move $a1, $t6
        move $a2, $t2
        jal encode_domino
        move $s6, $v0           #s6=domino_code
        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        la $t3, 264($s0)         #dominos_used = puzzle->dominos_used;
        add $s7, $t3, $s6       #dominos_used[domino_code]
        lb $t9, 0($s7)

inner_if_2:
        bne $t9, $0, before_ending
        li $t5, 1
        sb $t5, 0($s7)          #dominos_used[domino_code] = 1;
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s1, $t4       #t5=solution[row * num_cols + col]
        sb $s6, 0($t5)          #solution[row * num_cols + col] = domino_code
        add $t8, $t4, 1         #row * num_cols + col + 1
        add $t6, $s1, $t8       #t6=solution[(row + 1) * num_cols + col]
        sb $s6, 0($t6)          #solution[(row + 1) * num_cols + col] = domino_code

if_number_bruh_2:
        move $a0, $s0
        move $a1, $s1
        move $a2, $s4
        move $a3, $s5
        jal solve
        beq $v0, $0, inner_if_2_after
        li $t0, 1
        move $v0, $t0
        j ending_solve 
        
inner_if_2_after:
        sb $0, 0($s7)           #dominos_used[domino_code] = 0;
        lw $t0, 0($s0)          #puzzle->num_rows;
        lw $t1, 4($s0)          #puzzle->num_cols;
        lw $t2, 8($s0)          #puzzle->max_dots;
        mul $t4, $s2, $t1       #row * num_cols
        add $t4, $t4, $s3       #row * num_cols + col
        add $t5, $s1, $t4       #t5=solution[row * num_cols + col]
        sb $0, 0($t5)           #solution[row * num_cols + col] = 0
        add $t8, $t4, 1         #row * num_cols + col + 1
        add $t6, $s1, $t8       #t6=solution[row * num_cols + col + 1]
        sb $0, 0($t6)           #solution[row * num_cols + col + 1] = 0

before_ending:
        move $v0, $0

ending_solve:
        lw $ra, 0($sp)
        lw $s0, 4($sp)
        lw $s1, 8($sp)
        lw $s2, 12($sp)
        lw $s3, 16($sp)
        lw $s4, 20($sp)
        lw $s5, 24($sp)
        lw $s6, 28($sp)
        lw $s7, 32($sp)
        add $sp, $sp, 36
        jr      $ra