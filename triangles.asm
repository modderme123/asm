
        global start
start:
        mov rdx, output                ; rdx holds address of next byte to write
        mov r8, 1                      ; initial line length
        mov r9, 0                      ; number of stars written on line so far
        mov r10, -1
white:
        mov byte [rdx], ' '
        inc rdx
        inc r10
        cmp r10, 4
        jne white
line:
        mov rax, '1'
        add rax, r9
        mov [rdx], rax                 ; write number
        inc rdx                        ; advance pointer to next cell to write
        inc r9                         ; "count" number so far on line

        cmp r9, r8                     ; did we reach the number of stars for this line?
        jne line                       ; not yet, keep writing on this line

        mov byte [rdx], 0xa            ; write a new line char
        inc rdx                        ; and move pointer to where next char goes
        add r8, 2                      ; next line will be one char longer
        mov r10, r9
        shr r10, 1
        mov r9, 0                      ; reset count of stars written on this line
        cmp r8, maxlines               ; wait, did we already finish the last line?
        jng white                      ; if not, begin writing this line

        mov rax, 0x02000004            ; system call for write
        mov rdi, 1                     ; file handle 1 is stdout
        mov rsi, output                ; address of string to output
        mov rdx, dataSize              ; number of bytes
        syscall                        ; invoke os to write

        mov rax, 0x02000001            ; system call for exit
        mov rdi, 0                     ; exit code 0
        syscall                        ; invoke operating system to exit

        section .bss
        maxlines equ 10
        dataSize equ 44
output:
        resb dataSize
