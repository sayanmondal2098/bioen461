unsigned long time;
int greenPin = 5;
int redPin = 3;
int activationPin = 6;

#include "Servo.h"
Servo myservo;  // create servo object to control a servo

void setup()
{
  pinMode(greenPin, OUTPUT);
  pinMode(redPin, OUTPUT);
  pinMode(activationPin, OUTPUT);
  myservo.attach(A0);
  Serial.begin(9600);
}

void loop()
{
  int sensorValue = analogRead(A2);
  Serial.println(sensorValue);
  int threshold = 10;
//  float voltage = sensorValue * (5.000 / 1023.000);
  time = millis();
  if(time >= 3000){ // wait for 3 second before allowing control 
    digitalWrite(redPin, LOW);
    digitalWrite(greenPin, HIGH);
    if(sensorValue > threshold){
      myservo.write(180);
      digitalWrite(activationPin, HIGH);
    }
    else{
      myservo.write(0);
      digitalWrite(activationPin, LOW);
    }
  }
  else{
    digitalWrite(redPin, HIGH);
  }
  delay(100);
//   Serial.print(time);
//   Serial.print(",");

}

//void controlServo(int sensorValue, int threshold)
//{
  // Serial.println(sensorValue);
   //if(sensorValue > threshold){
   // digitalWrite(activationPin, HIGH);
   // myoservo.write(180);
   //}
   //else{
    //digitalWrite(activationPin, LOW);
    //myoservo.write(180);
  // }
//   Serial.print('\n'); 
   //Serial.println(sensorValue);
  // delay(500);
//}

