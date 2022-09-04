.PHONY: all
all: bin/CubeOS.img

bin/CubeOS.img: build/bootsector.bin build/kernal-entry.bin
	@mkdir bin -p
	@echo Concatenating Files
	@cat build/bootsector.bin build/kernal-entry.bin > $@
	@echo Finished Concatenating Files


bootsector_src := $(shell find "src/boot/bootloader/" -not -path "*/.*" -name "*.asm")
bootsector = ""

build/bootsector.bin: $(bootsector_src)
	@echo Building boot sector
	@mkdir build/ -p
	@nasm -fbin src/boot/bootloader/boot.asm -o $@
	@echo Finished building boot sector
	@echo
	@echo ======================Finished Bootsector======================
	@echo

kernal-entry-asm-source := $(shell find "src/kernal/systemSetup" -not -path "*/.*" -name "*.asm")
kernal-entry-c-source := $(shell find "src/kernal/systemSetup" -not -path "*/.*" -name "*.c")
kernal-entry-header := $(shell find "src/kernal/systemSetup" -not -path "*/.*" -name "*.h")

kernal-entry-asm-object := $(patsubst src/%.asm, build/%.o, $(kernal-entry-asm-source))
kernal-entry-c-object := $(patsubst src/%.c, build/%.o, $(kernal-entry-c-source))

$(kernal-entry-asm-object): build/%.o : src/%.asm $(kernal-entry-header)
	@echo Building $@
	@mkdir $(dir $@) -p
	@nasm -felf64 $(patsubst build/%.o, src/%.asm, $@) -o $@
	@echo Built $@
	@echo

$(kernal-entry-c-object): build/%.o : src/%.c $(kernal-entry-header)
	@echo Building $@
	@mkdir $(dir $@) -p
	@cc -nostdlib -nostartfiles -c $(patsubst build/%.o, src/%.c, $@) -o $@
	@echo Built $@
	@echo

build/kernal-entry.bin: $(kernal-entry-c-object) $(kernal-entry-asm-object) src/kernal/systemSetup/linker.ld
	@echo Building $@
	@mkdir build/ -p
	@ld -Tsrc/kernal/systemSetup/linker.ld $(kernal-entry-asm-object) $(kernal-entry-c-object) -o $@
	@echo -n "Original File size: "
	@stat --format="%s" $@
	@truncate -s 4096 $@
	@echo Built $@
	@echo -n "Final File size: "
	@stat --format="%s" $@
	@echo
	@echo ======================Finished Kernal Entry======================
	@echo

.PHONY: clean
clean: 
	@rm -rf bin/*
	@rm -rf build/*
	@echo Finished clean

.PHONY: run
run: bin/CubeOS.img
	@echo Running OS
	@qemu-system-x86_64 -drive file=bin/CubeOS.img,format=raw,index=0,media=disk -m 8192
	@echo OS stopped
