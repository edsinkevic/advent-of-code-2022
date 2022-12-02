section .text
global _start
extern iprintLF, openFileByName, rockpaperscissors

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

  mov eax, buffer               ; line address in eax for call

  call rockpaperscissors              ;round result in al

  mov ah, 0
  add [score], ax

  jmp iterate

section .bss
buffer: resb 5
fd: resb 1

section .data
score:  dd 0
lineLength:  dd 4
