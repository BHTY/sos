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

void main(){
    while(1){
        puts("Hello, world from Protected Mode!\n");
    }
    
    return;
}