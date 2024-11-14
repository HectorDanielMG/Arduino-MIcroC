// Pines para los LEDs de cada luz del semáforo
const int redPin = 10;
const int yellowPin = 9;
const int greenPin = 8;

// Duraciones en milisegundos para cada luz del semáforo
const unsigned long redDuration = 5000;   // 5 segundos
const unsigned long yellowDuration = 2000; // 2 segundos
const unsigned long greenDuration = 5000;  // 5 segundos

// Función para inicializar los pines de salida
void setup() {
  pinMode(redPin, OUTPUT);
  pinMode(yellowPin, OUTPUT);
  pinMode(greenPin, OUTPUT);
}

// Ciclo principal de operación del semáforo
void loop() {
  // Encender luz verde
  encenderLuz(greenPin, greenDuration);

  // Encender luz amarilla
  encenderLuz(yellowPin, yellowDuration);

  // Encender luz roja
  encenderLuz(redPin, redDuration);
}

// Función para encender una luz específica y esperar la duración definida
void encenderLuz(int pin, unsigned long duration) {
  digitalWrite(pin, HIGH); // Encender luz
  delay(duration);         // Esperar la duración asignada
  digitalWrite(pin, LOW);  // Apagar luz
}
