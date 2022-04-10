CC 		=gcc
INC 	=-I ./bootloader/ -I ./hey/include/
CFLAGS 	=-fno-pic -static -fno-builtin -fno-strict-aliasing -ffreestanding -c -m32 -O0 -g

HEADERS=./hey/include/*.h
KERNEL_DIR=hey/kernel

SRC=$(wildcard $(KERNEL_DIR:%=%/*.c))
OBJ=$(SRC:%.c=build/%.o)

all : mkbuild HeyOS.img

mkbuild:
	-mkdir $(sort $(dir $(OBJ))) -p

HeyOS.img: build/boot.bin build/kernel.bin
	dd if=/dev/zero of=HeyOS.img count=1000
	dd if=build/boot.bin of=HeyOS.img conv=notrunc
	dd if=build/kernel.bin of=HeyOS.img conv=notrunc seek=1

build/boot.bin : build/boot.o
	ld -m elf_i386 -N -e boot_start -Ttext 0x7c00 -o build/boot.elf build/boot.o 
	objdump -S build/boot.elf > build/boot.asm  
	objcopy -S -O binary build/boot.elf build/boot.bin  

build/boot.o: bootloader/boot.s bootloader/bios_tools.s
	$(CC) -c -m32 -o build/boot.o bootloader/boot.s -g $(INC)

build/kernel.bin: $(OBJ)
	ld -m elf_i386 -N -T kernel.ld -o build/kernel.elf $^
	objdump -S build/kernel.elf > build/kernel.asm
	objcopy -S -O binary build/kernel.elf build/kernel.bin
#	ld -m elf_i386 -N -e kernel_entry -Ttext 0x1000 -o build/kernel.bin $^ --oformat binary

build/%.o : %.c $(HEADERS)
	$(CC) $(CFLAGS) -o $@ $< $(INC)

.PHONY: qemu-gdb
qemu-gdb: all
	qemu-system-i386 -hda HeyOS.img -s -S

.PHONY: qemu
qemu: all
	qemu-system-i386 -hda HeyOS.img

.PHONY: qemu-nox-gdb
qemu-nox-gdb: all
	qemu-system-i386 -hda HeyOS.img -nographic -s -S

.PHONY: qemu-nox
qemu-nox: all
	qemu-system-i386 -hda HeyOS.img -nographic

.PHONY: clean
clean:
	-rm -rf build *.o *.img *.elf *.bin
