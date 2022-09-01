%ifndef PRINT_MACROS_ASM
%define PRINT_MACROS_ASM

%macro d_PRINT 2
	push si
	push di

	mov si, %1
	mov di, %2
	call print
	add sp, 4

	pop di
	pop si
%endmacro

%macro d_PRINTH 1
	push ax
	
	mov ax, %1
	call printh
	
	pop ax
%endmacro

%endif

