cyan = /bin/echo -e "\x1b[36m\#\# $1\x1b[0m"

include ../makefile.cfg

# Project Root
override HOME = ../../..

# Project Resources
SYSROOT = $(HOME)/../../../sysroot
INCLUDE = $(SYSROOT)/usr/include
SOURCE = $(HOME)/source
TOOLS = $(HOME)/../../tools
BIN = bin/system/kernel
LIB = lib

LDS = kernel.ld

# Tools Config
CFLAGS += -I$(SOURCE) \
         -I$(INCLUDE) \
		 -ffreestanding \
		 -fpie \
		 -nostdlib \
		 -fno-stack-protector \
		 -mno-avx \
		 -mno-sse \
		 -mno-mmx \
		 -mno-3dnow \
		 -mno-red-zone \
		 -mgeneral-regs-only \
		 -g \
		 -fshort-wchar \
		 -Werror \
		 -Wstrict-prototypes \
		 -Wno-ignored-attributes \
		 -Wno-address-of-packed-member \
		 -DGIT_HASH='"$(shell git log --pretty=format:'%h' -n 1)"'

ASMFLAGS = -i$(realpath $(SOURCE)/arch/amd64) -f elf64

LDFLAGS = -T $(LDS) \
		 -nostdlib \
		 -static \
		 --no-dynamic-linker \
		 -Bsymbolic \
		 --no-relax \
		 -z max-page-size=0x1000

# Recursive Wild Card
rwildcard = $(foreach d,$(wildcard $(1:=/*)),$(call rwildcard,$d,$2) $(filter $(subst *,%,$2),$d))

# Source Files
C_SRC = $(SOURCE)/kernel.c # kernel starting point
C_SRC += $(wildcard $(SOURCE)/boot/limine/*.c) # bootprotocol specific
C_SRC += $(call rwildcard,$(SOURCE)/boot/limine/amd64,*.c) # bootprotocol specific & arch specific
C_SRC += $(call rwildcard,$(SOURCE)/arch/amd64,*.c) # arch specific
C_SRC += $(call rwildcard,$(SOURCE)/global,*.c) # global implemented
C_SRC += $(call rwildcard,$(SOURCE)/lib,*.c) # library

ASM_SRC = $(call rwildcard,$(SOURCE)/boot/limine/amd64,*.s) # bootprotocol specific & arch specific
ASM_SRC += $(call rwildcard,$(SOURCE)/arch/amd64,*.s) # arch specific

OBJS = $(patsubst $(SOURCE)/%.c,$(LIB)/%_c.o,$(C_SRC))
OBJS += $(patsubst $(SOURCE)/%.s,$(LIB)/%_s.o,$(ASM_SRC))

# Target
$(LIB)/%_c.o: $(SOURCE)/%.c
	@ mkdir -m 777 -p $(@D)
	@ $(call cyan,"$(subst ../,,$^)")
	@ $(CC) $(CFLAGS) -c $^ -o $@

$(LIB)/%_s.o: $(SOURCE)/%.s
	@ mkdir -m 777 -p $(@D)
	@ $(call cyan,"$(subst ../,,$^)")
	@ $(ASMC) $(ASMFLAGS) $^ -o $@

link:
	@ mkdir -m 777 -p $(BIN)
	@ $(LD) $(LDFLAGS) -o $(BIN)/kernel.elf $(OBJS)

ksym:
	@ sudo $(TOOLS)/ksym $(BIN)/kernel.elf $(BIN)/kernel.sym

kernel.elf: $(OBJS) link ksym
