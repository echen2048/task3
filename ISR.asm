; ISR.asm
; Name: Eric Chen and Maddi Sikorski
; UTEid: ec36327
; Keyboard ISR runs when a key is struck
; Checks for a valid RNA symbol and places it at x4600
.ORIG x2600
	AND R1,R1,#0
	STI R1,dest
	
	LDI R0,KBSR
	BRz exitisr

	LDI R1,KBDR

	LD R2,inA
	NOT R2,R2
	ADD R2,R2,#1
	ADD R2,R2,R1
	BRnp checkU
	STI R1,dest
	BRnzp exitisr

	checkU LD R2,inU
	NOT R2,R2
	ADD R2,R2,#1
	ADD R2,R2,R1
	BRnp checkC
	STI R1,dest
	BRnzp exitisr

	checkC LD R2,inC
	NOT R2,R2
	ADD R2,R2,#1
	ADD R2,R2,R1
	BRnp checkG
	STI R1,dest
	BRnzp exitisr

	checkG LD R2,inG
	NOT R2,R2
	ADD R2,R2,#1
	ADD R2,R2,R1
	BRnp exitisr
	STI R1,dest
	BRnzp exitisr

exitisr RTI

KBDR .FILL xFE02
KBSR .FILL xFE00
dest .FILL x4600
inA .FILL x0041
inU .FILL x0055
inC .FILL x0043
inG .FILL x0047
	.END
