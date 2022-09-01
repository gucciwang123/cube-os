global _start

extern entry

section kernal-entry
section .text
bits 64
_start:
	call entry
	jmp $
_end:

