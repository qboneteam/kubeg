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

//;h,d - y0 y1
//;l,e - x0 x1
	ld a,h
	xor d
	jr nz,.l0
	ld a,e
	xor l
	jr nz,.l0
	ld b,h
	ld c,l
	call plot
	ret
.l0
	ld a,l
	cp e
	jr c,.l1 ;l<e
	ex de,hl
.l1
//function line(x0, x1, y0, y1)
//	int deltax := abs(x1 - x0)
	ld b,l
	ld c,e
	call setDelta
	ld (deltax),a
//	int deltay := abs(y1 - y0)
	ld b,h
	ld c,d
	call setDelta
	ld (deltay),a
//	int error := 0
	xor a
	ld (error),a
//	int deltaerr := deltay
	ld a,(deltay)
	ld (deltaerr),a
//	int y := y0
	ld a,h
	ld (__y),a
//	int diry := y1 - y0
	ld a,d
	sub h
//	if diry > 0
//		diry = 1
//	if diry < 0
//		diry = -1
	jr c,.l2
	or a
	jr z,setdiry
	ld a,1
	jr setdiry
.l2
	ld a,-1
setdiry
	ld (diry),a

cikla:
//	for x from x0 to x1
//		plot(x,y)
	ld a,(deltax)
	ld b,a
	ld e,l
	ld a,(__y)
	ld d,a
.l0:
	push de
	call plot
	pop de
	inc e
//		error := error + deltaerr
	ld a,(deltax)
	ld h,a
	ld a,(deltaerr)
	ld c,a
	ld a,(error)
	add a,c
	ld (error),a
//		if 2 * error >= deltax
	add a,a
	cp h
	jp nc,.l1
//			y := y + diry
//			error := error - deltax
	ld a,(diry)
	add d
	ld d,a
	ld a,(error)
	sub h
	ld (error),a
.l1:
	djnz .l0
	ret
plot:
	ld l,d
	ld h,0
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	add hl,hl
	ld d,0
	add hl,de
	ld de,#5800
	add hl,de
	ld (hl),#ff
	ret
setDelta:
	ld a,b
	sub c
	ret nc
	neg
	ret
deltax
	db 0
deltay
	db 0
error
	db 0
deltaerr
	db 0
__y
	db 0
diry
	db 0




//	ld a,l
//	cp e
//	jr c,.l0 ;l<e
//	ex de,hl
//.l0
//	ld b,h
//	ld c,d
//	call setDelta
//	ld (deltay+1),a
//	ld b,l
//	ld c,e
//	call setDelta
//	ld (deltax+1),a
//deltay
//	cp 0
//	jp c,delyGRdelx ;dx<dy
//
//delxGRdely
//;+- l
//deltax
//	ld a,0
//
//
//
//	ret
//
//delyGRdelx
//;+- h
//ld a,(deltay+1)
//
//	ret
//
	savesna "kubeg.sna",SnaStart