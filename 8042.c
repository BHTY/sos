/*
    PS/2 driver
*/

#include "types.h"
#include "ports.h"

static char kbdus[128] = 
{
    0,  27, '1', '2', '3', '4', '5', '6', '7', '8',	/* 9 */
  '9', '0', '-', '=', '\b',	/* Backspace */
  '\t',			/* Tab */
  'q', 'w', 'e', 'r',	/* 19 */
  't', 'y', 'u', 'i', 'o', 'p', '[', ']', '\n',	/* Enter key */
    0,			/* 29   - Control */
  'a', 's', 'd', 'f', 'g', 'h', 'j', 'k', 'l', ';',	/* 39 */
 '\'', '`',   0,		/* Left shift */
 '\\', 'z', 'x', 'c', 'v', 'b', 'n',			/* 49 */
  'm', ',', '.', '/',   0,				/* Right shift */
  '*',
    0,	/* Alt */
  ' ',	/* Space bar */
    0,	/* Caps lock */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    1,	/* Up Arrow */
    0,	/* Page Up */
  '-',
    3,	/* Left Arrow */
    0,
    4,	/* Right Arrow */
  '+',
    0,	/* 79 - End key*/
    2,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
};

static char kbdus_shift[128] = 
{
	0,  27, '!', '@', '#', '$', '%', '^', '&', '*',	/* 9 */
  '(', ')', '_', '+', '\b',	/* Backspace */
  '\t',			/* Tab */
  'Q', 'W', 'E', 'R',	/* 19 */
  'T', 'Y', 'U', 'I', 'O', 'P', '{', '}', '\n',	/* Enter key */
    0,			/* 29   - Control */
  'A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L', ':',	/* 39 */
 '\"', '~',   0,		/* Left shift */
 '|', 'Z', 'X', 'C', 'V', 'B', 'N',			/* 49 */
  'M', '<', '>', '?',   0,				/* Right shift */
  '*',
    0,	/* Alt */
  ' ',	/* Space bar */
    0,	/* Caps lock - 58 */
    0,	/* 59 - F1 key ... > */
    0,   0,   0,   0,   0,   0,   0,   0,
    0,	/* < ... F10 */
    0,	/* 69 - Num lock*/
    0,	/* Scroll Lock */
    0,	/* Home key */
    1,	/* Up Arrow */
    0,	/* Page Up */
  '-',
    3,	/* Left Arrow */
    0,
    4,	/* Right Arrow */
  '+',
    0,	/* 79 - End key*/
    2,	/* Down Arrow */
    0,	/* Page Down */
    0,	/* Insert Key */
    0,	/* Delete Key */
    0,   0,   0,
    0,	/* F11 Key */
    0,	/* F12 Key */
    0,	/* All other keys are undefined */
};

/* Special key status */
static volatile unsigned shift = 0;
static volatile unsigned caps_lock = 0;

/* Set the keyboard LEDs */
static void set_leds(uint8_t state)
{
	/* Wait until we can send data */
	while(io_read_8(0x64) & 0x2);

	/* Set the LED */
	io_write_8(0x60, 0xED);
	io_write_8(0x60, state);
}

char getch(){
    while(!(io_read_8(0x64) & 0x1)){
        yield();
    }

	uint8_t scancode = io_read_8(0x60);

    /* Key has been released */
	if (scancode & 0x80)
	{
		switch (scancode)
		{
		/* Left shift */
		case 0xAA:
			shift = 0;
			break;
		/* Right shift */
		case 0xB6:
			shift = 0;
			break;
		default:
			break;
		}
	}
	/* Key has been pressed */
	else
	{
		switch (scancode)
		{
		/* Left shift */
		case 0x2A:
			shift = 1;
			break;
		/* Right shift */
		case 0x36:
			shift = 1;
			break;
		/* Caps lock */
		case 0x3A:
			caps_lock = !caps_lock;
			set_leds(caps_lock << 2);
			break;
		default:
			/* If a normal key is being pressed, translate and return it */
			if (shift)
			{
				if (caps_lock)
				{
					return kbdus[scancode];
				}
				else
				{
					return kbdus_shift[scancode];
				}
			}
			else if (caps_lock)
			{
				return kbdus_shift[scancode];
			}
			else
			{
				return kbdus[scancode];
			}
		}
	}

	return 0;
}