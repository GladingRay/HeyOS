target remote localhost:1234
file build/kernel.elf
add-symbol-file build/boot.elf

b boot_start
b pm_start
b kernel_entry