#include <iostream>
#include <cstring>

const char* msg = "Kernel Loaded!";
const int msg_len = std::strlen(msg);

void write_to_video_memory() {
    // Simulate writing to video memory (for example, in a console with attributes)
    unsigned char* video_memory = reinterpret_cast<unsigned char*>(0xB8000); // Video memory start

    // Write the message character by character
    for (int i = 0; i < msg_len; ++i) {
        video_memory[2 * i] = msg[i];      // Character
        video_memory[2 * i + 1] = 0x07;    // White on black attribute
    }
}

int main() {
    // Set up video memory with a message
    write_to_video_memory();

    // Loop forever to simulate the 'halt' and avoid exiting the program
    while (true) {
        // This can be replaced with any logic to simulate the halted state
    }

    return 0;
}
