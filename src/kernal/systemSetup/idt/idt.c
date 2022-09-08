#include "idt.h"
#include <stdint.h>

extern void loadIDT();

typedef struct {
	uint16_t offset_low;        // offset bits 0..15
	uint16_t selector;        // a code segment selector in GDT or LDT
	uint8_t  ist;             // bits 0..2 holds Interrupt Stack Table offset, rest of bits zero.
	uint8_t  type_attributes; // gate type, dpl, and p fields
	uint16_t offset_mid;        // offset bits 16..31
	uint32_t offset_high;        // offset bits 32..63
	uint32_t zero;
}__attribute__((__packed__)) GATE;

static volatile GATE* idt = (volatile GATE*) 0x0;

void IDT_clearTable() {
	for(uint16_t i = 0; i < 0x1000/8; i++)
		((uint64_t*) idt)[i] = 0;
}
void IDT_addGate(IDT_OFFSET offset, uint16_t selector, IDT_DPL dpl, IDT_GATE_TYPE type, uint8_t index) {
	volatile GATE* gate = &idt[index];

	gate->zero = 0x0;

	gate->offset_low = offset.offset_low;
	gate->offset_mid = offset.offset_mid;
	gate->offset_high = offset.offset_high;

	gate->selector = selector;

	gate->ist = 0x0;

	gate->type_attributes = 0x80 ^ dpl ^ type;
}

void IDT_generateTable() {
	static struct idt{
		uint16_t size;
		void* offset;
	} *idtPtr = (struct idt*)0x10000;

	idtPtr->offset = (void*)idt;
	idtPtr->size = sizeof(GATE) * 256 - 1;

	loadIDT();
}
