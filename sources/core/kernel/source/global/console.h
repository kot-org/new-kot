#ifndef _GLOBAL_CONSOLE_H
#define _GLOBAL_CONSOLE_H

#include <stdint.h>
#include <impl/graphics.h>

#define DEFAULT_BG_COLOR 0x333333
#define DEFAULT_FG_COLOR 0xEEEEEE

void console_set_bg_color(uint32_t bg);
void console_set_fg_color(uint32_t fg);

void console_init(boot_fb_t* boot_fb);

void console_putchar(char c);
void console_print(const char* str);

#endif // _GLOBAL_CONSOLE_H