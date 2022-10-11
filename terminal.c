#include "types.h"
#include "string.h"
#include "ports.h"
#include "stdarg.h"

#define TEXT_BUFFER (char*)0xb8000
#define CHARS_PER_LINE 80
#define LINES 25

uint8_t COLOR_ATTR = 0x20;
uint16_t cursor_position = 0;

void gotoxy(uint8_t x, uint8_t y){
	cursor_position = CHARS_PER_LINE * y + x;
    //set cursor position
    io_write_8(0x3D4, 14);
    io_write_8(0x3D5, cursor_position >> 8);
    io_write_8(0x3D4, 15);
    io_write_8(0x3D5, cursor_position);
}

uint16_t getpos(){
	return cursor_position;
}

void setcolor(uint8_t col){
    COLOR_ATTR = col;
}

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

int32_t numtostr(uint8_t *str, int num, int base, int sign){ //0=unsigned, 1=signed
	uint32_t i;
	
	if (sign && (num < 0)){
		str[0] = '-';
		i = 1;
		num = ~num + 1;
	}
	else{
		i = 0;
	}

	uint32_t places = ilog(num, base);

	while (places > 1){
		uint32_t temp = ipow(base, places - 1);
		uint32_t tmp = (num - (num % temp));
		str[i] = hexch(tmp / temp);
		num -= tmp;

		places--;
		i++;
	}

	str[i] = hexch(num);
	str[i + 1] = 0;

	return i + 1;
}

int ksprintf(uint8_t *buf, uint8_t *fmt, va_list args){

	uint8_t *str;
	uint16_t i;
	uint16_t len;
	uint8_t *s;

	for (str = buf; *fmt; ++fmt){

		if (*fmt != '%'){
			*str++ = *fmt;
			continue;
		}

		fmt++;

		switch (*fmt){
			case 'c':
				*str++ = (uint8_t)va_arg(args, int);
				break;
			case 's':
				s = va_arg(args, uint8_t*);
				len = strlen(s);
				for (i = 0; i < len; ++i) *str++ = *s++;
				break;
			case 'o':
				break;
			case 'x':
				str += numtostr(str, va_arg(args, size_t), 16, 0);
				break;
			case 'X':
				str += numtostr(str, va_arg(args, size_t), 16, 1);
				break;
			case 'p':
				str += numtostr(str, va_arg(args, size_t), 16, 0);
				break;
			case 'd':
			case 'i':
				str += numtostr(str, va_arg(args, size_t), 10, 1);
				break;
			case 'u':
				str += numtostr(str, va_arg(args, size_t), 10, 0);
				break;
			case 'b':
				str += numtostr(str, va_arg(args, size_t), 2, 0);
				break;
			case 'B':
				str += numtostr(str, va_arg(args, size_t), 2, 1);
				break;
			default:
                *str++ = '%';
				break;
		}

	}

	*str = 0;

	return str - buf;

}

int kprintf(uint8_t *fmt, ...){
	uint8_t buf[1024];

	va_list args;
	int i;
	va_start(args, fmt);
	i = ksprintf(buf, fmt, args);
	va_end(args);
	buf[i] = '\0';
	puts(buf);
	return i;
}