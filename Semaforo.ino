// Definir los pines para los LEDs
const int redLED = 8;
const int yellowLED = 9;
const int greenLED = 10;

// Definir los tiempos de espera
const int redTime = 5000;    // 5 segundos para rojo
const int yellowTime = 2000; // 2 segundos para amarillo
const int greenTime = 5000;  // 5 segundos para verde

void setup() {
  // Configurar los pines como salida
  pinMode(redLED, OUTPUT);
  pinMode(yellowLED, OUTPUT);
  pinMode(greenLED, OUTPUT);
}

void loop() {
  // Encender la luz roja
  digitalWrite(redLED, HIGH);
  delay(redTime);
  digitalWrite(redLED, LOW);
  
  // Encender la luz verde
  digitalWrite(greenLED, HIGH);
  delay(greenTime);
  digitalWrite(greenLED, LOW);
  
  // Encender la luz amarilla
  digitalWrite(yellowLED, HIGH);
  delay(yellowTime);
  digitalWrite(yellowLED, LOW);
}
