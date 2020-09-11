        global start
start:
        pop rdx
        mov rbx, output                ; rbx holds address of next byte to write

        pop r8                         ; first param is binary file
        dec rdx                        ; remove it from the count

        test rdx, rdx                  ; if rdx is 0 jump to the end
        jz end                         ; that way we don't read empty memory

        mov r10, 10                    ; r10 holds the constant 10 for mul and div
next_param:
        dec rdx
        pop r8
        mov r9, [r8]
next_char:
        push rdx
        sub r9, '0'
        mul r10
        add al, r9b
        pop rdx

        inc r8
        mov r9, [r8]
        test r9b, r9b
        jnz next_char

        add r11, rax
        call print
        mov byte [rbx], '+'
        inc rbx

        test rdx, rdx
        jnz next_param

        mov byte [rbx-1], '='          ; overwrite the final plus

        mov rax, r11
        call print
        mov byte [rbx], 0xa            ; write a new line char at the end out output

        mov rax, 0x02000004            ; system call for write
        mov rdi, 1                     ; file handle 1 is stdout
        mov rsi, output                ; address of string to output
        mov rdx, 64
        syscall                        ; invoke os to write
end:
        mov rax, 0x02000001            ; system call for exit
        xor rdi, rdi                   ; exit code 0
        syscall                        ; invoke operating system to exit

print:
        push rdx

        xor rdx, rdx
len:
        inc rcx                        ; count length of number in binary
        div r10
        push rdx
        xor rdx, rdx
        test rax, rax                  ; check if r9 is 0
        jnz len                        ; if not 0, repeat
next:
        pop rdx                        ; grab the leftmost digit from stack
        add rdx, '0'                   ; '0' + 1 = '1'
        mov [rbx], rdx                 ; set output[rbx] to 0-9

        inc rbx                        ; move to next digit in output

        dec rcx                        ; digits_left--
        test rcx, rcx                  ; is digits left to go 0
        jnz next                       ; else jump to next

        pop rdx
        ret

        section .bss
output:
        resb 64
