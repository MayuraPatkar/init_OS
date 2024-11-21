[BITS 16]
[ORG 0x7C00]   ; Set origin for bootloader

start:
    ; Set up stack
    xor ax, ax           ; Clear AX register
    mov ss, ax           ; Set stack segment to zero (default)
    mov sp, 0x7C00       ; Set stack pointer to 0x7C00

    ; Load kernel (sectors starting at 0x1000:0)
    mov bx, 0x1000       ; Kernel load address (0x1000)
    mov dh, 1            ; Number of sectors to load (1 sector for the kernel)
    call load_kernel     ; Load the kernel

    ; Jump to kernel
    jmp 0x1000:0         ; Jump to kernel code at 0x1000

load_kernel:
    mov ah, 0x02         ; BIOS read function
    mov al, dh           ; Number of sectors to load (1)
    mov ch, 0            ; Cylinder
    mov cl, 2            ; Sector (start after bootloader sector)
    mov dh, 0            ; Head
    int 0x13             ; Call BIOS to read from disk
    jc disk_error        ; Jump if error
    ret                  ; Return from load_kernel

disk_error:
    hlt                  ; Halt if disk read fails

times 510-($-$$) db 0    ; Pad to 512 bytes
dw 0xAA55                ; Boot signature (required for bootable sector)
