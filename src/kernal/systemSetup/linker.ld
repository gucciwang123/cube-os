OUTPUT_FORMAT(binary)
ENTRY(_start)

SECTIONS
{
	. = 0x100000;
	.text : {
		*(.entry)
		*(.text)
	}
	.data :{ *(.data) }
}
