CC =gcc
INC =-I ./bootloader/ -I ./heysrc/include/
all: HeyOS.img

HeyOS.img: boot.bin
	dd if=/dev/zero of=HeyOS.img count=100
	dd if=boot.bin of=HeyOS.img conv=notrunc

boot.bin : boot.o
	ld -m elf_i386 -N -e _start -Ttext 0x7c00 -o boot.elf boot.o 
	objdump -S boot.elf > boot.asm  
	objcopy -S -O binary boot.elf boot.bin  

boot.o: bootloader/boot.s bootloader/bios_tools.s
	gcc -c -m32 -o boot.o bootloader/boot.s -g -O0 $(INC)

qemu-nox-gdb: HeyOS.img
	qemu-system-i386 -hda HeyOS.img -nographic -s -S -smp 2

qemu-nox: HeyOS.img
	qemu-system-i386 -hda HeyOS.img -nographic

clean:
	rm *.o *.img *.elf *.bin