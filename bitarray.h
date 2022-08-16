#ifndef __BITARRAY_H
#define __BITARRAY_H

#define SIZE_SIZE_T     (8*sizeof(size_t))

typedef struct bitarray_t{
    size_t *data;
    size_t elements;
} bitarray_t;

bitarray_t bitarray_create(size_t elements);
bool bitarray_get(bitarray_t* array, size_t element);
void bitarray_set(bitarray_t* array, size_t element, bool value);

#endif