section .bss
buffer: resb 5
fd: resb 1

section .data
buflen: dd 4
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
openFile:
  pop ebx
  pop ebx
  pop ebx                       ; file name
  call openFileByName
  mov [fd], eax
  test eax, eax
  jns iterate

exit:
  mov eax, [score]
  call iprintLF

  mov eax, 0x01
  xor ebx, ebx
  int 0x80

iterate:
  mov ebx, [fd]
  mov eax, 0x03
  mov ecx, buffer
  mov edx, [buflen]
  int 0x80
  cmp eax, 0
  je exit
  test eax, eax

  call roundResult

  mov ah, 0
  add [score], eax

  jmp iterate

roundResult:
  mov ch, [buffer + 2]
  mov cl, [buffer]

  mov al, 0

  cmp ch, [secondRockCode]
  je rockCase

  cmp ch, [secondPaperCode]
  je paperCase

  cmp ch, [secondScissorCode]
  je scissorCase

  ret

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
  ret


loseCase:
  add al, [roundScore]
  ret

drawCase:
  add al, [drawScore]
  add al, [roundScore]
  ret
