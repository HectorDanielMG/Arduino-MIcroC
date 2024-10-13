 
section .data
    num1 db 6  ; Primer número
    num2 db 7  ; Segundo número
    result dw 0  ; Para almacenar el resultado (2 bytes)

section .text
    global _start

_start:
    ; Cargar los números en registros
    mov al, [num1]  ; Cargar num1 en AL
    mov bl, [num2]  ; Cargar num2 en BL

    ; Multiplicar los valores
    mul bl          ; AL = AL * BL

    ; Guardar el resultado
    mov [result], ax ; Guardar el resultado en memoria

    ; Salida del programa
    mov eax, 60     ; Llamada al sistema para salir
    xor edi, edi    
    syscall
