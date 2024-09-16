	processor 6502
	include "vcs.h"
	include "macro.h"
	SEG
	ORG $F000
Reset
StartOfFrame
	; Start of vertical blank processing
	lda #0										; 2
	sta VBLANK									; 3
	lda #2										; 2
	sta VSYNC									; 3
	; 3 scanlines of VSYNCH signal...
	sta WSYNC									; 3
	sta WSYNC									; 3
	sta WSYNC									; 3
	lda #0										; 2
	sta VSYNC									; 3
	; 37 scanlines of vertical blank...
	ldx #0										; 2
	stx $40										; 3
loopa inx
	cpx #37										; 2
	sta WSYNC									; 3
	bne loopa									; 3

	; 192 scanlines of picture...
	ldy #50										; 2
	REPEAT 192; scanlines
		;iny									; 2
		sty COLUBK								; 3
		
		sta WSYNC								; 3
	REPEND
	lda #%01000010								; 2
	sta VBLANK ; end of screen - enter blanking ; 3
	; 30 scanlines of overscan...
	ldx #0										; 2
	stx $40										; 3
loopb inx
	cpx #37										; 2
	sta WSYNC									; 3
	bne loopb									; 3
	
	jmp StartOfFrame
	ORG $FFFA
	.word Reset ; NMI
	.word Reset ; RESET
	.word Reset ; IRQ
END