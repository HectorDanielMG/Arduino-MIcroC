 ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000111'   ; Configura los pines RB0, RB1 y RB2 como entradas para los botones
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

Inicio:
    BTFSC PORTB, 0      ; Si el botón 1 está presionado
    CALL AvanzarMotor
    BTFSC PORTB, 1      ; Si el botón 2 está presionado
    CALL RetrocederMotor
    BTFSC PORTB, 2      ; Si se recibe comando Bluetooth
    CALL CambiarSentido
    GOTO Inicio

AvanzarMotor:
    ; Código para avanzar el motor paso a paso
    RETURN

RetrocederMotor:
    ; Código para retroceder el motor paso a paso
    RETURN

CambiarSentido:
    ; Código para cambiar el sentido del motor desde Bluetooth
    RETURN

