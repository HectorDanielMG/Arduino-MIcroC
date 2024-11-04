; Vel_Motor_PWM.asm - Control de velocidad de motor DC con PWM ajustable mediante potenciómetro
; Actualización: Control de velocidad en tiempo real con función de aceleración

.INCLUDE "m328pdef.inc"    ; Configuración para el microcontrolador ATmega328P (ajusta según tu microcontrolador)

; Definición de registros y constantes
.DEF temp = r16
.DEF pot_value = r17        ; Valor analógico del potenciómetro
.DEF pwm_duty = r18         ; Ciclo de trabajo del PWM para controlar la velocidad
.DEF last_pwm_duty = r19    ; Último valor de duty cycle para control suave

; Definición de pines
.EQU MOTOR_PIN = 1          ; Conexión del motor en OC1A (PB1)
.EQU POT_CHANNEL = 0        ; Canal ADC0 (potenciómetro)

; Configuración de parámetros PWM
.EQU MAX_PWM = 255          ; Valor máximo de ciclo de trabajo PWM (8 bits)

Inicio:
    ; Configuración del pin del motor como salida
    sbi DDRB, MOTOR_PIN      ; Configura PB1 como salida

    ; Configuración del temporizador para generar PWM en modo Fast PWM
    ldi temp, (1 << WGM10) | (1 << WGM12)    ; Configuración para Fast PWM de 8 bits
    out TCCR1A, temp
    ldi temp, (1 << COM1A1)                  ; PWM no invertido en OC1A (PB1)
    out TCCR1A, temp
    ldi temp, (1 << CS11)                    ; Prescaler de 8
    out TCCR1B, temp

    ; Configuración del ADC para leer el valor del potenciómetro
    ldi temp, (1 << REFS0)                   ; Referencia de voltaje AVCC
    out ADMUX, temp
    ldi temp, (1 << ADEN) | (1 << ADPS2) | (1 << ADPS1) | (1 << ADPS0) ; Habilita ADC, prescaler de 128
    out ADCSRA, temp

LoopPrincipal:
    ; Inicia la conversión ADC para leer el potenciómetro
    sbi ADCSRA, ADSC                    ; Inicia la conversión
    sbis ADCSRA, ADIF                   ; Espera hasta que la conversión se complete
    rjmp LoopPrincipal
    in pot_value, ADCL                  ; Lee el valor del ADC en pot_value
    mov pwm_duty, pot_value             ; Asigna el valor leído al ciclo de trabajo del PWM
    call Suave_Ajuste_PWM               ; Llama a la subrutina para ajustar PWM suavemente
    rjmp LoopPrincipal                  ; Repite el bucle principal

; Subrutina de ajuste suave de PWM
Suave_Ajuste_PWM:
    ; Ajusta gradualmente el duty cycle para evitar cambios bruscos
    cp pwm_duty, last_pwm_duty
    breq Fin_Ajuste                      ; Si no hay cambio, termina
    cp pwm_duty, last_pwm_duty
    brsh Incrementar_PWM                 ; Si pwm_duty es mayor, incrementa
    dec last_pwm_duty                    ; Decrementa el duty cycle suavemente
    rjmp Fin_Ajuste

Incrementar_PWM:
    inc last_pwm_duty                    ; Incrementa el duty cycle suavemente
    rjmp Fin_Ajuste

Fin_Ajuste:
    out OCR1A, last_pwm_duty             ; Actualiza el ciclo de trabajo del PWM
    ret

; Vector de interrupciones
.org 0x0000
    rjmp Inicio
