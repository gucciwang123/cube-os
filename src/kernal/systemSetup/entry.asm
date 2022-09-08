global _start

extern entry

section .entry
bits 64
_start:
	call entry
	jmp $
_end:

