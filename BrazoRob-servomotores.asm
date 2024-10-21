 ; Control de brazo robótico con 3 servomotores mediante botones

.org 0x0000
    rjmp inicio

inicio:
    ldi r16, (1<<DDB1) | (1<<DDB2) | (1<<DDB3) ; Configurar PB1, PB2, PB3 como salidas (servos)
    out DDRB, r16
    ldi r16, (1<<DDA0) | (1<<DDA1) | (1<<DDA2) ; Configurar PA0, PA1, PA2 como entradas (botones)
    out DDRA, r16

configurarPWM:
    ; Configurar Timer para generar PWM para los servos
    ldi r16, (1<<WGM12) | (1<<WGM10) ; Modo Fast PWM de 8 bits
    out TCCR1A, r16
    ldi r16, (1<<CS11)              ; Prescaler de 8 para el temporizador
    out TCCR1B, r16

bucle:
    call leerBotones
    call moverServos
    rjmp bucle

leerBotones:
    sbis PINA, PA0
    ldi r16, 1                      ; Botón 1 presionado, mover servo 1
    sbis PINA, PA1
    ldi r16, 2                      ; Botón 2 presionado, mover servo 2
    sbis PINA, PA2
    ldi r16, 3                      ; Botón 3 presionado, mover servo 3
    ret

moverServos:
    cpi r16, 1
    breq moverServo1
    cpi r16, 2
    breq moverServo2
    cpi r16, 3
    breq moverServo3
    ret

moverServo1:
    ; Código para mover el servo 1 basado en el botón presionado
    ; ...
    ret

moverServo2:
    ; Código para mover el servo 2 basado en el botón presionado
    ; ...
    ret

moverServo3:
    ; Código para mover el servo 3 basado en el botón presionado
    ; ...
    ret

