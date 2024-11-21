# Directories
SRC_DIR = ./src
BIN_DIR = ./bin

# Files
BOOT = $(SRC_DIR)/boot.asm
KERNEL = $(SRC_DIR)/kernel.asm
BOOT_BIN = $(BIN_DIR)/boot.bin
KERNEL_BIN = $(BIN_DIR)/kernel.bin
DISK_IMG = $(BIN_DIR)/disk.img

# Tools
ASM = nasm
ASM_FLAGS = -f bin
CXX = x86_64-linux-gnu-g++
EMU = qemu-system-x86_64

# Targets
all: $(DISK_IMG)

# Ensure bin directory exists
$(BIN_DIR):
	mkdir -p $(BIN_DIR)

# Assemble bootloader
$(BOOT_BIN): $(BOOT) $(BIN_DIR)
	$(ASM) $(ASM_FLAGS) -o $@ $<

# Assemble bootloader
$(KERNEL_BIN): $(KERNEL)
	$(ASM) $(ASM_FLAGS) -o $@ $<

# Compile kernel cpp
# $(KERNEL_BIN): $(KERNEL) $(BIN_DIR)
# 	$(CXX) $< -o $@

# Combine bootloader and kernel into disk image
$(DISK_IMG): $(BOOT_BIN) $(KERNEL_BIN)
	cat $(BOOT_BIN) $(KERNEL_BIN) > $@

# Run OS in QEMU
run: $(DISK_IMG)
	$(EMU) -drive format=raw,file=$(DISK_IMG)

# Clean build files
clean:
	rm -rf $(BIN_DIR)/*.bin $(BIN_DIR)/*.img
	@rmdir $(BIN_DIR) 2>/dev/null || true

# Phony targets
.PHONY: all run clean
