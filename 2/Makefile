main.o: main.asm
	nasm -f elf32 main.asm

funcs.o: funcs.asm
	nasm -f elf32 funcs.asm

rps1.o: rps1.asm
	nasm -f elf32 rps1.asm

rps2.o: rps2.asm
	nasm -f elf32 rps2.asm

solve1: main.o funcs.o rps1.o
	ld -m elf_i386 -o solve1 main.o funcs.o rps1.o

solve2: main.o funcs.o rps2.o
	ld -m elf_i386 -o solve2 main.o funcs.o rps2.o
