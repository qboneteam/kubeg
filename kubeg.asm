	device zxspectrum128
	org	#6000
SnaStart:
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
	jr TheLoopa

	savesna "kubeg.sna",SnaStart