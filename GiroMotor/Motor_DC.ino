// Definición de pines para los botones
const int botonHorario = 10;     // Botón P1 conectado al pin D10
const int botonAntihorario = 9;  // Botón P2 conectado al pin D9

// Definición de pines para los relés
const int releHorario = 5;       // Relé RL1 conectado al pin D5
const int releAntihorario = 4;   // Relé RL2 conectado al pin D4

void setup() {
  // Configurar los pines de los botones como entradas con pull-up interno
  pinMode(botonHorario, INPUT_PULLUP);
  pinMode(botonAntihorario, INPUT_PULLUP);

  // Configurar los pines de los relés como salidas
  pinMode(releHorario, OUTPUT);
  pinMode(releAntihorario, OUTPUT);

  // Asegurar que los relés estén apagados al iniciar
  digitalWrite(releHorario, LOW);
  digitalWrite(releAntihorario, LOW);
}

void loop() {
  // Leer el estado de los botones
  int estadoBotonHorario = digitalRead(botonHorario);
  int estadoBotonAntihorario = digitalRead(botonAntihorario);

  // Invertir lógica: Si se presiona el botón P1, ahora el motor gira en sentido antihorario
  if (estadoBotonHorario == LOW && estadoBotonAntihorario == HIGH) {
    digitalWrite(releAntihorario, HIGH);   // Activar relé de giro antihorario
    digitalWrite(releHorario, LOW);        // Asegurar que el relé horario esté apagado
  } 
  // Invertir lógica: Si se presiona el botón P2, ahora el motor gira en sentido horario
  else if (estadoBotonAntihorario == LOW && estadoBotonHorario == HIGH) {
    digitalWrite(releHorario, HIGH);       // Activar relé de giro horario
    digitalWrite(releAntihorario, LOW);    // Asegurar que el relé antihorario esté apagado
  } 
  // Si no se presiona ningún botón, ambos relés deben estar apagados (motor sin girar)
  else {
    digitalWrite(releHorario, LOW);
    digitalWrite(releAntihorario, LOW);
  }
}
