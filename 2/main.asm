section .text
global _start
extern intToString, atoi, iprintLF, sprint, openFileByName

_start:
openFile:
  pop ebx
  pop ebx
  pop ebx                       ; file name
  call openFileByName           ; file descriptor in eax
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
  mov edx, [lineLength]
  int 0x80
  cmp eax, 0
  je exit

  call roundResult              ;round result in al

  mov ah, 0
  add [score], ax

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
  mov dh, [firstScissorCode]
  mov dl, [firstPaperCode]
  jmp win?

paperCase:
  mov al, [paper]
  mov dh, [firstRockCode]
  mov dl, [firstScissorCode]
  jmp win?

scissorCase:
  mov al, [scissor]
  mov dh, [firstPaperCode]
  mov dl, [firstRockCode]
  jmp win?

win?:
  cmp cl, dh
  je win
  cmp cl, dl
  je lose
  jmp draw

win:
  add al, [winScore]
  ret

lose:
  ret

draw:
  add al, [drawScore]
  ret

section .bss
buffer: resb 5
fd: resb 1

section .data
score:  dd 0

firstRockCode:  db 'A'
firstPaperCode: db 'B'
firstScissorCode: db 'C'

secondRockCode: db 'X'
secondPaperCode:  db 'Y'
secondScissorCode:  db 'Z'
rock: db 1
paper:  db 2
scissor:  db 3
lineLength:  dd 4
winScore:  db 6
drawScore: db 3
