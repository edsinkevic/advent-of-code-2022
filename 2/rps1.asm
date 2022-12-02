section .text
global rockpaperscissors

rockpaperscissors:
  mov ch, [eax + 2]
  mov cl, [eax]

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

section .data
firstRockCode:  db 'A'
firstPaperCode: db 'B'
firstScissorCode: db 'C'

secondRockCode: db 'X'
secondPaperCode:  db 'Y'
secondScissorCode:  db 'Z'
rock: db 1
paper:  db 2
scissor:  db 3
winScore:  db 6
drawScore: db 3
