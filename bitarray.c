/*
    C Bitarray Implementation
*/

#include "types.h"
#include "bitarray.h"

bitarray_t bitarray_create(size_t elements){
    bitarray_t array;
    array.elements = elements;
    //array.data = kmalloc(elements / SIZE_SIZE_T); //should round up

    return array;
}

bool bitarray_get(bitarray_t* array, size_t element){
    //bounds checking
    if(element >= array->elements){
        return -1;
    }

    //calculate element to write into
    size_t index = element / SIZE_SIZE_T;

    //calculate bitmask
    size_t position = element % SIZE_SIZE_T;
    size_t bitmask = true << position;

    return (array->data[index] & bitmask) >> position;
}

void bitarray_set(bitarray_t* array, size_t element, bool value){
    //bounds checking
    if(element >= array->elements){
        return;
    }
    
    //calculate element to write into
    size_t index = element / SIZE_SIZE_T;

    //calculate bitmask
    size_t position = element % SIZE_SIZE_T;

    if(value == true){
        size_t bitmask = true << position;

        array->data[index] = array->data[index] | bitmask;
    }

    else if(value == false){
        size_t bitmask = ~(true << position);
        array->data[index] = array->data[index] & bitmask;
    }
}