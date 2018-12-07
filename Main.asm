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


KBIEN .FILL x4000
KBSR .FILL xFE00
KBIVE .FILL x0180
ISR .FILL x2600
data .FILL x4600

BOS .FILL x4000

.END