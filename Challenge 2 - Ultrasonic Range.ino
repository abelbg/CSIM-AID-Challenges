#include <LiquidCrystal.h>
#include <math.h>
#define trigPin 10
#define echoPin 13

// setup the Thermistor
double Thermistor(int RawADC) {
  double Temp;
  Temp = log(10000.0*((1024.0/RawADC-1))); 
  Temp = 1 / (0.001129148 + (0.000234125 + (0.0000000876741 * Temp * Temp ))
         * Temp );
  Temp = Temp - 273.15;          
  return Temp;
}
// initialize the library by associating any needed LCD interface pin
// with the arduino pin number it is connected to
const int rs = 12, en = 11, d4 = 5, d5 = 4, d6 = 3, d7 = 2;
LiquidCrystal lcd(rs, en, d4, d5, d6, d7);

void setup() {
  Serial.begin(9600); // opens serial port, sets data rate to 9600 bps
  lcd.begin(16, 2); // set up the LCD's number of columns and rows:
  pinMode(trigPin, OUTPUT); pinMode(echoPin, INPUT); // set up the US Sensor
}

void loop() {
  int val0;                
  double temp;            
  val0=analogRead(0);   //connect ultrasonic sensor to Analog 1
  temp=Thermistor(val0);
  
  float duration, distance;
  float spdSnd;
  digitalWrite(trigPin, LOW); 
  delayMicroseconds(2);
 
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  spdSnd = 331.4 + (0.606 * temp) + 0.62;
  distance = (duration / 2) * (spdSnd / 10000);
  
  lcd.setCursor(0,0);
  if (distance >= 400 || distance <= 2){
    lcd.print("Out of range");
    delay(500);
  }
  else {
    Serial.println(distance);
    lcd.print(distance);
    lcd.print(" cm");
    delay(500);
  }
  delay(500);
  lcd.clear();
}
