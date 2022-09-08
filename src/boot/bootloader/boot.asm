;;main file for OS boot sector
%ifndef BOOT_ASM
%define BOOT_ASM

%define STACK_BOTTOM 0x10008
%define STACK_TOP 0x7FFFF

%define L4_PAGE 0x1000
%define L3_PAGE 0x2000
%define L2_PAGE 0x3000

%define L1_PAGE 0x4000
%define L1_PAGE_END 0x4fff

%define MEMORY_MAP_START 0x5000
%define MEMORY_MAP_END 0x7BFF

%define NUM_OF_FINAL_BOOT_SECTORS 1

%define NUM_OF_KERNAL_ENTRY_SECTORS 8
%define KERNAL_ENTRY_POINT 0x100000
%define KERNAL_READ_LOCATION BOOT_ASM_end

%define BOOT_DEVICE_ID [boot_drive]

%include "src/boot/bootloader/printMacros.asm"

bits 16
org 0x7c00

section .boot
global _start
_start:

cli
jmp 0x00:.initializer
.initializer:
	mov [boot_drive], dl

	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx
	xor si, si
	xor di, di

	mov es, ax
	mov ss, ax
	mov ds, ax
	mov fs, ax
	mov gs, ax
	cld

enable_a20:
	call test_A20
	cmp ax, 0
	je .A20Off
	jmp readNextSector

	.A20Off:
		mov ax, 0x2401
		int 0x15

		call test_A20
		cmp ax, 0
		jne readNextSector

		d_PRINT noA20_message, noA20_message.end
		jmp finalizer

readNextSector:
	mov ah, 0x02
	mov al, NUM_OF_FINAL_BOOT_SECTORS
	mov ch, 0
	mov cl, 2
	mov dh, 0
	mov dl, BOOT_DEVICE_ID

	xor bx, bx
	mov es, bx
	mov bx, BOOT_SECOND_SECTOR

	int 0x13

	cmp al, NUM_OF_FINAL_BOOT_SECTORS
	jne .diskerror

	jc .diskerror

	jmp read_kernal_entry

	.diskerror:
		d_PRINT diskerror_message, diskerror_message.end

finalizer:
	d_PRINT end_message, end_message.end
	jmp $

%include "src/boot/bootloader/print.asm"
%include "src/boot/bootloader/A20.asm"

data:
end_message: db "End of instruction."
.end:

noA20_message: db "A20 line is not available."
.end:

nolongmode_message: db "Long mode is not available."
.end:

diskerror_message: db "Error reading kernal from disk."
.end:

transition_message: db "Transitioning to long mode."
.end:

memory_map_message: db "Error getting memory map"
.end:

memory_map_out_of_bound_message: db "Not enough memory for memory map"
.end:

boot_drive: db 0x00

boot_sector_footer:
	times (510 - ($ - $$)) db 0x0
.magic_number:
	dw 0xaa55
.end:

BOOT_SECOND_SECTOR:

read_kernal_entry:
	mov ah, 0x02
	mov al, NUM_OF_KERNAL_ENTRY_SECTORS
	mov ch, 0
	mov cl, 2 + NUM_OF_FINAL_BOOT_SECTORS
	mov dh, 0
	mov dl, BOOT_DEVICE_ID

	xor bx, bx
	mov es, bx
	mov bx, KERNAL_READ_LOCATION
	int 0x13

	cmp al, NUM_OF_KERNAL_ENTRY_SECTORS
	jne .diskerror

	jc .diskerror

	jmp longmode_comp

	.diskerror:
		d_PRINT diskerror_message, diskerror_message.end
		jmp finalizer

longmode_comp:
	call check_longmode
	cmp ax, 0x01
	jne .nolongmode
	jmp enable_paging

	.nolongmode:
		d_PRINT nolongmode_message, nolongmode_message.end
		jmp finalizer

enable_paging:
	mov si, L4_PAGE
	mov di, L1_PAGE_END
	.clear_table:
		mov [si], dword 0x00
		add si, 4

		cmp si, di
		jbe .clear_table

	mov edi, L4_PAGE
	mov cr3, edi

	mov [L4_PAGE], dword L3_PAGE + 0x03
	mov [L3_PAGE], dword L2_PAGE + 0x03
	mov [L2_PAGE], dword L1_PAGE + 0x03

	mov edi, L1_PAGE
	mov ebx, 0x03

	.map_L1_page:
		mov [edi], ebx

		add ebx, 0x1000
		add edi, 8

		cmp edi, L1_PAGE_END
		jbe .map_L1_page

mov di, MEMORY_MAP_START + 2
mov ebx, 0
mov es, ebx

get_memory_map:
	mov eax, 0xE820
	mov ecx, 24
	mov edx, 0x534D4150
	int 0x15

	.error:
		jnc .no_error
		d_PRINT memory_map_message, memory_map_message.end
		jmp finalizer
	.no_error:

	add di, 24

	.out_of_bound:
		cmp di, MEMORY_MAP_END
		jnae .out_of_bound_no_error
		d_PRINT memory_map_message, memory_map_message.end
		jmp finalizer
	.out_of_bound_no_error:

	cmp ebx, 0
	jne get_memory_map

mov [MEMORY_MAP_START], di

setup_longmode:
	mov eax, cr4
	or eax, 1<<5
	mov cr4, eax

	mov ecx, 0xc0000080
	rdmsr

	or eax, 1 << 8
	wrmsr

	d_PRINT transition_message, transition_message.end

	mov eax, cr0
	or eax, 1 << 31
	or eax, 1 << 0
	mov cr0, eax

	lgdt [GDT.pointer]
	jmp GDT.code:load_kernal

%include "src/boot/bootloader/longmode.asm"
%include "src/boot/bootloader/GDT.asm"

bits 64
load_kernal:
	mov rsp, STACK_TOP
	mov rbp, STACK_TOP

	mov rsi, KERNAL_READ_LOCATION
	mov rdi, KERNAL_ENTRY_POINT

	xor rcx, rcx

	.loop:
		mov rdx, [rsi]
		mov [rdi], rdx
		add rdi, 8
		add rsi, 8
		inc rcx

		cmp rcx, NUM_OF_KERNAL_ENTRY_SECTORS * 64
		jb .loop

	jmp KERNAL_ENTRY_POINT
	hlt

times (512 * (1 + NUM_OF_FINAL_BOOT_SECTORS) - ($ - $$)) db 0x00

BOOT_ASM_end:
%endif
