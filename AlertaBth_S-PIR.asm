; Programa en ensamblador para un sistema de alerta con sensor PIR y comunicación Bluetooth
; Este ejemplo está pensado para un microcontrolador que tenga un puerto para Bluetooth y un puerto de entrada para el sensor PIR.
; Supongamos que el LED de alerta está conectado a PORTB, bit 0, y el sensor PIR a PORTA, bit 0.
; La comunicación Bluetooth se realiza a través de USART.

    LIST P=16F877A            ; Modelo del microcontrolador
    INCLUDE <P16F877A.INC>

    ORG 0x00                  ; Dirección de inicio del programa
    GOTO INICIO               ; Ir a la etiqueta INICIO al comienzo

; Configuración de constantes y pines
PIR_SENSOR  EQU PORTA, 0      ; Pin donde se conecta el sensor PIR
LED_ALERTA  EQU PORTB, 0      ; Pin donde se conecta el LED de alerta
BT_TX       EQU TXREG         ; Registro de transmisión para Bluetooth
BT_STATUS   EQU PIR_ACTIVO    ; Mensaje para enviar por Bluetooth

; Constantes
PIR_ACTIVO  EQU 0x01          ; Valor para indicar que el sensor PIR ha detectado movimiento
PIR_INACTIVO EQU 0x00         ; Valor para indicar que no hay detección

; Inicio del programa
INICIO:
    ; Configuración de puertos
    BSF STATUS, RP0           ; Cambiar a banco 1
    MOVLW 0x01
    MOVWF TRISA               ; Configurar RA0 (PIR_SENSOR) como entrada
    CLRF TRISB                ; Configurar PORTB como salida (LED_ALERTA)
    BCF STATUS, RP0           ; Cambiar a banco 0

    ; Configuración de USART para comunicación Bluetooth
    CALL CONFIG_USART         ; Configurar USART para Bluetooth

    ; Bucle principal
BUCLE_PRINCIPAL:
    ; Comprobar si el sensor PIR detecta movimiento
    BTFSC PIR_SENSOR          ; Si el sensor PIR está activo
    CALL ACTIVAR_ALERTA       ; Llamar a la rutina de alerta
    BTFSS PIR_SENSOR          ; Si el sensor PIR está inactivo
    CALL DESACTIVAR_ALERTA    ; Llamar a la rutina de desactivación de alerta

    GOTO BUCLE_PRINCIPAL      ; Repetir el bucle principal

; Rutina para configurar USART
CONFIG_USART:
    MOVLW 0x24                ; Configurar velocidad de transmisión (por ejemplo, 9600 baudios)
    MOVWF SPBRG
    BSF TXSTA, TXEN           ; Habilitar el transmisor
    BSF RCSTA, SPEN           ; Habilitar el puerto serial
    RETURN

; Rutina para activar alerta
ACTIVAR_ALERTA:
    BSF LED_ALERTA            ; Encender LED de alerta
    MOVLW PIR_ACTIVO          ; Cargar el valor de PIR_ACTIVO
    CALL ENVIAR_BT            ; Enviar señal de activación por Bluetooth
    RETURN

; Rutina para desactivar alerta
DESACTIVAR_ALERTA:
    BCF LED_ALERTA            ; Apagar LED de alerta
    MOVLW PIR_INACTIVO        ; Cargar el valor de PIR_INACTIVO
    CALL ENVIAR_BT            ; Enviar señal de desactivación por Bluetooth
    RETURN

; Rutina para enviar datos por Bluetooth
ENVIAR_BT:
    MOVWF BT_TX               ; Cargar el valor en el registro de transmisión
    BTFSS PIR_SENSOR          ; Verificar si se completó la transmisión
    NOP                       ; Esperar a que el dato se envíe
    RETURN

    END
