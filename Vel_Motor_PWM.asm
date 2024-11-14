; Programa para controlar la velocidad de un motor usando PWM
; Configuración del microcontrolador
; Este ejemplo usa un microcontrolador con un temporizador y un módulo PWM.

    LIST    P=16F877A    ; Especifica el modelo del microcontrolador
    INCLUDE <P16F877A.INC>

    ORG 0x00             ; Dirección de inicio del programa
    GOTO INICIO          ; Saltar a la etiqueta INICIO al comenzar

; Configuración de constantes
DUTY_CYCLE EQU 0x20      ; Registro para el ciclo de trabajo del PWM (0-255)
MAX_DUTY   EQU 0xFF      ; Valor máximo del ciclo de trabajo (255)

; Configuración de pines
MOTOR_PIN EQU PORTC, 2   ; Pin de salida PWM para el motor (ejemplo RC2)

; Inicio del programa
INICIO:
    ; Configuración de puertos
    CLRF PORTC           ; Limpiar el puerto C
    BSF STATUS, RP0      ; Cambiar al banco 1
    MOVLW 0x00
    MOVWF TRISC          ; Configurar PORTC como salida
    BCF STATUS, RP0      ; Volver al banco 0

    ; Configuración del PWM
    CALL CONFIG_PWM      ; Llamar a la rutina de configuración de PWM
    MOVLW 0x80           ; Ciclo de trabajo inicial al 50%
    MOVWF DUTY_CYCLE

BUCLE_PRINCIPAL:
    CALL AJUSTAR_PWM     ; Ajustar el ciclo de trabajo (velocidad del motor)
    GOTO BUCLE_PRINCIPAL ; Bucle infinito

; Rutina de configuración del PWM
CONFIG_PWM:
    MOVLW 0x6C           ; Configuración del temporizador 2
    MOVWF T2CON          ; Prescaler y activación de TMR2
    MOVLW 0x3C           ; Configurar el módulo CCP para PWM
    MOVWF CCP1CON        ; Modo PWM
    BSF T2CON, TMR2ON    ; Encender el temporizador 2
    RETURN

; Rutina para ajustar el ciclo de trabajo PWM
AJUSTAR_PWM:
    MOVF DUTY_CYCLE, W   ; Cargar el ciclo de trabajo actual
    MOVWF CCPR1L         ; Ajustar la señal PWM (8 bits altos)
    RETURN

; Aumentar el ciclo de trabajo (aumentar velocidad del motor)
AUMENTAR_VELOCIDAD:
    INCF DUTY_CYCLE, F   ; Incrementar el ciclo de trabajo en 1
    BTFSC STATUS, Z      ; Si el ciclo de trabajo alcanza el máximo,
    MOVLW MAX_DUTY       ; entonces mantener el valor máximo
    MOVWF DUTY_CYCLE
    RETURN

; Reducir el ciclo de trabajo (reducir velocidad del motor)
REDUCIR_VELOCIDAD:
    DECF DUTY_CYCLE, F   ; Decrementar el ciclo de trabajo en 1
    BTFSS STATUS, Z      ; Si el ciclo de trabajo alcanza 0,
    MOVLW 0x00           ; entonces mantener el valor mínimo
    MOVWF DUTY_CYCLE
    RETURN

    END
