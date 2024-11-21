[org 0x2000]   ; Kernel loads at 0x1000

start:
    ; Initialize segments
    mov ax, 0x2000  ; Kernel segment
    mov ds, ax      ; Data segment
    mov es, ax      ; Extra segment
    mov ss, ax      ; Stack segment
    mov sp, 0xFFFF  ; Stack pointer

    ; Print startup message
    mov si, message

.print:
    lodsb           ; Load byte from [SI] to AL
    or al, al       ; Check for null terminator
    jz halt         ; Halt if null
    mov ah, 0x0E    ; BIOS teletype function
    int 0x10        ; Print character
    jmp .print      ; Repeat

halt:
    cli             ; Disable interrupts
.loop:
    hlt             ; Halt CPU
    jmp .loop       ; Infinite loop

message db 'Kernel Loaded and Running!', 0
