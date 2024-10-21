; Sistema de seguridad con detección de movimiento y alerta Bluetooth

.org 0x0000
    rjmp inicio

inicio:
    ldi r16, (1<<DDB0)              ; Configurar PB0 como salida (sirena o LED de alerta)
    out DDRB, r16
    ldi r16, (1<<DDA1)              ; Configurar PA1 como entrada (sensor PIR)
    out DDRA, r16
    ldi r16, (1<<RXEN) | (1<<TXEN)  ; Habilitar UART RX y TX
    out UCR, r16

configurarUART:
    ldi r16, 103                    ; Configurar baud rate para 9600 bps (para 16 MHz)
    out UBRRL, r16
    ldi r16, (1<<UCSZ1) | (1<<UCSZ0) ; 8 bits de datos, sin paridad, 1 bit de parada
    out UCSRC, r16

bucle:
    call detectarMovimiento
    brne enviarAlerta               ; Si detecta movimiento, enviar alerta
    rjmp bucle

detectarMovimiento:
    sbis PINA, PA1                  ; Leer estado del sensor PIR
    ldi r16, 0
    ret
    ldi r16, 1                      ; Movimiento detectado
    ret

enviarAlerta:
    ldi r16, 'A'                    ; Enviar 'A' como mensaje de alerta
    out UDR, r16
    ret
 
