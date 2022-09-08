#pragma once

#include <stdint.h>

void IDT_clearTable();

#define IDT_INTERUPT_GATE 0xE
#define IDT_TRAP_GATE 0xF
typedef uint8_t IDT_GATE_TYPE;

#define IDT_DPL_0 0x00
#define IDT_DPL_1 0x20
#define IDT_DPL_2 0x40
#define IDT_DPL_3 0x60
typedef uint8_t IDT_DPL;

typedef union {
	uint64_t offset;
	struct {
		uint16_t offset_low;
		uint16_t offset_mid;
		uint32_t offset_high;
	};
}IDT_OFFSET;

void IDT_addGate(IDT_OFFSET offset, uint16_t selector, IDT_DPL dpl, IDT_GATE_TYPE type, uint8_t index);

void IDT_generateTable();
