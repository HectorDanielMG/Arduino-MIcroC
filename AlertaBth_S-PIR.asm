; AlertaBth_S-PIR.asm - Detección de movimiento mediante sensor PIR y envío de alerta vía Bluetooth
; Este código activa una alerta Bluetooth cuando se detecta movimiento prolongado

.INCLUDE "m328pdef.inc"      ; Archivo de configuración del ATmega328P

; Definición de registros
.DEF temp = r16              ; Registro temporal
.DEF pir_status = r17        ; Estado del PIR (movimiento detectado)
.DEF alert_flag = r18        ; Bandera de alerta

; Configuración de pines y constantes
.EQU PIR_PIN = 0             ; PIN del sensor PIR (PD0)
.EQU BT_TX = 1               ; PIN de transmisión de Bluetooth (PD1)
.EQU MOVEMENT_THRESHOLD = 50 ; Umbral de detección continua (50 ciclos)

Inicio:
    ; Configuración de I/O
    ldi temp, (1 << PIR_PIN)    ; Configura PD0 como entrada para el sensor PIR
    out DDRD, temp
    ldi temp, (1 << BT_TX)      ; Configura PD1 como salida para el módulo Bluetooth
    out DDRD, temp

    ; Inicialización de variables
    clr pir_status             ; Estado inicial del PIR sin movimiento
    clr alert_flag             ; Estado inicial de la alerta en cero

LoopPrincipal:
    ; Leer el estado del sensor PIR
    sbis PIND, PIR_PIN         ; Si el sensor detecta movimiento...
    rjmp MovimientoDetectado   ; Saltar a la rutina de detección de movimiento

    ; Si no hay movimiento, resetear las variables y continuar
    clr pir_status             ; Estado sin movimiento
    clr alert_flag             ; Desactivar la bandera de alerta
    rjmp LoopPrincipal         ; Regresar al inicio del loop

MovimientoDetectado:
    inc pir_status             ; Incrementa el contador de detección de movimiento
    cpi pir_status, MOVEMENT_THRESHOLD ; Compara con el umbral
    brlo LoopPrincipal         ; Si no alcanza el umbral, regresa a seguir monitoreando

EnviarAlerta:
    sbi PORTD, BT_TX           ; Activa el pin de transmisión Bluetooth para enviar alerta
    ldi alert_flag, 1          ; Activa la bandera de alerta para indicar que la señal fue enviada

    ; Pausa breve para transmisión
    ldi temp, 0xFF             ; Pausa en ciclos para asegurar la transmisión
Delay:
    dec temp
    brne Delay

    ; Resetear variables y volver a la espera de movimiento
    clr pir_status             ; Reinicia el contador de movimiento
    cbi PORTD, BT_TX           ; Desactiva el pin de transmisión
    rjmp LoopPrincipal         ; Regresa al inicio del loop
