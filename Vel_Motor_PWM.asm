ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000011'   ; Configura RB0 (motor) y RB1 (botón velocidad) como salida y entrada
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0
    CALL InicializarLCD ; Inicia el LCD

InicioPWM:
    CALL AjustarVelocidad ; Ajusta la velocidad del motor
    CALL MostrarVelocidad ; Muestra la velocidad en el LCD
    MOVF CCPR1L, W      ; Carga el ciclo de trabajo ajustado en el registro PWM
    BSF T2CON, 2        ; Habilita el temporizador para generar PWM
    GOTO InicioPWM      ; Bucle continuo

AjustarVelocidad:
    MOVF PORTB, W       ; Lee el valor del puerto para ajuste de velocidad
    BTFSC W, 1          ; Si se presiona el botón de aumentar velocidad
    INCF CCPR1L, F      ; Incrementa el ciclo de trabajo (más rápido)
    BTFSS W, 1          ; Si se presiona el botón de disminuir velocidad
    DECF CCPR1L, F      ; Disminuye el ciclo de trabajo (más lento)
    RETURN

MostrarVelocidad:
    MOVF CCPR1L, W      ; Obtiene el valor actual del ciclo de trabajo
    CALL EnviarLCD      ; Envía el valor a la pantalla LCD
    RETURN
