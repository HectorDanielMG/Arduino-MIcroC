 ; Control de motor bidireccional con control de velocidad (PWM) mediante potenciómetro

.org 0x0000
    rjmp inicio

inicio:
    ldi r16, (1<<DDB1) | (1<<DDB0) ; Configurar PB0 y PB1 como salida (dirección motor)
    out DDRB, r16
    ldi r16, (1<<DDA0)             ; Configurar PA0 como entrada (potenciómetro)
    out DDRA, r16

configurarPWM:
    ; Configurar Timer 1 para PWM en modo Fast PWM, no invertido
    ldi r16, (1<<WGM12) | (1<<WGM10) ; Modo Fast PWM de 8 bits
    out TCCR1A, r16
    ldi r16, (1<<CS11)              ; Prescaler de 8 para el temporizador
    out TCCR1B, r16
    ldi r16, (1<<COM1A1)            ; Habilitar salida PWM en OC1A (PB1)
    out TCCR1A, r16

bucle:
    call leerPotenciometro
    call ajustarVelocidad
    rjmp bucle

leerPotenciometro:
    ldi r16, (1<<MUX0)              ; Seleccionar el canal ADC0 (PA0)
    out ADMUX, r16
    ldi r16, (1<<ADEN) | (1<<ADSC)  ; Habilitar ADC y empezar la conversión
    out ADCSRA, r16
esperarADC:
    sbis ADCSRA, ADSC               ; Esperar a que termine la conversión
    rjmp esperarADC
    in r16, ADCH                    ; Leer el valor alto de la conversión (8 bits)
    ret

ajustarVelocidad:
    out OCR1A, r16                  ; Ajustar el ciclo de trabajo PWM basado en el valor del potenciómetro
    ret

