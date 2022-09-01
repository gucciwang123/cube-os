%ifndef PRINT_ASM
%define PRINT_ASM

print:
	mov ah, 0x0e
	
	.loop:
		mov al, [si]
		int 0x10

		inc si
		cmp si, di
		jb .loop

	.print_footer:
		mov al, 10
		int 0x10
		mov al, 13
		int 0x10
	ret

printh:
	pusha
	mov bp, sp
	
	xor cx, cx
	
	.loop:
		mov dx, 0
		mov bx, 0x10
		div bx
	
		cmp dx, 0xa
		jae .letter
	
		add dx, 0x30
		jmp .addToStack
	
		.letter:
			add dx, 0x37					
	
		.addToStack:
		push dx
	
		inc cx
	
		cmp cx, 4
		jb .loop
	
	push "x"
	push "0"
	
	mov di, bp
	mov si, sp
	call print
	
	mov sp, bp		
	popa
	ret

%endif
