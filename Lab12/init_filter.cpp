#include "filter.h"
#include <stdlib.h>
#include <stdio.h>

pixel_t ** init_image1(){
    pixel_t *data1 = (pixel_t *) malloc(SIZE * 10 * sizeof(pixel_t));
    pixel_t **image1 = (pixel_t **) malloc(SIZE * sizeof(pixel_t *));

    bool *used = (bool *) calloc(SIZE * 10, sizeof(bool)); // zero-initialized

    for (int i = 0; i < SIZE; i ++) {
        int ii;
        do {
            ii = random() % (SIZE * 10);
        } while (used[ii]);
        used[ii] = true;
        image1[i] = &data1[ii];
        image1[i]->x = random() % 1024;
        image1[i]->y = random() % 1024;
        image1[i]->z = random() % 1024;
        image1[i]->r = random() % 256;
        image1[i]->g = random() % 256;
        image1[i]->b = random() % 256;
    }

    return image1;
}

pixel_t ** init_image2(){
    pixel_t *data2 = (pixel_t *) malloc(SIZE * 10 * sizeof(pixel_t));
    pixel_t **image2 = (pixel_t **) malloc(SIZE * sizeof(pixel_t *));

    bool *used = (bool *) calloc(SIZE * 10, sizeof(bool)); // zero-initialized

    for (int i = 0; i < SIZE; i ++) {
        int ii;
        do {
            ii = random() % (SIZE * 10);
        } while (used[ii]);
        used[ii] = true;
        image2[i] = &data2[ii];
    }

    return image2;
}

int min(int x, int y){
    if (x < y)
        return x;
    else
        return y;
}
