#include <SoftwareSerial.h>

SoftwareSerial bluetooth(0, 1); // RX, TX

int ledPin = 2;
int buttonPin = 3;
int bajada = 0;
unsigned long lastDebounceTime = 0;  // Tiempo de la última vez que cambió el estado del botón
unsigned long debounceDelay = 50;    // Retraso para debounce (50 ms)

void setup() {
  Serial.begin(9600);
  bluetooth.begin(9600);
  pinMode(ledPin, OUTPUT);
  pinMode(buttonPin, INPUT_PULLUP); // Usar INPUT_PULLUP para evitar problemas de flotación

  // Inicializar la semilla para el generador de números aleatorios
  randomSeed(analogRead(0));
  Serial.println("--");
}

void loop() {
  // Leer el estado del botón
  int buttonState = digitalRead(buttonPin);

  // Detectar cuando se presiona el botón (flanco de bajada)
  if (buttonState == LOW && bajada == 0 && (millis() - lastDebounceTime) > debounceDelay) {
    lastDebounceTime = millis();  // Guardar el tiempo actual
    bajada = 1;
    
    // Generar un número aleatorio entre 0 y 40
    int randomNumber = random(0, 41);

    // Enviar el número aleatorio por Bluetooth
    bluetooth.println(randomNumber);
    Serial.println(randomNumber); // Imprimir el comando recibido

  } 

  // Resetear bajada cuando el botón es liberado
  if (buttonState == HIGH) {
    bajada = 0;
  }

  // Leer comandos desde Bluetooth
  if (bluetooth.available()) {
    char command = bluetooth.read();


    if (command == '1') {
      digitalWrite(ledPin, HIGH); // Encender el LED

    } else if (command == '0') {
      digitalWrite(ledPin, LOW); // Apagar el LED

    }
  }
}


