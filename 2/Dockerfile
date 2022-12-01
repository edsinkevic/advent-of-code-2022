FROM alpine:latest
COPY . /app
WORKDIR /app
RUN apk add nasm
RUN apk add binutils
RUN nasm -f elf main.asm
RUN ld -m elf_i386 -s -o main main.o
CMD ["./main", "data.txt"]
