CC =gcc

all: boot.bin

boot.bin : boot.o
	ld -m elf_i386 -N -e _start -Ttext 0x7c00 -o boot.elf boot.o 
	objdump -S boot.elf > boot.asm  
	objcopy -S -O binary boot.elf boot.bin  

boot.o: bootloader/boot.s
	gcc -c -m32 -o boot.o bootloader/boot.s -g

qemu-nox-gdb: boot.bin
	qemu-system-i386 -fda boot.bin -nographic -boot a -s -S -smp 2

qemu-nox: boot.bin
	qemu-system-i386 -fda boot.bin -nographic -boot a

clean:
	rm *.o *.img *.elf *.bin