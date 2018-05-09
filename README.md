# kubeg
line calcolating procedure on z80 assembler. Based on wikipedia algorithm:

function line(x0, x1, y0, y1)
  int deltax := abs(x1 - x0)
  int deltay := abs(y1 - y0)
  int error := 0
  int deltaerr := deltay
  int y := y0
  int diry := y1 - y0
  if diry > 0 
    diry = 1
  if diry < 0 
    diry = -1
  for x from x0 to x1
    plot(x,y)
    error := error + deltaerr
    if 2 * error >= deltax
      y := y + diry
      error := error - deltax