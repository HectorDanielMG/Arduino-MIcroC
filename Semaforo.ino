// Pines de los LEDs
const int ledVerde = 8;
const int ledAmarillo = 7;
const int ledRojo = 6;

// Duraciones en milisegundos para cada estado del semáforo
const int duracionVerde = 5000;
const int duracionAmarillo = 2000;
const int duracionRojo = 5000;
const int duracionEmergencia = 500; // Duración del parpadeo en modo emergencia

// Variable de estado para el modo de emergencia
bool modoEmergencia = false;

void setup() {
    // Configurar pines como salida
    pinMode(ledVerde, OUTPUT);
    pinMode(ledAmarillo, OUTPUT);
    pinMode(ledRojo, OUTPUT);

    Serial.begin(9600); // Inicialización del puerto serial para el modo emergencia
}

void loop() {
    if (modoEmergencia) {
        activarModoEmergencia(); // Llama a la función de emergencia
    } else {
        cicloNormal(); // Llama al ciclo normal del semáforo
    }

    // Verificar entrada para activar el modo de emergencia
    if (Serial.available() > 0) {
        char comando = Serial.read();
        if (comando == 'E') {
            modoEmergencia = !modoEmergencia; // Cambia entre modo normal y de emergencia
        }
    }
}

// Función para el ciclo normal del semáforo
void cicloNormal() {
    encenderLed(ledVerde, duracionVerde);      // Verde
    encenderLed(ledAmarillo, duracionAmarillo); // Amarillo
    encenderLed(ledRojo, duracionRojo);         // Rojo
}

// Función para el modo de emergencia (destellos amarillos)
void activarModoEmergencia() {
    for (int i = 0; i < 5; i++) {  // El semáforo destella 5 veces en amarillo
        digitalWrite(ledAmarillo, HIGH);
        delay(duracionEmergencia);
        digitalWrite(ledAmarillo, LOW);
        delay(duracionEmergencia);
    }
}

// Función para encender un LED durante un tiempo específico y apagar los demás
void encenderLed(int led, int duracion) {
    // Apagar todos los LEDs
    digitalWrite(ledVerde, LOW);
    digitalWrite(ledAmarillo, LOW);
    digitalWrite(ledRojo, LOW);
    
    // Encender el LED especificado
    digitalWrite(led, HIGH);
    delay(duracion);
    digitalWrite(led, LOW); // Apagar el LED después del tiempo especificado
}
