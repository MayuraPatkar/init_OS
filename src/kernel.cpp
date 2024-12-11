// Declare the entry point of the kernel
extern "C" void kernel_main() {
    // VGA text mode buffer starts at 0xB8000
    char* vga_buffer = (char*)0xB8000;

    // Message to display
    const char* message = "Hello, kernel!";

    // VGA uses 2 bytes per character: 1 for the character, 1 for the attribute (color)
    const char attribute_byte = 0x0F; // White text on black background
    int index = 0;

    // Clear screen
    for (int i = 0; i < 80 * 25 * 2; i += 2) {
        vga_buffer[i] = ' ';        // Empty space
        vga_buffer[i + 1] = 0x07;   // Gray text on black background
    }

    // Write the message to the top-left corner of the screen
    while (message[index] != '\0') {
        vga_buffer[index * 2] = message[index];     // Character byte
        vga_buffer[index * 2 + 1] = attribute_byte; // Attribute byte
        index++;
    }

    // Hang the CPU (halt execution)
    while (true) {
        __asm__("hlt"); // Assembly instruction to halt the CPU
    }
}
