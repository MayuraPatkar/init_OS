SECTIONS {
    /* Place the bootloader at 0x7C00 (BIOS loads it here by default) */
    .bootloader 0x7C00 : {
        *(.bootloader)
    }

    /* Place the kernel at 0x10000 */
    .kernel 0x10000 : {
        *(.kernel)
    }
}
