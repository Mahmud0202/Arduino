// --- Пины ---
const int pinButtonPower = 2;     // Кнопка включения/выключения охраны
const int pinSensor = 3;          // Кнопка (датчик)
const int pinLed = 9;             // Светодиод
const int pinBuzzer = 10;         // Зуммер
const int pinPot = A0;            // Потенциометр

// --- Переменные ---
bool systemArmed = false;  // Состояние охраны
unsigned long alarmDuration = 0;

void setup() {
  pinMode(pinButtonPower, INPUT_PULLUP);
  pinMode(pinSensor, INPUT_PULLUP);
  pinMode(pinLed, OUTPUT);
  pinMode(pinBuzzer, OUTPUT);
  pinMode(pinPot, INPUT);

  Serial.begin(9600);
}

void loop() {
  // Кнопка включения/выключения охраны
  if (digitalRead(pinButtonPower) == LOW) {
    delay(300); // антидребезг
    systemArmed = !systemArmed; // переключение режима
    digitalWrite(pinLed, HIGH);
    delay(150);
    digitalWrite(pinLed, LOW);
    Serial.println(systemArmed ? "Система на охране" : "Система снята с охраны");
  }

  // Проверяем, если охрана включена и сработал датчик
  if (systemArmed && digitalRead(pinSensor) == LOW) {
    Serial.println("ТРЕВОГА!");
    int potValue = analogRead(pinPot);
    alarmDuration = map(potValue, 0, 1023, 1000, 10000); // 1-10 секунд
    unsigned long startTime = millis();

    // Пока не истекло заданное время
    while (millis() - startTime < alarmDuration) {
      digitalWrite(pinLed, HIGH);
      digitalWrite(pinBuzzer, HIGH);
      delay(150);
      digitalWrite(pinLed, LOW);
      digitalWrite(pinBuzzer, LOW);
      delay(150);
    }
    Serial.println("Тревога окончена");
  }
}
