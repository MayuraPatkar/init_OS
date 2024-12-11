SRC_DIR = ./src
BIN_DIR = ./bin

BOOT = $(SRC_DIR)/boot.asm
KERNEL = $(SRC_DIR)/kernel.cpp
LINKER = $(SRC_DIR)/linker.ld

BOOT_BIN = $(BIN_DIR)/boot.bin
KERNEL_ELF = $(BIN_DIR)/kernel.elf
KERNEL_BIN = $(BIN_DIR)/kernel.bin
DISK_IMG = $(BIN_DIR)/disk.img

ASM = nasm
ASM_FLAGS = -f bin

CXX = x86_64-linux-gnu-g++
CXX_FLAGS = -m32 -ffreestanding -fno-exceptions -fno-rtti -O2
LD_FLAGS = -nodefaultlibs -nostdlib -lgcc

EMU = qemu-system-x86_64

all: $(DISK_IMG)

$(BIN_DIR):
	mkdir -p $(BIN_DIR)

$(BOOT_BIN): $(BOOT) $(BIN_DIR)
	$(ASM) $(ASM_FLAGS) -o $@ $<

$(KERNEL_ELF): $(KERNEL) $(LINKER) $(BIN_DIR)
	$(CXX) $(CXX_FLAGS) -T $(LINKER) -o $@ $< $(LD_FLAGS)

$(KERNEL_BIN): $(KERNEL_ELF)
	objcopy -O binary $< $@

$(DISK_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $@

run: $(DISK_IMG)
	$(EMU) -drive format=raw,file=$(DISK_IMG)

clean:
	rm -rf $(BIN_DIR)/*.bin $(BIN_DIR)/*.img $(BIN_DIR)/*.elf
	@rmdir $(BIN_DIR) 2>/dev/null || true

.PHONY: all run clean
