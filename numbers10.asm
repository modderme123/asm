        global start
start:
        mov rbx, output                ; rbx holds address of next byte to write

        mov r10, 8
        mov r11, 12

        mov r8, r10                    ; pass r10 into print
        call print                     ; write the number to output

        mov byte [rbx], '+'
        inc rbx

        mov r8, r11                    ; pass r11 into print
        call print                     ; write the number to output

        mov byte [rbx], '='
        inc rbx

        add r10, r11                   ; r10+=r11
        mov r8, r10                    ; pass r10 into print
        call print                     ; write the number to output

        mov byte [rbx], 0xa            ; write a new line char at the end out output
        mov rax, 0x02000004            ; system call for write
        mov rdi, 1                     ; file handle 1 is stdout
        mov rsi, output                ; address of string to output
        mov rdx, 64                    ; number of bytes
        syscall                        ; invoke os to write

        mov rax, 0x02000001            ; system call for exit
        mov rdi, 0                     ; exit code 0
        syscall                        ; invoke operating system to exit
print:
        mov rdx, 0
        mov rax, r8                     ; copy of r8
len:
        inc rcx                        ; count length of number in binary

        mov r8, 10
        div r8

        push rdx
        mov rdx, 0

        test rax, rax                    ; check if r9 is 0
        jnz len                        ; if not 0, repeat
next:
        dec rcx

        pop rdx
        add rdx, '0'                   ; '0' + 1 = '1'
        mov [rbx], rdx                 ; set output[rbx] = '0' | '1'

        inc rbx                        ; move to next digit in output

        test rcx, rcx                  ; is digits left to go 0
        jnz next                       ; else jump to next

        ret

        section .bss
output:
        resb 64
