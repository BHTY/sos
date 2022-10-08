#include "types.h"
#include "string.h"
#include "ports.h"

#define TEXT_BUFFER (char*)0xb8000
#define CHARS_PER_LINE 80
#define LINES 25
#define COLOR_ATTR 0x20

int cursor_position = 0;

void scroll(){
    for(int i = 0; i < LINES - 1; i++){
        kmemcpy(TEXT_BUFFER + CHARS_PER_LINE*i*2, TEXT_BUFFER + CHARS_PER_LINE*(i+1)*2, CHARS_PER_LINE * 2);    
    }

    kmemset(TEXT_BUFFER + (LINES-1)*CHARS_PER_LINE*2, 0, CHARS_PER_LINE * 2);
}

void putch(char ch){
    if(ch == 0x08 && cursor_position > 0){ //backspace
        cursor_position--;
    }

    else if(ch == 0x09){
        cursor_position++;
    }

    else if(ch == 0x0b){ //down one row
        cursor_position += CHARS_PER_LINE;
    }

    else if(ch == 0x0d){ //carriage return
        cursor_position = (cursor_position - (cursor_position % CHARS_PER_LINE));
    }

    else if(ch == 0x0a){ //\n
        cursor_position = 80 + (cursor_position - (cursor_position % CHARS_PER_LINE));
    }

    else{ //standard character
        *(TEXT_BUFFER + cursor_position * 2) = ch;
        *(TEXT_BUFFER + cursor_position * 2 + 1) = COLOR_ATTR;

        cursor_position++;
    }

    if(cursor_position >= (CHARS_PER_LINE * LINES)){
        scroll();
        cursor_position -= CHARS_PER_LINE;
    }

    //set cursor position
    io_write_8(0x3D4, 14);
    io_write_8(0x3D5, cursor_position >> 8);
    io_write_8(0x3D4, 15);
    io_write_8(0x3D5, cursor_position);
}

void puts(char* str){
    while(*str){
        putch(*(str++));
    }
}

uint32_t ilog(uint32_t num, uint32_t base){
    uint32_t t = 0;

    while(num >= 1){
        num /= base;
        t++;
    }

    return t;
}

int32_t ipow(uint32_t base, uint32_t power){
    int32_t t = 1;

    while(power > 0){
        power--;
        t *= base;
    }

    return t;
}

char hexch(uint8_t num){ //for a number between 0 and 15, get the hex digit 0-f
    if(num < 10){
        return (char)(num + 48);
    }
    return (char)(num + 55);
}

int32_t hex(uint32_t num, char* str){ //places hex of number into str
    str[0] = '0';
    str[1] = 'x';

    //determine number of places and move backwards
    uint32_t places = ilog(num, 16);
    uint32_t i = 2;

    while(places > 1){
        uint32_t temp = ipow(16, places - 1);
        uint32_t tmp = (num - (num % temp));
        str[i] = hexch(tmp/temp);
        num -= tmp;

        places--;
        i++;
    }

    str[i] = hexch(num);
    str[i+1] = 0;

    return i+1;
}

