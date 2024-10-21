 ; Control de dispositivos mediante Bluetooth con respuesta a comandos

.org 0x0000
    rjmp inicio

inicio:
    ldi r16, (1<<DDB0) | (1<<DDB1) | (1<<DDB2) ; Configurar PB0, PB1, PB2 como salida
    out DDRB, r16
    ldi r16, (1<<RXEN) | (1<<TXEN) ; Habilitar UART RX y TX
    out UCR, r16

configurarUART:
    ldi r16, 103                    ; Configurar baud rate para 9600 bps (para 16 MHz)
    out UBRRL, r16
    ldi r16, (1<<UCSZ1) | (1<<UCSZ0) ; 8 bits de datos, sin paridad, 1 bit de parada
    out UCSRC, r16

bucle:
    call recibirComando
    call procesarComando
    rjmp bucle

recibirComando:
    sbis UCSRA, RXC                 ; Esperar a recibir datos
    rjmp recibirComando
    in r16, UDR                     ; Leer el comando recibido
    ret

procesarComando:
    cpi r16, '1'                    ; Si recibe '1', encender LED en PB0
    breq encenderLED
    cpi r16, '0'                    ; Si recibe '0', apagar LED en PB0
    breq apagarLED
    ret

encenderLED:
    sbi PORTB, PB0                  ; Encender LED en PB0
    ret

apagarLED:
    cbi PORTB, PB0                  ; Apagar LED en PB0
    ret

