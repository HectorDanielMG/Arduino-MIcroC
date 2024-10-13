 section .data
    numbers db 5, 10, 15, 20, 25  ; Arreglo con 5 números
    len db 5                      ; Longitud del arreglo
    sum dw 0                      ; Para almacenar la suma

section .text
    global _start

_start:
    ; Inicializar el registro para la suma
    xor ax, ax        ; AX = 0 (acumulador para la suma)
    mov ecx, [len]    ; Cargar la longitud del arreglo en ECX
    mov esi, 0        ; Índice del arreglo

sum_loop:
    add al, [numbers + esi] ; Sumar el valor actual del arreglo
    inc esi                 ; Incrementar el índice
    loop sum_loop           ; Repetir hasta que ECX llegue a 0

    ; Guardar la suma
    mov [sum], ax

    ; Salida del programa
    mov eax, 60      ; Llamada al sistema para salir
    xor edi, edi     ; Código de salida 0
    syscall

