
const int ldrPin = A0;       // Фоторезистор
const int potPin = A1;       // Потенциометр (чувствительность)
const int ledPin = 9;        // Светодиод
const int buzzerPin = 10;    // Зуммер

unsigned long darkStartTime = 0; // качан караңгы башталды
bool wasDark = false;             // абалды сактоо

void setup() {
  pinMode(ledPin, OUTPUT);
  pinMode(buzzerPin, OUTPUT);
  Serial.begin(9600);
}

void loop() {
  int lightValue = analogRead(ldrPin); // жарыктын деңгээли
  int sensitivity = analogRead(potPin); // потенциометр мааниси
  sensitivity = map(sensitivity, 0, 1023, 100, 900); // чекти жөндөйт

  Serial.print("Light: ");
  Serial.print(lightValue);
  Serial.print(" | Threshold: ");
  Serial.println(sensitivity);

  if (lightValue < sensitivity) {
    if (!wasDark) {
      wasDark = true;
      darkStartTime = millis(); // караңгы башталды
    }

    if (millis() - darkStartTime >= 5000) {
      digitalWrite(ledPin, HIGH);
      tone(buzzerPin, 1000, 200); // кыска үн
    } else {
      digitalWrite(ledPin, HIGH);
      noTone(buzzerPin);
    }

  } else {
   
    wasDark = false;
    digitalWrite(ledPin, LOW);
    noTone(buzzerPin);
  }

  delay(100);
}
