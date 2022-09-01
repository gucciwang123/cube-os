%ifndef LONGMODE_ASM
%define LONGMODE_ASM

check_longmode:
	push ecx
	mov bp, sp

	pushfd
	pop eax
	mov ecx, eax

	xor eax, 1 << 21

	push eax
	popfd

	pushfd
	pop eax

	push ecx
	popfd

	cmp eax, ecx
	jne .longmode

	mov ax, 0x00
	jmp .end

	.longmode:
		mov ax, 0x01

	.end:
		mov sp, bp
		pop ecx
		ret

%endif
