	device zxspectrum128
	org	#6000
SnaStart:


;	inc d ;#14 - %00010100
;	dec d ;#15 - %00010101
;	inc e ;#1c - %00011100
;	dec e ;#1d - %00011101

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
	ld a,#ff
	ld (kkolor+1),a
	ld hl,#0000
	ld de,#0117
	call drawline
	ld hl,#0000
	ld de,#171f
	call drawline
	ld hl,#0000
	ld de,#171e
	call drawline


	ld a,#55
	ld (kkolor+1),a
	ld hl,#000
	ld de,#1701
	call drawline
	jr TheLoopa

drawline:
;h,d - y0 y1
;l,e - x0 x1

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
	ld c,a
	ld a,(deltax)
	cp c
	jr nc,lx
;	jr $
;----------------
	ld a,#14 ;inc d
	ld (change_a_coord),a

	ld a,h
	cp d
	jr c,.l1 ;l<e
	ex de,hl
.l1
	ld a,(deltay)
	ld c,a
	inc a
	ld xl,a
//function line(x0, x1, y0, y1)
//	int deltaerr := deltay
	ld a,(deltax)
	ld (deltaerr+1),a
//	int y := y0
//	int diry := y1 - y0
	ld a,e
	sub l
//	if diry > 0
//		diry = 1
//	if diry < 0
//		diry = -1
	jr c,.l2
	or a
	jr z,setdirx
	ld a,#1c ;inc e
	jr setdirx
.l2
	ld a,#1d ;dec e
setdirx
	ld (change_b_coord),a
	jr cikla


lx
	ld a,#1c ;inc e
	ld (change_a_coord),a

	ld a,l
	cp e
	jr c,.l1 ;l<e
	ex de,hl
.l1
	ld a,(deltax)
	ld c,a
	inc a
	ld xl,a
//function line(x0, x1, y0, y1)
//	int deltaerr := deltay
	ld a,(deltay)
	ld (deltaerr+1),a
//	int y := y0
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
	ld a,#14 ;inc d
	jr setdiry
.l2
	ld a,#15 ;dec d
setdiry
	ld (change_b_coord),a
	jr cikla

cikla:
//	for x from x0 to x1
//		plot(x,y)
//	int error := 0
	ld b,0
	ex de,hl
loopa:
	push de
	call plot
	pop de
change_a_coord
	nop
//		error := error + deltaerr
	ld a,b
deltaerr:
	add 0
	ld b,a
//		if 2 * error >= deltax
	add a,a
	cp c
	jp c,preloop
//			y := y + diry
//			error := error - deltax
change_b_coord:
	nop
	ld a,b
	sub c
	ld b,a
preloop:
	dec xl
	jr nz,loopa
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
kkolor
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
	savesna "kubeg.sna",SnaStart