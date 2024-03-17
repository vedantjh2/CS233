# Sets the values of the array to the corresponding values in the request
# void fill_array(unsigned request, int* array) {
#   for (int i = 0; i < 6; ++i) {
#     request >>= 3;
#
#     if (i % 3 == 0) {
#       array[i] = request & 0x0000001f;
#     } else {
#       array[i] = request & 0x000000ff;
#     }
#   }
# }
.globl fill_array
fill_array:
    li $t0, 0                   #i = 0
    
    loop:
    bge $t0, 6, endif           #i<6
    srl $a0, $a0, 3             #request >>= 3
    mul $t1, $t0, 4             #i*4
    add $t1, $t1, $a1           #correct array[i]
    rem $t3, $t0, 3
    bne $t3, 0, else_b          #i % 3 == 0
    andi $t2, $a0, 0x0000001f   #request & 0x0000001f
    sw $t2, 0($t1)              #array[i] = request & 0x0000001f
    add $t0, $t0, 1             #i++
    j loop
    else_b:
    andi $t2, $a0, 0x000000ff   #request & 0x000000ff
    sw $t2, 0($t1)              #array[i] = request & 0x000000ff
    add $t0, $t0, 1             #i++
    j loop



    endif:
    jr      $ra
