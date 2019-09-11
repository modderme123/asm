; ----------------------------------------------------------------------------------------
; Writes "Hello, World" to the console using only system calls. Runs on 64-bit macOS only.
; To assemble and run:

; nasm -fmacho64 hello.asm && ld hello.o && ./a.out
; ----------------------------------------------------------------------------------------

        global start
start:
        mov rax, 0x02000004            ; system call for write
        mov rdi, 1                     ; file handle 1 is stdout
        mov rsi, message1              ; address of string to output
        mov rdx, message1.len          ; number of bytes
        syscall                        ; invoke os to write

        mov rax, 0x02000001            ; system call for exit
        xor rdi, rdi                   ; exit code 0
        syscall                        ; invoke os to exit

        section .data
message1:
        db 'Hello, Worl1', 10
        .len equ $ - message1
