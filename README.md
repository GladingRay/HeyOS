# HeyOS
学习写一个玩具操作系统

## 环境与工具
ubuntu20.04LTS (wsl2 & vmware虚拟机) 
gcc AT&T风格x86汇编  
qemu-system-i386  

## 目前的问题
wsl2 上的qemu -nographic 不支持VGA显示，仅支持通过串口转发，所以目前只能移到vmware上的虚拟机里做，后期可能会再移一份到wsl2上
