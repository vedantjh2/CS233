# #define NULL 0

# // Note that the value of op_add is 0 and the value of each item
# // increments as you go down the list
# //
# // In C, an enum is just an int!
# typedef enum {
#     op_add,         #0
#     op_sub,         #1
#     op_mul,         #2
#     op_div,         #3
#     op_rem,         #4
#     op_neg,         #5
#     op_paren,       #6
#     constant        #7
# } node_type_t;

# typedef struct {
#     node_type_t type; #0
#     bool computed;    #4
#     int value;        #8
#     ast_node* left;   #12
#     ast_node* right;  #16
# } ast_node;

# int value(ast_node* node) {
#     if (node == NULL) { return 0; }
#     if (node->computed) { return node->value; }

#     int left = value(node->left);
#     int right = value(node->right);

#     // This can just implemented with successive if statements (see Appendix)
#     switch (node->type) {
#         case constant:
#             return node->value;
#         case op_add:
#             node->value = left + right;
#             break;
#         case op_sub:
#             node->value = left - right;
#             break;
#         case op_mul:
#             node->value = left * right;
#             break;
#         case op_div:
#             node->value = left / right;
#             break;
#         case op_rem:
#             node->value = left % right;
#             break;
#         case op_neg:
#             node->value = -left;
#             break;
#         case op_paren:
#             node->value = left;
#             break;
#     }
#     node->computed = true;
#     return node->value;
# }
.globl value
value:
        sub $sp, $sp, 16
        sw $ra, 0($sp)          
        sw $s0, 4($sp)          # store $a0
        sw $s1, 8($sp)          # store left = value(node->left)
        sw $s2, 12($sp)         # store right = value(node->right)     
        
        add $s0, $a0, 0         #$s0 = $a0
if1:
        bne $s0, $0, if2
        li $v0, 0
        j ending

        
if2:
        lw $t0, 4($s0)
        beq $t0, 0, set_leftright
        lw $t1, 8($s0)
        move $v0, $t1           #return node->value
        j ending
set_leftright:
        lw $t0, 12($s0)         #node->left
        add $a0, $t0, 0           #a0 = t0 = node->left
        jal value
        move $s1, $v0           #s1 = left = value(node->left)
        lw $t0, 16($s0)         #node->right
        move $a0, $t0           #a0 = t0 = node->right
        jal value
        move $s2, $v0           #s2 = right = value(node->right)
switch_const:
        li $t1, 7
        lw $t4, 0($s0)
        bne $t4, $t1, switch_op_add
        lw $t3, 8($s0)
        move $v0, $t3
        j ending
switch_op_add:
        lw $t4, 0($s0)
        bne $t4, $0, switch_op_sub
        add $t1, $s1, $s2       # left + right
        sw $t1, 8($s0)          # node->value = left + right
        j before_ending
switch_op_sub:
        li $t0, 1
        lw $t4, 0($s0)
        bne $t4, $t0, switch_op_mul
        sub $t1, $s1, $s2
        sw $t1, 8($s0)          # node->value = left - right
        j before_ending
switch_op_mul:
        li $t0, 2
        lw $t4, 0($s0)
        bne $t4, $t0, switch_op_div
        mul $t1, $s1, $s2
        sw $t1, 8($s0)          # node->value = left * right
        j before_ending
switch_op_div:
        li $t0, 3
        lw $t4, 0($s0)
        bne $t4, $t0, switch_op_rem
        div $t1, $s1, $s2
        sw $t1, 8($s0)          # node->value = left / right
        j before_ending
switch_op_rem:
        li $t0, 4
        lw $t4, 0($s0)
        bne $t4, $t0, switch_op_neg
        rem $t1, $s1, $s2
        sw $t1, 8($s0)          # node->value = left % right
        j before_ending
switch_op_neg:
        li $t0, 5
        bne $s1, $t0, switch_op_paren
        sub $t1, $0, $s1         
        sw $t1, 8($s0)          # s4 = -left
        j before_ending

switch_op_paren:
        li $t0, 6
        lw $t4, 0($s0)
        bne $t4, $t0, before_ending
        sw $s1, 8($s0)          # node->value = left
        j before_ending


before_ending:
        li $t0, 1
        sw $t0, 4($s0)
        lw $t1, 8($s0)
        move $v0, $t1


ending:
        lw $ra, 0($sp)          
        lw $s0, 4($sp)          
        lw $s1, 8($sp)
        lw $s2, 12($sp)                
        add $sp, $sp, 16
        jr      $ra

