ORG 0x00
    BSF STATUS, RP0     ; Cambia a banco 1
    MOVLW B'00000010'   ; Configura RB1 como TX y RX para Bluetooth
    TRISB
    BCF STATUS, RP0     ; Cambia a banco 0
    CALL InicializarLCD ; Inicia el LCD
    CALL MostrarEstadoConexion ; Muestra "Desconectado" al inicio

Iniciar:
    CALL RecibirDatoBluetooth
    CALL ValidarDatos   ; Verifica si los datos son válidos antes de mostrar
    MOVWF PORTB         ; Muestra los datos válidos recibidos en el LCD
    CALL MostrarEstadoConexion ; Actualiza el estado de conexión
    CALL EnviarDatoBluetooth ; Envía respuesta de confirmación
    GOTO Iniciar

RecibirDatoBluetooth:
    MOVF RCREG, W       ; Recibe el dato de Bluetooth
    MOVWF BUFFER        ; Guarda el dato en el buffer
    CALL VerificarError ; Verifica si hubo errores en la recepción
    RETURN

ValidarDatos:
    MOVF BUFFER, W
    XORLW 'C'           ; Compara si es el dato esperado (ejemplo 'C')
    RETURN

VerificarError:
    BTFSC PIR1, 0       ; Verifica el bit de error
    CALL ReintentarRecepcion ; Si hay error, intenta recibir de nuevo
    RETURN

ReintentarRecepcion:
    CALL RecibirDatoBluetooth
    RETURN

MostrarEstadoConexion:
    MOVF PORTB, W
    BTFSC W, 0          ; Si hay dato en el puerto
    CALL LCDConectado   ; Muestra "Conectado"
    BTFSS W, 0
    CALL LCDDesconectado ; Muestra "Desconectado"
    RETURN
