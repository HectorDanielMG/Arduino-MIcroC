; MotorPP_Bth.asm - Control de un Motor de Paso mediante Bluetooth
; Actualización: Adición de control de velocidad y dirección mediante Bluetooth.

.INCLUDE "m328pdef.inc"    ; Configuración para el microcontrolador ATmega328P (ajusta según tu microcontrolador)

; Definición de registros y constantes
.DEF temp = r16
.DEF command = r17          ; Comando recibido del módulo Bluetooth
.DEF step_delay = r18       ; Tiempo de retraso entre pasos para controlar la velocidad
.DEF step_counter = r19     ; Contador de pasos para controlar la secuencia del motor

; Definición de pines
.EQU MOTOR_PIN1 = 0         ; Conexión del motor de pasos en los pines PD0-PD3
.EQU MOTOR_PIN2 = 1
.EQU MOTOR_PIN3 = 2
.EQU MOTOR_PIN4 = 3

.EQU BT_RXD = 2             ; Pin RX para Bluetooth
.EQU BT_TXD = 3             ; Pin TX para Bluetooth

; Configuración de secuencia para control del motor
.SECTION Motor_Steps
    .DB 0b0001, 0b0010, 0b0100, 0b1000  ; Secuencia para control de 4 fases

; Configuración de velocidad inicial
.EQU BASE_DELAY = 20        ; Base de retardo para ajustar la velocidad del motor

Inicio:
    ; Configuración del puerto para motor de pasos
    ldi temp, 0x0F           ; Configura PD0-PD3 como salidas
    out DDRD, temp

    ; Configuración de velocidad por defecto
    ldi step_delay, BASE_DELAY

    ; Configuración de UART
    ldi temp, (1 << RXEN0) | (1 << TXEN0) ; Habilita RX y TX
    out UCSR0B, temp
    ldi temp, (1 << UCSZ01) | (1 << UCSZ00) ; Modo de 8 bits de datos
    out UCSR0C, temp
    sbi UCSR0B, RXCIE0         ; Habilita interrupción de recepción
    sei                         ; Habilita interrupciones globales

LoopPrincipal:
    ; Bucle principal espera y procesa comandos recibidos
    rjmp LoopPrincipal         ; Mantiene en bucle principal

; Interrupción de recepción de Bluetooth
USART_RX_vect:
    in command, UDR0           ; Almacena el comando recibido en 'command'
    cpi command, 'A'           ; 'A' para giro horario
    breq GiroHorario
    cpi command, 'B'           ; 'B' para giro antihorario
    breq GiroAntihorario
    cpi command, 'S'           ; 'S' para detener el motor
    breq DetenerMotor
    cpi command, '+'           ; '+' para aumentar la velocidad
    breq AumentarVelocidad
    cpi command, '-'           ; '-' para disminuir la velocidad
    breq DisminuirVelocidad
    reti

; Subrutina para giro horario del motor
GiroHorario:
    ldi step_counter, 0       ; Reinicia el contador de pasos
GiroHorario_Loop:
    lpm temp, Z               ; Carga el valor del siguiente paso en la secuencia
    out PORTD, temp           ; Aplica el paso al puerto del motor
    rcall Retraso             ; Llama a subrutina de retraso (control de velocidad)
    inc step_counter          ; Incrementa el contador de pasos
    cpi step_counter, 4       ; Revisa si se ha completado la secuencia
    brne GiroHorario_Loop     ; Si no, repite el ciclo
    reti

; Subrutina para giro antihorario del motor
GiroAntihorario:
    ldi step_counter, 3       ; Inicia en el último paso de la secuencia
GiroAntihorario_Loop:
    lpm temp, Z               ; Carga el valor del paso en la secuencia
    out PORTD, temp           ; Aplica el paso al puerto del motor
    rcall Retraso             ; Llama a subrutina de retraso
    dec step_counter          ; Decrementa el contador de pasos
    brpl GiroAntihorario_Loop ; Repite el ciclo si step_counter >= 0
    reti

; Subrutina para detener el motor
DetenerMotor:
    clr temp                  ; Limpia el puerto del motor
    out PORTD, temp
    reti

; Subrutina para aumentar la velocidad
AumentarVelocidad:
    subi step_delay, 5        ; Reduce el retardo entre pasos (incrementa la velocidad)
    reti

; Subrutina para disminuir la velocidad
DisminuirVelocidad:
    subi step_delay, -5       ; Aumenta el retardo entre pasos (reduce la velocidad)
    reti

; Subrutina de retraso para control de velocidad
Retraso:
    mov temp, step_delay      ; Carga el valor de 'step_delay' en 'temp'
Delay_Loop:
    dec temp
    brne Delay_Loop           ; Repite hasta que temp llegue a cero
    ret

; Vector de interrupciones
.org 0x0000
    rjmp Inicio
.org USART_RX_vect
    rjmp USART_RX_vect
