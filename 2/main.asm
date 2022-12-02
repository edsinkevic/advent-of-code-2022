section .bss
buffer: resb 5 ; A 2 KB byte buffer used for read
fd: resb 1

section .data
buflen: dd 4 ; Size of our buffer to be used for read
score:  dd 0
dalbajob: db 'dalbajob', 0

firstRockCode:  db 'A'
firstPaperCode: db 'B'
firstScissorCode: db 'C'

secondRockCode: db 'X'
secondPaperCode:  db 'Y'
secondScissorCode:  db 'Z'
rock: db 1
paper:  db 2
scissor:  db 3
lineLength:  db 4
roundScore:  db 0
winScore:  db 6
drawScore: db 3

section .text
global _start
extern intToString, atoi, iprintLF, sprint, openFileByName

_start:
  ; open(char *path, int flags, mode_t mode);
mov byte [buflen + 4], 0
pop ebx ; argc
pop ebx ; argv[0] (executable name)
pop ebx ; argv[1] (desired file name)
mov eax, 0x05 ; syscall number for open
xor ecx, ecx ; O_RDONLY = 0
xor edx, edx ; Mode is ignored when O_CREAT isn't specified
int 0x80 ; Call the kernel
mov [fd], eax
test eax, eax ; Check the output of open()
jns fileRead ; If the sign flag is set (positive) we can begin reading the file

; = If the output is negative, then open failed. So we should exit
exit:
mov eax, [score]
call iprintLF

mov eax, 0x01 ; 0x01 = syscall for exit
xor ebx, ebx ; makes ebx technically set to zero
int 0x80

; = Begin reading the file

fileRead:
; read(int fd, void *buf, size_t count);
mov ebx, [fd] ; Move our file descriptor into ebx
mov eax, 0x03 ; syscall for read = 3
mov ecx, buffer ; Our 2kb byte buffer
mov edx, [buflen] ; The size of our buffer
int 0x80
cmp eax, 0
je exit
test eax, eax ; Check for errors / EOF
jz fileOut ; If EOF, then write our buffer out.

fileOut:
; write(int fd, void *buf, size_t count);

call roundResult

mov ah, 0
add [score], eax

jmp fileRead ; All done

roundResult:
  mov ch, [buffer + 2]             ; first
  mov cl, [buffer]         ; second

  mov al, 0

  cmp ch, [secondRockCode]
  je rockCase

  cmp ch, [secondPaperCode]
  je paperCase

  cmp ch, [secondScissorCode]
  je scissorCase

  jmp recover

rockCase:
  mov al, [rock]
  cmp cl, [firstScissorCode]
  je winCase
  cmp cl, [firstPaperCode]
  je loseCase
  jmp drawCase

paperCase:
  mov al, [paper]
  cmp cl, [firstRockCode]
  je winCase
  cmp cl, [firstScissorCode]
  je loseCase
  jmp drawCase

scissorCase:
  mov al, [scissor]
  cmp cl, [firstPaperCode]
  je winCase
  cmp cl, [firstRockCode]
  je loseCase

  jmp drawCase

winCase:
  add al, [winScore]
  add al, [roundScore]
  jmp recover


loseCase:
  add al, [roundScore]
  jmp recover


drawCase:
  add al, [drawScore]
  add al, [roundScore]
  jmp recover

recover:
  ret

pr:
  push eax
  mov eax, dalbajob
  call sprint
  pop eax
  ret
