file := FileStream open: 'data.txt' mode: FileStream read.
count := 0.
file linesDo: [ 
  :line | 
  firstAssignment := (line substrings: ',') first. 
  secondAssignment := (line substrings: ',') last.
  first := firstAssignment substrings: '-'.
  second := secondAssignment substrings: '-'.
  firstMin := first first asInteger.
  firstMax := first last asInteger.
  secondMin := second first asInteger.
  secondMax := second last asInteger.
  overlapFirst := (firstMin <= secondMin) & (firstMax >= secondMax).
  overlapSecond := (secondMin <= firstMin) & (secondMax >= firstMax).

  overlap := overlapSecond | overlapFirst.

  line displayNl.

  overlap ifTrue: [
  count := count + 1.
  ].
].

count displayNl.

file close.
