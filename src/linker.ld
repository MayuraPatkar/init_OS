ENTRY(kernel_main) /* Entry point of the kernel */

PHDRS {
    text PT_LOAD FLAGS(0x5); /* Executable and readable */
    data PT_LOAD FLAGS(0x6); /* Writable and readable */
}

SECTIONS {
    /* Code and read-only data */
    .text 0x10000 :text AT(0x10000) {
        *(.text)
        *(.rodata)
    }

    /* Writable data and BSS (uninitialized data) */
    .data :data AT(ADDR(.text) + SIZEOF(.text)) {
        *(.data)
        *(.bss COMMON)
    }
}
