FROM alpine:latest
COPY . .
CMD ["nasm", "-f", "elf", "main.asm"]
CMD ["ld", "-m", "elf_i385", "-s", "-o", "main", "main.o"]
CMD ["ls"]
CMD ["./main", "main.asm"]
