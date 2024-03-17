# Performs a selection sort on the data with a comparator
# void selection_sort (int* array, int len) {
#   for (int i = 0; i < len -1; i++) {
#     int min_idx = i;
#
#     for (int j = i+1; j < len; j++) {
#       // Do NOT inline compare! You code will not work without calling compare.
#       if (compare(array[j], array[min_idx])) {
#         min_idx = j;
#       }
#     }
#
#     if (min_idx != i) {
#       int tmp = array[i];
#       array[i] = array[min_idx];
#       array[min_idx] = tmp;
#     }
#   }
# }
.globl selection_sort
selection_sort:
    sub $sp, $sp, 36
    sw $ra, 0($sp)          
    sw $s0, 4($sp)          # store $s0 ( i )
    sw $s1, 8($sp)          # store $s1 ( j )
    sw $s2, 12($sp)         # store $s2 (tmp)
    sw $s3, 16($sp)         # store $s3 (min_idx)
    sw $s4, 20($sp)         # store len
    sw $s5, 24($sp)         # store len-1
    sw $s6, 28($sp)         # store array 
    sw $s7, 32($sp)         #store arr offset

    li $s0, 0               #i=0
    add $s4, $a1, 0         #$s4=len
    sub $s5, $s4, 1         #len-1
    add $s6, $a0, 0         # store array 


    for_loop1:
    bge $s0, $s5, end
    add $s3, $s0, 0         #min_idx = i    
    add $s1, $s0, 1         #j = i + 1


    for_loop2:
    bge $s1, $s4, if_loop1
    mul $t0, $s1, 4         #offset j
    add $t0, $t0, $s6       #arr[j]
    mul $t1, $s3, 4         #offset min_idx
    add $t1, $t1, $s6
    lw $a0, 0($t0)            #arr[j]
    lw $a1, 0($t1)            #arr[min_idx]


    if_loop2:
    jal compare
    bne $v0, 1, loop2
    add $s3, $s1, 0


    loop2:
    add $s1, $s1, 1         # j++
    j for_loop2
    

    if_loop1:
    beq $s3, $s0, loop1

    # tmp = arr[i]
    mul $t2, $s0, 4         # calculate index $t2 = i*4
    add $t2, $t2, $s6       # add offset to base address
    lw $s2, 0($t2)          # $s2 = tmp = arr[i] 

    # arr[i] = arr[ min_idx ]
    mul $t3, $s3, 4         # calculate index $t3 = min_idx*4
    add $t3, $t3, $s6       # add offset to base address
    lw $t0, 0($t3)          # $t0 = arr [ min_idx ]
    sw $t0, 0($t2)          # store value at arr[ min_idx ] in arr[i]

    # arr[ min_idx ] = tmp
    mul $t4, $s3, 4         # calculate index $t3 = min_idx*4
    add $t4, $t4, $s6       # add offset to base address
    sw $s2, 0($t4)

    loop1:
    add $s0, $s0, 1         # i++
    j for_loop1


    end:
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



# Draws points onto the array
# int draw_gradient(Gradient map[15][15]) {
#   int num_changed = 0;
#   for (int i = 0 ; i < 15 ; ++ i) {
#     for (int j = 0 ; j < 15 ; ++ j) { //repr 0 offset xdir 4 offset and y dir 8 offset
#       char orig = map[i][j].repr;
#
#     1  if (map[i][j].xdir == 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '.';
#       }
#    2   if (map[i][j].xdir != 0 && map[i][j].ydir == 0) {
#         map[i][j].repr = '_';
#       }
#    3   if (map[i][j].xdir == 0 && map[i][j].ydir != 0) {
#         map[i][j].repr = '|';
#       }
#    4   if (map[i][j].xdir * map[i][j].ydir > 0) {
#         map[i][j].repr = '/';
#       }
#    5   if (map[i][j].xdir * map[i][j].ydir < 0) {
#         map[i][j].repr = '\';
#       }
#    6   if (map[i][j].repr != orig) {
#         num_changed += 1;
#       }
#     }
#   }
#   return num_changed;
# }
.globl draw_gradient
draw_gradient:
    sub $sp, $sp, 36
    sw $ra, 0($sp)  
    sw $s0, 4($sp)              #store i
    sw $s1, 8($sp)              #store j
    sw $s2, 12($sp)             #store num_changed
    sw $s3, 16($sp)             #15
    sw $s4, 20($sp)             #orig
    sw $s5, 24($sp)             #offset
    sw $s6, 28($sp)             #map[i][j].xdir
    sw $s7, 32($sp)             #map[i][j].ydir
    
    

    li $s0, 0                   #i=0
    li $s2, 0                   #num_changed=0
    li $s3, 15
    
    for1:
        bge $s0, $s3, ending
        li $s1, 0                   #j=0
    
    for2:
        bge $s1, $s3, loop_1
        mul $t0, $s0, 15            #i*num_cols
        add $t1, $t0, $s1           #i*num_cols + j
        mul $t2, $t1, 12            #$t1*1
        add $s5, $t2, $a0           #offset[i][j]
        lb $s4, 0($s5)              #orig = map[i][j].repr; 
        lw $s6, 4($s5)              #$s6=map[i][j].xdir
        lw $s7, 8($s5)              #$s7=map[i][j].ydir
    

    if1:
        bne $s6, $0, if2
        bne $s7, $0, if2
        li $t3, '.'
        sb $t3, 0($s5)

    if2:
        beq $s6, $0, if3
        bne $s7, $0, if3
        li $t3, '_'
        sb $t3, 0($s5)

    if3:
        bne $s6, $0, if4
        beq $s7, $0, if4
        li $t3, '|'
        sb $t3, 0($s5)

    if4:
        mul $t4, $s6, $s7
        ble $t4, $0, if5
        li $t3, '/'
        sb $t3, 0($s5)

    if5:
        mul $t4, $s6, $s7
        bge $t4, $0, if6
        li $t3, '\\'            
        sb $t3, 0($s5)

    if6:
        lb $t5, 0($s5)          #t5=map[i][j].repr
        beq $t5, $s4, loop_2
        add $s2, $s2, 1



    loop_2:
        add $s1, $s1, 1
        j for2

    loop_1:
        add $s0, $s0, 1
        j for1



    ending:
        move $v0, $s2
        lw $ra, 0($sp)  
        lw $s0, 4($sp)              
        lw $s1, 8($sp)              
        lw $s2, 12($sp)
        lw $s3, 16($sp)             
        lw $s4, 20($sp)  
        sw $s5, 24($sp)             
        sw $s6, 28($sp)             
        sw $s7, 32($sp)                                  
        add $sp, $sp, 36
        jr      $ra
