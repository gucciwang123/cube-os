global loadIDT

section .text
loadIDT:
	lidt [0x10000]
	ret
