#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "filter.h"

void
filter1(pixel_t **image1, pixel_t **image2, int i) {
    image2[i]->x = image1[i - 1]->x + image1[i + 1]->x;
    image2[i]->y = image1[i - 1]->y + image1[i + 1]->y;
    image2[i]->z = image1[i - 1]->z + image1[i + 1]->z;
}

void
filter2(pixel_t **image1, pixel_t **image2, int i) {
    image2[i]->r = image1[i - 2]->r + image1[i + 2]->r;
    image2[i]->g = image1[i - 2]->g + image1[i + 2]->g;
    image2[i]->b = image1[i - 2]->b + image1[i + 2]->b;
}

void
filter3(pixel_t **image, int i) {
    image[i]->x = image[i]->x + image[i + 5]->x;
    image[i]->y = image[i]->y + image[i + 5]->y;
    image[i]->z = image[i]->z + image[i + 5]->z;
}

void
filter_none(pixel_t **image1, pixel_t **image2) {

    for (int i = 1; i < SIZE - 1; i ++) {
        filter1(image1, image2, i);
    }

    for (int i = 2; i < SIZE - 2; i ++) {
        filter2(image1, image2, i);
    }

    for (int i = 1; i < SIZE - 5; i ++) {
        filter3(image2, i);
    }
}

pixel_t ** init_image1();
pixel_t ** init_image2();

int main(int argc, char **argv) {
    pixel_t **image1 = init_image1();
    pixel_t **image2 = init_image2();

    clock_t c1, c2;

    c1 = clock();
    for (int i = 1; i < NSTEPS; i ++)
        filter_none(image1, image2);
    c2 = clock();

    // Print a random element so that the compiler does not remove the
    // computation above
    printf("Elapsed CPU time with none is %lf seconds\n",
           (((double) c2) - c1) / CLOCKS_PER_SEC);
    int print_pixel = random() % SIZE;
    printf("Image %d \n", image2[print_pixel]->x);

    c1 = clock();
    for (int i = 1; i < NSTEPS; i ++)
        filter(image1, image2);
    c2 = clock();

    printf("Elapsed CPU time with all is %lf seconds\n",
           (((double) c2) - c1) / CLOCKS_PER_SEC);

    // Print a random element so that the compiler does not remove the
    // computation above
    printf("Image %d \n", image2[print_pixel]->x);
}
