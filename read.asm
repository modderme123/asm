        section .text
        global start

start:
        mov r10, 10
        mov r11, 0
loopy:
        mov rax, 0x2000004
        mov rdi, 1
        mov rsi, prompt
        mov rdx, prompt.len
        syscall

        mov rax, 0x2000003
        mov rdi, 0
        mov rsi, name
        mov rdx, 0xff
        syscall

        mov rdx, rax

        dec rdx
        test rdx, rdx
        jz error

        ;mov rax, r11
        ;mov rbx, output
        ;call print
        ;mov byte [rbx], 0xa
        ;mov rax, output
        ;sub rbx, rax
        ;inc rbx
        ;mov rax, 0x2000004
        ;mov rdi, 1
        ;mov rsi, output
        ;mov rdx, rbx
        ;syscall

        mov r8, name
        mov r9, [r8]
        mov rax, 0
        mov r11, 0
next_char:
        cmp r9b, 32
        jne test_plus

        inc r11
        push rax
        xor rax, rax

        jmp skippy
test_plus:
        cmp r9b, 43
        jne test_minus

        cmp r11, 2
        jl error

        sub r11, 2
        pop rax
        pop r13
        add rax, r13

        jmp skippy
test_minus:
        cmp r9b, 45
        jne test_mul

        test rax, rax
        jnz test_negate

        cmp r11, 2
        jl error

        sub r11, 2
        pop r13
        pop rax
        sub rax, r13

        jmp skippy
test_negate:
        neg rax
        jmp skippy
test_mul:
        cmp r9b, 42
        jne test_div

        cmp r11, 2
        jl error

        sub r11, 2
        pop rax
        pop r13
        push rdx
        mul r13
        pop rdx

        jmp skippy
test_div:
        cmp r9b, 47
        jne test_q

        cmp r11, 2
        jl error

        sub r11, 2
        pop r13
        pop rax

        push rdx
        mov rdx, 0
        div r13
        pop rdx

        jmp skippy
test_q:
        cmp r9b, 113
        jne test_number

        test r11, r11
        jnz error

        test rax, rax
        jnz error

        mov rax, 0x2000001
        mov rdi, 0
        syscall

test_number:
        push rdx
        sub r9, '0'

        cmp r9b, 9
        jg error
        cmp r9b, 0
        jl error

        mul r10
        add al, r9b
        pop rdx
skippy:
        inc r8
        dec rdx
        mov r9, [r8]
        test rdx, rdx
        jnz next_char

        test r11, r11
        jz printy

        test rax, rax
        jnz error

        dec r11
        test r11, r11
        jnz error

        pop rax
printy:
        mov rbx, output
        call print

        mov byte [rbx], 0xa
        mov rax, output
        sub rbx, rax
        inc rbx
        mov rax, 0x2000004
        mov rdi, 1
        mov rsi, output
        mov rdx, rbx
        syscall

        jmp loopy

error:
        mov rax, 0x2000004             ; macos print syscall
        mov rdi, 1                     ; stdout
        mov rsi, erro                  ; print string erro
        mov rdx, erro.len              ; with length erro.len
        syscall                        ; call os

        jmp loopy                      ; continue on as if nothing happened
panic:
        mov rax, 0x2000004             ; macos print syscall
        mov rdi, 1                     ; stdout
        mov rsi, erro                  ; print string erro
        mov rdx, erro.len              ; with length erro.len
        syscall                        ; call os

        mov rax, 0x2000001
        mov rdi, 0
        syscall

print:
        xor rdx, rdx                   ; rdx = 0
        xor rcx, rcx                   ; rcx = 0
        test rax, rax
        jns len
        mov byte [rbx], '-'
        inc rbx
        neg rax
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

        ret

        section .data
prompt:
        db "> "
        .len equ $ - prompt
erro:
        db 33o, "[31mError:", 33o, "[39m bad input", 0xa
        .len equ $ - erro

        section .bss
        name resb 0xff                 ; some length
        output resb 64
