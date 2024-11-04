// Pines de conexión
const int pinMotorForward = 9;   // Pin para dirección horaria
const int pinMotorBackward = 10; // Pin para dirección antihoraria
const int pinPotenciometro = A0; // Pin del potenciómetro para velocidad
const int pinLedForward = 6;     // LED para sentido horario
const int pinLedBackward = 7;    // LED para sentido antihorario
const int pinStopButton = 8;     // Botón para parada de emergencia

// Variables
int velocidadMotor = 0;   // Variable para almacenar la velocidad del motor
bool motorDetenido = false; // Estado de parada de emergencia

void setup() {
    // Configuración de pines
    pinMode(pinMotorForward, OUTPUT);
    pinMode(pinMotorBackward, OUTPUT);
    pinMode(pinLedForward, OUTPUT);
    pinMode(pinLedBackward, OUTPUT);
    pinMode(pinStopButton, INPUT_PULLUP);
    
    Serial.begin(9600); // Comunicación serial para depuración
}

void loop() {
    // Leer el estado del botón de parada de emergencia
    motorDetenido = !digitalRead(pinStopButton);

    // Si el botón de parada no está presionado
    if (!motorDetenido) {
        // Leer el valor del potenciómetro para ajustar la velocidad
        int valorPot = analogRead(pinPotenciometro);
        velocidadMotor = map(valorPot, 0, 1023, 0, 255);

        // Leer comandos para el sentido del motor desde el serial
        if (Serial.available() > 0) {
            char comando = Serial.read();
            
            // Ajustar la dirección y activar LEDs según el comando
            if (comando == 'F') {
                moverMotor(true);
            } else if (comando == 'B') {
                moverMotor(false);
            }
        }
    } else {
        // Parar el motor y apagar LEDs en caso de parada de emergencia
        detenerMotor();
    }
}

// Función para mover el motor en la dirección indicada
void moverMotor(bool sentidoHorario) {
    if (sentidoHorario) {
        analogWrite(pinMotorForward, velocidadMotor);
        analogWrite(pinMotorBackward, 0);
        digitalWrite(pinLedForward, HIGH);
        digitalWrite(pinLedBackward, LOW);
    } else {
        analogWrite(pinMotorForward, 0);
        analogWrite(pinMotorBackward, velocidadMotor);
        digitalWrite(pinLedForward, LOW);
        digitalWrite(pinLedBackward, HIGH);
    }
}

// Función para detener el motor
void detenerMotor() {
    analogWrite(pinMotorForward, 0);
    analogWrite(pinMotorBackward, 0);
    digitalWrite(pinLedForward, LOW);
    digitalWrite(pinLedBackward, LOW);
}
