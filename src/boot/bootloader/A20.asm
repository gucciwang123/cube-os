%ifndef A20_ASM
%define A20_ASM

%include "src/boot/bootloader/printMacros.asm"

test_A20:
	push bx
	push cx
	push dx
	mov bp, sp

	mov bx, 0xffff
	mov es, bx
	
	mov bx, boot_sector_footer.magic_number
	mov cx, [bx]

	add bx, 0x10
	mov dx, [es:bx]

	cmp cx, dx
	je .noA20

	mov ax, 1
	jmp .end

	.noA20:
		mov ax, 0

	.end:
		mov sp, bp
		pop dx
		pop cx
		pop bx
		ret

%include "src/boot/bootloader/print.asm"
%include "src/boot/bootloader/boot.asm"

%endif
