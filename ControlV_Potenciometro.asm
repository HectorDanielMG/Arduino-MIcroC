; ControlV_Potenciometro.asm - Control de velocidad de motor basado en potenciómetro usando ADC y PWM
; Objetivo: Leer el valor de un potenciómetro con el ADC, mapearlo a un rango de velocidad PWM, y ajustar la velocidad de un motor

.INCLUDE "m328pdef.inc"    ; Archivo de configuración para el ATmega328P

; Definición de registros
.DEF pot_val = r16          ; Registro para el valor del potenciómetro
.DEF pwm_val = r17          ; Registro para el valor PWM
.DEF temp = r18             ; Registro temporal

; Inicialización de puertos
.EQU MOTOR_PIN = 0b00000001 ; Pin del motor conectado a OC0A (PB0)
.EQU POT_CHANNEL = 0        ; Canal ADC para el potenciómetro en ADC0

; Rango de velocidad del PWM
.EQU MIN_SPEED = 0x10       ; Velocidad mínima del motor
.EQU MAX_SPEED = 0xFF       ; Velocidad máxima del motor

Inicio:
    ; Configuración de I/O
    ldi temp, MOTOR_PIN
    out DDRB, temp           ; Configura PB0 como salida para el motor
    
    ; Configuración de Timer0 para PWM rápido
    ldi temp, (1<<WGM00) | (1<<WGM01) | (1<<COM0A1)   ; PWM rápido, OC0A en modo no inversor
    out TCCR0A, temp
    ldi temp, (1<<CS01)                              ; Prescaler de 8
    out TCCR0B, temp

    ; Configuración del ADC
    ldi temp, (1<<REFS0)                             ; Vref en AVcc, canal ADC0
    out ADMUX, temp
    ldi temp, (1<<ADEN) | (1<<ADPS2) | (1<<ADPS1) | (1<<ADPS0) ; Habilitar ADC, prescaler de 128
    out ADCSRA, temp

LoopPrincipal:
    ; Inicia una conversión ADC
    sbi ADCSRA, ADSC                              ; Iniciar conversión
EsperarADC:
    sbis ADCSRA, ADIF                             ; Esperar a que la conversión termine
    rjmp EsperarADC
    in pot_val, ADCL                              ; Leer el byte bajo del ADC
    in temp, ADCH                                 ; Leer el byte alto del ADC
    mov pot_val, temp                             ; Guardar el resultado de 8 bits en pot_val
    
    ; Mapeo de valor ADC a rango de velocidad PWM (0x10 a 0xFF)
    ldi temp, MIN_SPEED                           ; Mínimo valor PWM
    mov pwm_val, pot_val                          ; Copiar el valor del ADC a pwm_val
    add pwm_val, temp                             ; Aumentar el valor de acuerdo al mínimo

    ; Ajuste del límite máximo
    cpi pwm_val, MAX_SPEED                        ; Comparar con velocidad máxima
    brlo SetPWM                                   ; Si es menor que el límite, procede a configurarlo
    ldi pwm_val, MAX_SPEED                        ; Si es mayor, configura pwm_val al máximo

SetPWM:
    out OCR0A, pwm_val                            ; Ajustar valor PWM para controlar la velocidad del motor

    ; Repetir el ciclo
    rjmp LoopPrincipal

