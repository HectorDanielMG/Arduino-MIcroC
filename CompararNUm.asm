 
section .data
    num1 db 45   ; Primer número
    num2 db 30   ; Segundo número
    result db 0  ; Para almacenar el número más grande

section .text
    global _start

_start:
    ; Cargar los números en registros
    mov al, [num1]   ; Cargar num1 en AL
    mov bl, [num2]   ; Cargar num2 en BL

    ; Comparar los valores
    cmp al, bl       ; Comparar AL y BL

    ; Si AL es mayor o igual, almacenar AL en resultado
    jae store_al
    ; Si no, almacenar BL en resultado
    mov [result], bl
    jmp end

store_al:
    mov [result], al ; Guardar AL en resultado

end:
    ; Salida del programa
    mov eax, 60      ; Llamada al sistema para salir
    xor edi, edi     ; Código de salida 0
    syscall
