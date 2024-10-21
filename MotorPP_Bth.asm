ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000111'   ; Configura los pines RB0, RB1 y RB2 como entradas (botones y Bluetooth)
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

Inicio:
    BTFSC PORTB, 0      ; Si el botón 1 está presionado
    CALL AvanzarMotor
    BTFSC PORTB, 1      ; Si el botón 2 está presionado
    CALL RetrocederMotor
    BTFSC PORTB, 2      ; Si se recibe comando Bluetooth
    CALL CambiarSentido
    CALL VerificarPosicion ; Actualiza el registro de posición
    GOTO Inicio

AvanzarMotor:
    MOVLW D'10'         ; Define cuántos pasos dar
    CALL MoverMotor
    INCF POSICION, F    ; Incrementa la posición del motor
    RETURN

RetrocederMotor:
    MOVLW D'10'
    CALL MoverMotorInverso
    DECF POSICION, F    ; Decrementa la posición del motor
    RETURN

CambiarSentido:
    RETURN

MoverMotor:
    RETURN

MoverMotorInverso:
    RETURN

VerificarPosicion:
    ; Código para actualizar la posición del motor en un registro
    RETURN
