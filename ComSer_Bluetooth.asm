ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000010'   ; Configura el pin RB1 como TX para Bluetooth
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0

Iniciar:
    CALL RecibirDatoBluetooth
    MOVWF PORTB         ; Muestra los datos recibidos en el LCD
    CALL EnviarDatoBluetooth ; Envía respuesta
    GOTO Iniciar

RecibirDatoBluetooth:
    ; Aquí iría el código para recibir datos desde el módulo Bluetooth
    RETURN

EnviarDatoBluetooth:
    ; Aquí iría el código para enviar datos al Bluetooth
    RETURN
 
