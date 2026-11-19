#!/bin/bash

zig build

if ! grub-file --is-x86-multiboot zig-out/bin/kernel.elf; then
    echo "Error: kernel.elf is not a valid multiboot file." >&2
    exit 1
fi

rm -rf isodir

mkdir -p isodir/boot/grub
cp zig-out/bin/kernel.elf isodir/boot/kernel.elf
cp grub.cfg isodir/boot/grub/grub.cfg
grub-mkrescue -o morgan.iso isodir


qemu-system-x86_64 -cdrom morgan.iso
