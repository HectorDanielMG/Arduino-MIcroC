 ORG 0x00        ; Comienza el programa en la dirección 0
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000001'   ; Configura el pin RB0 como salida para el motor
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

Iniciar:
    CALL BluetoothCheck ; Revisa si hay comandos por Bluetooth
    MOVF PORTB, W       ; Obtiene el estado de PORTB
    BTFSC W, 0          ; Verifica si se ha recibido un comando de encendido
    CALL EncenderMotor
    BTFSS W, 0          ; Verifica si se ha recibido un comando de apagado
    CALL ApagarMotor
    GOTO Iniciar        ; Ciclo infinito

EncenderMotor:
    BSF PORTB, 0        ; Enciende el motor
    RETURN

ApagarMotor:
    BCF PORTB, 0        ; Apaga el motor
    RETURN

BluetoothCheck:
    ; Aquí iría el código para leer el módulo Bluetooth
    RETURN

