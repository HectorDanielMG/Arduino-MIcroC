; Programa en ensamblador para controlar un motor paso a paso a través de Bluetooth
; Se utiliza un microcontrolador que permite comunicación serial para Bluetooth y salidas digitales para el motor
; Supongamos que el motor está conectado a los pines PORTB 0-3 y el módulo Bluetooth a través de USART

    LIST P=16F877A             ; Especifica el microcontrolador
    INCLUDE <P16F877A.INC>

    ORG 0x00                   ; Dirección de inicio del programa
    GOTO INICIO                ; Ir a la etiqueta INICIO

; Configuración de constantes y pines
MOTOR_PINES    EQU PORTB       ; Pines del motor paso a paso (PORTB 0-3)
BT_RX          EQU RCREG       ; Registro de recepción de Bluetooth
DELAY_VELOCIDAD EQU 0xFF       ; Valor inicial de retraso para controlar la velocidad del motor

; Comandos Bluetooth
CMD_GIRO_DERECHA EQU 0x01      ; Comando para girar el motor hacia la derecha
CMD_GIRO_IZQUIERDA EQU 0x02    ; Comando para girar el motor hacia la izquierda
CMD_VELOCIDAD_MAS EQU 0x03     ; Comando para aumentar la velocidad
CMD_VELOCIDAD_MENOS EQU 0x04   ; Comando para disminuir la velocidad

; Variables
VELOCIDAD      EQU 0x20        ; Variable de velocidad
PASO_ACTUAL    EQU 0x21        ; Paso actual del motor

; Tabla de pasos del motor paso a paso (4 fases)
TABLA_PASOS:
    ADDWF PCL, F
    RETLW 0x09                 ; Paso 1
    RETLW 0x0A                 ; Paso 2
    RETLW 0x06                 ; Paso 3
    RETLW 0x05                 ; Paso 4

; Inicio del programa
INICIO:
    ; Configuración de puertos
    BSF STATUS, RP0            ; Cambiar a banco 1
    CLRF TRISB                 ; Configurar PORTB como salida para el motor
    BCF STATUS, RP0            ; Cambiar a banco 0

    ; Configuración de USART para comunicación Bluetooth
    CALL CONFIG_USART          ; Llamar a la subrutina de configuración USART

    ; Valores iniciales
    MOVLW 0x01
    MOVWF PASO_ACTUAL          ; Paso inicial del motor
    MOVLW DELAY_VELOCIDAD
    MOVWF VELOCIDAD            ; Velocidad inicial

    ; Bucle principal
BUCLE_PRINCIPAL:
    ; Verificar si hay datos de Bluetooth
    BTFSS PIR1, RCIF           ; Comprobar si se ha recibido un dato
    GOTO BUCLE_PRINCIPAL       ; Si no hay datos, seguir esperando
    MOVF BT_RX, W              ; Leer el comando recibido

    ; Evaluar el comando recibido
    MOVWF FSR                  ; Colocar el comando en el registro FSR
    CALL PROCESAR_COMANDO      ; Llamar a la subrutina de procesamiento de comandos

    GOTO BUCLE_PRINCIPAL       ; Repetir el bucle

; Subrutina para configurar USART
CONFIG_USART:
    MOVLW 0x24                 ; Configurar baudrate (por ejemplo, 9600 baudios)
    MOVWF SPBRG
    BSF TXSTA, TXEN            ; Habilitar el transmisor
    BSF RCSTA, SPEN            ; Habilitar el puerto serial
    RETURN

; Subrutina para procesar el comando recibido
PROCESAR_COMANDO:
    ; Controlar el motor según el comando recibido
    MOVF FSR, W
    CPFSEQ CMD_GIRO_DERECHA
    CALL GIRO_DERECHA
    CPFSEQ CMD_GIRO_IZQUIERDA
    CALL GIRO_IZQUIERDA
    CPFSEQ CMD_VELOCIDAD_MAS
    CALL AUMENTAR_VELOCIDAD
    CPFSEQ CMD_VELOCIDAD_MENOS
    CALL DISMINUIR_VELOCIDAD
    RETURN

; Rutina para girar el motor a la derecha
GIRO_DERECHA:
    MOVF PASO_ACTUAL, W
    CALL TABLA_PASOS
    MOVWF MOTOR_PINES
    INCF PASO_ACTUAL, F        ; Incrementar el paso actual
    MOVLW 0x04                 ; Paso máximo (4 pasos)
    CPFSGT PASO_ACTUAL
    CLRF PASO_ACTUAL           ; Reiniciar el paso si supera el límite
    CALL RETARDO               ; Controlar la velocidad
    RETURN

; Rutina para girar el motor a la izquierda
GIRO_IZQUIERDA:
    MOVF PASO_ACTUAL, W
    CALL TABLA_PASOS
    MOVWF MOTOR_PINES
    DECF PASO_ACTUAL, F        ; Decrementar el paso actual
    MOVLW 0x00
    CPFSLT PASO_ACTUAL
    MOVLW 0x03                 ; Volver al paso máximo si se desborda
    RETURN

; Rutina para aumentar la velocidad del motor
AUMENTAR_VELOCIDAD:
    DECFSZ VELOCIDAD, F        ; Reducir el retardo (aumenta la velocidad)
    RETURN

; Rutina para disminuir la velocidad del motor
DISMINUIR_VELOCIDAD:
    INCF VELOCIDAD, F          ; Aumentar el retardo (reduce la velocidad)
    RETURN

; Rutina de retardo
RETARDO:
    MOVF VELOCIDAD, W          ; Usar el valor de VELOCIDAD como retardo
RETARDO_LOOP:
    NOP
    DECFSZ WREG, F
    GOTO RETARDO_LOOP
    RETURN

    END
