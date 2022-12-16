global open_file
global read_and_print

extern fopen
extern fgetc
extern printf
extern exit

section .data
inputFilename:
    db "test_input.txt", 0
openMode:
    db "r", 0
openErrorMsg:
    db "Error opening file", 10, 0

helloWorld:
    db "Hello, World %p!", 10, 0

section .text
; main:
;     call open_file

open_file:
    mov rdi, inputFilename
    mov rsi, openMode
    call fopen wrt ..plt
    ret

read_and_print:
    push rbp
    mov rbp, rsp
    ; mov [rbp-0x8], rdi
    mov rdi, qword 0
_loop_start:
    mov rdi, [rbp-0x8]
    mov rax, [rbp-0x8]
    call fgetc wrt ..plt
    mov [rbp-0x9], rax
    mov rsi, [rbp-0x9]
    mov rdi, helloWorld
    call printf wrt ..plt
    cmp byte [rbp-0x9], byte 0xff
    jne _loop_start

    ; cmp rax, 0x63
    ; je _loop_end
    ; mov rsi, rax
    ; mov rdi, helloWorld
    ; call printf wrt ..plt
    ; nop
    ; nop
    ; jmp _loop_start
_loop_end:
    pop rbp
    ret

; _exit:
;     mov rdi, 1
;     call exit wrt ..plt
;     ret
