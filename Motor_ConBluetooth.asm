ORG 0x00        ; Comienza el programa en la dirección 0
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000111'   ; Configura RB0 (motor), RB1 (LED verde), RB2 (LED rojo) como salida
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

Iniciar:
    CALL BluetoothCheck ; Revisa si hay comandos por Bluetooth
    MOVF PORTB, W       ; Obtiene el estado de PORTB
    BTFSC W, 0          ; Verifica si se ha recibido un comando de encendido
    CALL EncenderMotor
    BTFSS W, 0          ; Verifica si se ha recibido un comando de apagado
    CALL ApagarMotor
    CALL EsperaComando   ; Evita que se procesen múltiples comandos seguidos
    GOTO Iniciar        ; Ciclo infinito

EncenderMotor:
    BSF PORTB, 0        ; Enciende el motor
    BSF PORTB, 1        ; Enciende el LED verde (motor encendido)
    BCF PORTB, 2        ; Apaga el LED rojo
    CALL Temporizador    ; Inicia temporizador de autoapagado
    RETURN

ApagarMotor:
    BCF PORTB, 0        ; Apaga el motor
    BCF PORTB, 1        ; Apaga el LED verde
    BSF PORTB, 2        ; Enciende el LED rojo (motor apagado)
    RETURN

Temporizador:
    MOVLW D'200'        ; Ajusta un temporizador para autoapagado
TemporizadorLoop:
    DECFSZ WREG, F
    GOTO TemporizadorLoop
    CALL ApagarMotor     ; Apaga el motor después del tiempo
    RETURN

EsperaComando:
    MOVLW D'50'         ; Tiempo de espera para evitar errores
    CALL Delay
    RETURN

Delay:
    NOP                 ; Retardo básico
    RETURN
