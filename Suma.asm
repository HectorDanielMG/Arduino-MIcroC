 section .data
    prompt1 db "Ingrese el primer numero: ", 0
    prompt2 db "Ingrese el segundo numero: ", 0
    result_msg db "El resultado es: ", 0
    newline db 10, 0

section .bss
    num1 resb 4  ; Espacio para el primer número
    num2 resb 4  ; Espacio para el segundo número
    result resb 4 ; Espacio para el resultado

section .text
    global _start

_start:
    ; Solicitar primer número
    mov eax, 4            ; syscall para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, prompt1      ; mensaje de solicitud
    mov edx, 23           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Leer primer número
    mov eax, 3            ; syscall para leer
    mov ebx, 0            ; descriptor de archivo (stdin)
    mov ecx, num1         ; buffer donde almacenar el número
    mov edx, 4            ; longitud del número
    int 0x80              ; llamada al sistema

    ; Solicitar segundo número
    mov eax, 4            ; syscall para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, prompt2      ; mensaje de solicitud
    mov edx, 23           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Leer segundo número
    mov eax, 3            ; syscall para leer
    mov ebx, 0            ; descriptor de archivo (stdin)
    mov ecx, num2         ; buffer donde almacenar el número
    mov edx, 4            ; longitud del número
    int 0x80              ; llamada al sistema

    ; Convertir ambos números de ASCII a enteros
    mov eax, [num1]
    sub eax, '0'
    mov ebx, [num2]
    sub ebx, '0'

    ; Sumar los números
    add eax, ebx

    ; Convertir el resultado de entero a ASCII
    add eax, '0'

    ; Almacenar el resultado en el buffer
    mov [result], eax

    ; Mostrar el mensaje de resultado
    mov eax, 4            ; syscall para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, result_msg   ; mensaje "El resultado es: "
    mov edx, 17           ; longitud del mensaje
    int 0x80              ; llamada al sistema

    ; Mostrar el resultado
    mov eax, 4            ; syscall para escribir
    mov ebx, 1            ; descriptor de archivo (stdout)
    mov ecx, result       ; buffer del resultado
    mov edx, 1            ; longitud del resultado
    int 0x80              ; llamada al sistema

    ; Nueva línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Terminar el programa
    mov eax, 1            ; syscall para salir
    xor ebx, ebx          ; código de salida 0
    int 0x80              ; llamada al sistema

