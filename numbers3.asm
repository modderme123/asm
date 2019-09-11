        global start
start:
        pop rdx
        mov rbx, output                ; rbx holds address of next byte to write

        pop r8                         ; first param is binary file
        dec rdx                        ; remove it from the count

        test rdx, rdx
        jz end

        mov r11, 0
next_param:
        dec rdx
        pop r8
        mov r9, [r8]
        mov rax, 0
next_char:
        push rdx
        sub r9, '0'
        mov r10, 10
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
        mov rdi, 0                     ; exit code 0
        syscall                        ; invoke operating system to exit

print:
        mov r9, rax                    ; copy of r10
len:
        inc rcx                        ; count length of number in binary
        shr r9, 1                      ; remove rightmost digit
        test r9, r9                    ; check if r9 is 0
        jnz len                        ; if not 0, repeat

        ror rax, cl                    ; align the number to the left side (...000001101 -> 110100000...)
next:
        mov r9, rax                    ; copy r8 to r9
        rol r9, 1                      ; move leftmost digit to the right
        and r9, 1                      ; isolate right most digit

        add r9, '0'                   ; '0' + 1 = '1' | '0' + 0 = '0'
        mov [rbx], r9                 ; set output[rbx] = '0' | '1'

        inc rbx                        ; move to next digit in output
        shl rax, 1                     ; drop the leftmost digit
        dec rcx                        ; decrease digits left to print

        test rcx, rcx                  ; is digits left to go 0
        jnz next                       ; else jump to next

        ret

        section .bss
output:
        resb 200
