 ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000001'   ; Configura el pin RB0 como salida PWM
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

InicioPWM:
    ; Configurar el temporizador para PWM
    MOVLW D'255'        ; Valor del ciclo PWM (cambia para ajustar la velocidad)
    MOVWF CCPR1L        ; Establece el ciclo de trabajo
    BSF T2CON, 2        ; Habilita el temporizador
    GOTO InicioPWM      ; Bucle continuo

