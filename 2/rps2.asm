section .text
global rockpaperscissors

rockpaperscissors:
  mov ch, [eax]
  mov cl, [eax + 2]

  mov al, 0

  cmp ch, [rockCode]
  je rockCase

  cmp ch, [paperCode]
  je paperCase

  cmp ch, [scissorCode]
  je scissorCase

  ret

rockCase:
  mov bh, [paper]
  mov bl, [scissor]
  mov dh, [rock]
  jmp win?

paperCase:
  mov bh, [scissor]
  mov bl, [rock]
  mov dh, [paper]
  cmp cl, [mustLose]
  jmp win?

scissorCase:
  mov bh, [rock]
  mov bl, [paper]
  mov dh, [scissor]
  jmp win?

win?:
  cmp cl, [mustLose]
  je lose
  cmp cl, [mustDraw]
  je draw
  cmp cl, [mustWin]
  je win

win:
  add al, [winScore]
  add al, bh
  ret

lose:
  add al, bl
  ret

draw:
  add al, [drawScore]
  add al, dh
  ret

section .data
rockCode:  db 'A'
paperCode: db 'B'
scissorCode: db 'C'

mustLose: db 'X'
mustDraw:  db 'Y'
mustWin:  db 'Z'

rock: db 1
paper:  db 2
scissor:  db 3
winScore:  db 6
drawScore: db 3
