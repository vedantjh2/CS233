#include "transpose.h"
int min(int, int);

// modify this function to add tiling
void transpose_tiled(int **A, int **B) {

    /*
    for (int i = 0; i < SIZE; i ++) {
        for (int j = 0; j < SIZE; j ++) {
            B[i][j] = A[j][i];
        }
    }
    */
    int x = 32;
    for (int i = 0; i < SIZE; i += x) {
        for (int j = 0; j < SIZE; j += x) {
            for (int ii = i; ii < min(i + x, SIZE); ii ++) {
                for (int jj = j; jj < min(j + x, SIZE); jj ++) {
                    B[ii][jj] = A[jj][ii];
                }
            }
        }
    }
}
