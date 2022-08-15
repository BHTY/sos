#define TEXT_BUFFER (char*)0xb8000
#define CHARS_PER_LINE 80
#define LINES 25

int cursor_position = 0;

void kmemset(unsigned char* ptr, unsigned char value, int num){
    while(num--){
        *(ptr++) = value;
    }
}

void kmemcpy(unsigned char* dst, unsigned char* src, int count){
    while(count--){
        *(dst++) = *(src++);
    }
}

char* kstrcpy(char* dest, char* src){
    char* ptr = dest;

    while(*src){
        *(dest++) = *(src++);
    }

    *dest = 0;

    return ptr;
}

void scroll(){
    for(int i = 0; i < LINES - 1; i++){
        kmemcpy(TEXT_BUFFER + CHARS_PER_LINE*i*2, TEXT_BUFFER + CHARS_PER_LINE*(i+1)*2, CHARS_PER_LINE * 2);    
    }

    kmemset(TEXT_BUFFER + (LINES-1)*CHARS_PER_LINE*2, 0, CHARS_PER_LINE * 2);
}

void putch(int ch){
    if(ch == 0x08){ //backspace
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
        *(TEXT_BUFFER + cursor_position * 2 + 1) = 0x0f;

        cursor_position++;
    }

    if(cursor_position >= (CHARS_PER_LINE * LINES)){
        scroll();
        cursor_position -= CHARS_PER_LINE;
    }
}

void puts(char* str){
    while(*str){
        putch(*(str++));
    }
}

unsigned int ilog(unsigned int num, unsigned int base){
    unsigned int t = 0;

    while(num >= 1){
        num /= base;
        t++;
    }

    return t;
}

int ipow(unsigned int base, unsigned int power){
    int t = 1;

    while(power > 0){
        power--;
        t *= base;
    }

    return t;
}

char hexch(unsigned int num){ //for a number between 0 and 15, get the hex digit 0-f
    if(num < 10){
        return (char)(num + 48);
    }
    return (char)(num + 55);
}

int hex(unsigned int num, char* str){ //places hex of number into str
    str[0] = '0';
    str[1] = 'x';

    //determine number of places and move backwards
    unsigned int places = ilog(num, 16);
    unsigned int i = 2;

    while(places > 1){
        unsigned int temp = ipow(16, places - 1);
        unsigned int tmp = (num - (num % temp));
        str[i] = hexch(tmp/temp);
        num -= tmp;

        places--;
        i++;
    }

    str[i] = hexch(num);
    str[i+1] = 0;

    return i+1;
}

void main(){
    char str[20];
    hex(-2, str);
    puts(str);

    /**while(1){
        puts("Hello, world from Protected Mode!\n");
    }**/

    return;
}