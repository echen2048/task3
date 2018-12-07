; Main.asm
; Name:
; UTEid: 
; Continuously reads from x4600 making sure its not reading duplicate
; symbols. Processes the symbol based on the program description
; of mRNA processing.
               .ORIG x4000
; initialize the stack pointer
LD R6,BOS
; set up the keyboard interrupt vector table entry
LD R0,ISR
STI R0,KBIVE

; enable keyboard interrupts
LD R0,KBIEN
STI R0,KBSR

; start of actual program


loopAs LDI R0,data ;load buffer to R0
BRz loopAs ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bA
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRnp loopAs ;if not try again

loopUs LDI R0,data ;load buffer to R0
BRz loopUs ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bU
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character u?
BRz loopGs ;if the character is u, we wait at next loop
LD R2,bA ;here we check if the character is a duplicate of first. if it is, then we actually wait for U again
NOT R2,R2
ADD R2,R2,#1
ADD R1,R2,R0
BRz loopUs ;if the next character is a duplicate of first char (A) go back to top to wait again
BRnp loopAs ;if not go back home, try again

loopGs LDI R0,data ;load buffer to R0
BRz loopGs ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bG
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRnp loopAs ;if not go back home, try again

startseq LD R0,pipe ;if we've gotten this far means startseq
TRAP x21 ;print the pipe

;now we start testing for the stop codon. All start with U, so we wait for that, echo all other chars in the meantime
loopUq LDI R0,data ;load buffer to R0
BRz loopUq ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bU
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRnp loopUq ;if not try again

;the next character can be an A or G. Let's test for for both before determining which character next
loopAGq LDI R0,data ;load buffer to R0
BRz loopAGq ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bA
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRz loopAGAq ;if its A, the following one must be G or A, so we test and wait for that
LD R1,bG;otherwise, it might be a G
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1
BRz loopA2q;if it is a G, the last codon must be A
BRnp loopUq ;if it is none of them, we go back home

;if the 2nd stop codon char was an A, then the last char can be either G or A
loopAGAq LDI R0,data
BRz loopAGAq ;check if there is a new character at R0
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bA
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRz exit ;if it is halt
LD R1,bG;otherwise, it might be a G
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1
BRz exit ;if the character is G, again exit
BRnp loopUq ;if not, we screwed up go to top

loopA2q LDI R0,data
BRz loopA2q
TRAP x21
AND R1,R1,#0
STI R1,data ;then clear it
LD R1,bA
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is character a?
BRz exit ;if it is halt
;if the character is u, we actually go back to agq
LD R1,bU
NOT R1,R1
ADD R1,R1,#1
ADD R1,R0,R1 ;is u???
BRz loopAGq
BRnp loopUq

exit TRAP x25 ;good night

KBIEN .FILL x4000
KBSR .FILL xFE00
KBIVE .FILL x0180
ISR .FILL x2600
data .FILL x4600
bA .FILL x0041
bU .FILL x0055
bC .FILL x0043
bG .FILL x0047
pipe .FILL x007C
BOS .FILL x4000
;Tlim .BLKW 1



saver4pop .BLKW 1
		.END