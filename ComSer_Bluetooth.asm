; ComSer_Bluetooth.asm - Comunicación Serial con Bluetooth
; Este programa permite la comunicación con un módulo Bluetooth HC-05.
; Actualización: Manejo de interrupciones para eficiencia, chequeo de estado de conexión.

.INCLUDE "m328pdef.inc"    ; Ajusta según tu microcontrolador
.DEF temp = r16
.DEF mensaje = r17

; Configuración de pines
.EQU TXD = 3               ; Pin TX (transmisión)
.EQU RXD = 2               ; Pin RX (recepción)
.EQU BT_STATE_PIN = 4      ; Pin de estado de conexión (ajustar según el módulo Bluetooth)

; Configuración de baudios y velocidad
.EQU BAUD_RATE = 9600
.EQU MYUBRR = (F_CPU / (16 * BAUD_RATE) - 1)

; Inicia el registro UBRR
Inicio:
    ldi temp, LOW(MYUBRR)
    out UBRR0L, temp
    ldi temp, HIGH(MYUBRR)
    out UBRR0H, temp

    ; Configuración de TX/RX habilitados, 8 bits de datos
    ldi temp, (1 << TXEN0) | (1 << RXEN0)
    out UCSR0B, temp

    ; Configuración de modo asíncrono, 8 bits de datos
    ldi temp, (1 << UCSZ01) | (1 << UCSZ00)
    out UCSR0C, temp

    ; Configuración del pin de estado de conexión del Bluetooth
    sbi DDRD, BT_STATE_PIN     ; Configura el pin de estado como salida
    cbi PORTD, BT_STATE_PIN    ; Inicialmente, apagado

    ; Habilita la interrupción de recepción serial
    sbi UCSR0B, RXCIE0
    sei                         ; Habilita interrupciones globales

LoopPrincipal:
    rjmp LoopPrincipal          ; Espera en bucle principal

; Enviar datos a través del Bluetooth
EnviarDatos:
    sbis UCSR0A, UDRE0         ; Espera hasta que el buffer de transmisión esté vacío
    rjmp EnviarDatos
    out UDR0, mensaje          ; Carga el dato en el buffer de transmisión
    ret

; Recepción de datos a través del Bluetooth con interrupción
RX_Interrupcion:
    in mensaje, UDR0            ; Lee el dato recibido
    cpi mensaje, '1'            ; Compara si el mensaje recibido es '1'
    breq Conectar               ; Si es '1', conecta el Bluetooth
    cpi mensaje, '0'
    breq Desconectar            ; Si es '0', desconecta el Bluetooth
    reti                        ; Finaliza la interrupción

; Función para conectar el módulo Bluetooth
Conectar:
    sbi PORTD, BT_STATE_PIN     ; Activa el pin de estado
    ldi mensaje, 'C'            ; Mensaje de conexión exitosa
    rcall EnviarDatos
    reti

; Función para desconectar el módulo Bluetooth
Desconectar:
    cbi PORTD, BT_STATE_PIN     ; Desactiva el pin de estado
    ldi mensaje, 'D'            ; Mensaje de desconexión
    rcall EnviarDatos
    reti

; Configuración para el temporizador (opcional) para verificar la conexión cada cierto tiempo
ConfigurarTemporizador:
    ldi temp, (1 << WGM01)      ; Modo CTC para temporizador
    out TCCR0A, temp
    ldi temp, (1 << CS02) | (1 << CS00) ; Pre-escalador 1024
    out TCCR0B, temp
    ldi temp, 156               ; Ajuste para un retardo de 100 ms
    out OCR0A, temp
    sbi TIMSK0, OCIE0A          ; Habilita interrupción del temporizador
    ret

; Interrupción del temporizador: checa el estado de conexión periódicamente
Temporizador_Interrupcion:
    sbic PIND, BT_STATE_PIN
    rjmp VerificarEstado
    reti

; Verifica el estado de conexión
VerificarEstado:
    ldi mensaje, 'S'            ; Envía 'S' para indicar estado conectado
    rcall EnviarDatos
    reti

; Vector de interrupciones
.org 0x0000
    rjmp Inicio
.org OCIE0A_vect
    rjmp Temporizador_Interrupcion
.org USART_RX_vect
    rjmp RX_Interrupcion
