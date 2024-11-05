; multiplicarNum.asm - Multiplicación de dos números de 16 bits con soporte para negativos
; Objetivo: Multiplicar dos números de 16 bits y obtener un resultado de 32 bits

.INCLUDE "m328pdef.inc" ; Archivo de configuración para el ATmega328P

; Definición de registros
.DEF multiplicador_low = r16      ; Byte bajo del multiplicador
.DEF multiplicador_high = r17     ; Byte alto del multiplicador
.DEF multiplicando_low = r18      ; Byte bajo del multiplicando
.DEF multiplicando_high = r19     ; Byte alto del multiplicando
.DEF resultado_low = r20          ; Byte bajo del resultado
.DEF resultado_mid_low = r21      ; Byte intermedio bajo del resultado
.DEF resultado_mid_high = r22     ; Byte intermedio alto del resultado
.DEF resultado_high = r23         ; Byte alto del resultado
.DEF temp = r24                   ; Registro temporal para cálculos intermedios

; Definición de constantes
.EQU NEGATIVO = 1                 ; Constante para verificar números negativos

Inicio:
    ; Inicialización de registros de resultado a cero
    clr resultado_low
    clr resultado_mid_low
    clr resultado_mid_high
    clr resultado_high

    ; Carga valores de prueba en multiplicador y multiplicando
    ldi multiplicador_low, 0x0A    ; Byte bajo del multiplicador
    ldi multiplicador_high, 0x00   ; Byte alto del multiplicador
    ldi multiplicando_low, 0x14    ; Byte bajo del multiplicando
    ldi multiplicando_high, 0x00   ; Byte alto del multiplicando

    ; Comprobación de signos (si cualquiera es negativo)
    ldi temp, NEGATIVO             ; Carga valor para verificación
    tst multiplicador_high
    brmi NegativoMultiplicador
    tst multiplicando_high
    brmi NegativoMultiplicando
    rjmp Multiplicacion            ; Si ambos son positivos, procede a la multiplicación

NegativoMultiplicador:
    com multiplicador_low          ; Complemento para obtener valor absoluto
    com multiplicador_high
    subi multiplicador_low, -1
    sbci multiplicador_high, 0
    rjmp Multiplicacion

NegativoMultiplicando:
    com multiplicando_low          ; Complemento para obtener valor absoluto
    com multiplicando_high
    subi multiplicando_low, -1
    sbci multiplicando_high, 0

Multiplicacion:
    ; Multiplicación de bytes bajos
    mul multiplicador_low, multiplicando_low
    mov resultado_low, r0
    mov resultado_mid_low, r1

    ; Multiplicación cruzada de byte bajo y alto
    mul multiplicador_low, multiplicando_high
    add resultado_mid_low, r0
    adc resultado_mid_high, r1
    mul multiplicador_high, multiplicando_low
    add resultado_mid_low, r0
    adc resultado_mid_high, r1

    ; Multiplicación de bytes altos
    mul multiplicador_high, multiplicando_high
    add resultado_mid_high, r0
    adc resultado_high, r1

    ; Comprobación de signo para el resultado final
    cpi temp, NEGATIVO
    brne Fin                        ; Si es positivo, termina
    com resultado_low               ; Si es negativo, invierte el signo del resultado
    com resultado_mid_low
    com resultado_mid_high
    com resultado_high
    subi resultado_low, -1
    sbci resultado_mid_low, 0
    sbci resultado_mid_high, 0
    sbci resultado_high, 0

Fin:
    ; Final del programa, entra en un bucle infinito
    rjmp Fin
