	device zxspectrum128
	org	#6000
SnaStart:
	inc h
	dec h
	inc l
	dec l


	ei
	ld hl,#4000
	ld de,#4001
	ld bc,#1b00
	ld (hl),l
	ldir

TheLoopa
	xor a
	out (#fe),a
	halt
	inc a
	out (#fe),a
	ld hl,#0000
	ld de,#171f
	call drawline
	ld hl,#1700
	ld de,#001f
	call drawline
	jr TheLoopa

drawline:
//  CP A >= N --- NC
//  CP A <  N --- C
//
//function line(x0, x1, y0, y1)
//	int deltax := abs(x1 - x0)
//	int deltay := abs(y1 - y0)
//	int error := 0
//	int deltaerr := deltay
//	int y := y0
//	int diry := y1 - y0
//	if diry > 0
//		diry = 1
//	if diry < 0
//		diry = -1
//
//	for x from x0 to x1
//		plot(x,y)
//		error := error + deltaerr
//		if 2 * error >= deltax
//			y := y + diry
//			error := error - deltax
;h,d - y
;l,e - x

	ld a,l
	cp e
	jr c,.l0 ;l<e
	ex de,hl
.l0
	ld b,h
	ld c,d
	call setDelta
	ld (deltay+1),a
	ld b,l
	ld c,e
	call setDelta
deltay
	cp 0
	jp c,delyGRdelx ;dx<dy

delxGRdely
;+- l

	ret

delyGRdelx
;+- h


	ret

setDelta:
	ld a,b
	sub c
	ret nc
	neg
	ret
	savesna "kubeg.sna",SnaStart