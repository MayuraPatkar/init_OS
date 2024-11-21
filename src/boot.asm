SECTION .bootloader

[BITS 16]
[ORG 0x7C00]   ; Set origin for bootloader

start:

    ; Print a clear screen
    mov ax, 0x03
    int 0x10
    
    ; Debug: Bootloader started
    mov si, boot_msg
    call print_string

    ; Set up stack
    xor ax, ax           ; Clear AX register
    mov ss, ax           ; Set stack segment to zero (default)
    mov sp, 0x7C00       ; Set stack pointer to 0x7C00

    ; Debug: Stack initialized
    mov si, stack_msg
    call print_string

    ; Load kernel (sectors starting at 0x1000:0)
    mov bx, 0x1000       ; Kernel load address (0x1000)
    mov dh, 1            ; Number of sectors to load (1 sector for the kernel)

    ; Debug: Loading kernel
    mov si, load_msg
    call print_string

    call load_kernel     ; Load the kernel

    ; Jump to kernel
    jmp 0x1000:0x0000        ; Jump to kernel code at 0x1000

; BIOS Disk Read Subroutine
load_kernel:
    mov ah, 0x02         ; BIOS read function
    mov al, dh           ; Number of sectors to loada
    mov ch, 0            ; Cylinder
    mov cl, 2            ; Sector (start after bootloader sector)
    mov dh, 0            ; Head
    int 0x13             ; Call BIOS to read from disk
    jc disk_error        ; Jump if error
    ret                  ; Return from load_kernel

; Disk Read Error Handler
disk_error:
    mov si, error_msg
    call print_string

    ; Display error code
    mov ah, 0x0E         ; BIOS teletype function
    int 0x10             ; Print character in AL
    
    cli                  ; Disable interrupts
    hlt                  ; Halt if disk read fails

; Debug Printing Subroutines
print_char:
    mov ah, 0x0E         ; BIOS teletype function
    int 0x10             ; Print character in AL
    ret

print_newline:
    ; Print a newline (CR+LF)
    mov al, 0x0D         ; Carriage return
    call print_char
    mov al, 0x0A         ; Line feed
    call print_char
    ret

print_string:
    mov ah, 0x0E         ; BIOS teletype function
.next_char:
    lodsb                ; Load next character from DS:SI into AL
    or al, al            ; Check for null terminator
    jz .done             ; Stop if null terminator found
    int 0x10             ; Print character
    jmp .next_char
.done:
    call print_newline   ; Add a newline after the string
    ret

; Debug Messages
boot_msg db "Bootloader Started", 0
stack_msg db "Stack Initialized", 0
load_msg db "Loading Kernel...", 0
error_msg db "Disk Error", 0

; Padding and Boot Signature
times 510-($-$$) db 0    ; Pad to 512 bytes
dw 0xAA55                ; Boot signature (required for bootable sector)
