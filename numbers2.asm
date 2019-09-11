        global start
start:
        mov rdx, 24
        push 0xa                       ; write a new line char at the end out output

        mov r10, 0b11111111
        mov r11, 272

        mov r12, r10
        add r12, r11

        mov r8, r12
        call print

        push '='

        mov r8, r11
        call print

        push '+'

        mov r8, r10
        call print

        mov rax, 0x02000004            ; system call for write
        mov rdi, 1                     ; file handle 1 is stdout
        mov rsi, rsp                   ; address of string to output
        syscall                        ; invoke os to write

        mov rax, 0x02000001            ; system call for exit
        mov rdi, 0                     ; exit code 0
        syscall                        ; invoke operating system to exit
print:
        mov rbx, r8                    ; copy of r8
        and rbx, 1                     ; isolate right most digit

        add rbx, '0'                   ; rdx = '0' | '1'

        pop rax                        ; pop return adress to spare register
        push rbx                       ; add next digit to top of stack
        push rax                       ; keep return adress on the top of the stack
        add rdx, 8

        shr r8, 1                      ; drop the rightmost digit

        test r8, r8                    ; is number 0
        jnz print                      ; else print next digit

        ret
