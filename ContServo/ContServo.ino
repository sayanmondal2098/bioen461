#include <Servo.h> 

Servo myservo;

void setup() 
{
  myservo.attach(9); // for servo_2
} 

void loop() {
  int threshold = 10; // threshold for EMG signal 
  int sensorValue = analogRead(A0); // reading signal from myoware
  Serial.println(sensorValue); 
//  control system 
  if (sensorValue > threshold) {
    myservo.writeMicroseconds(2000); 
    
  } else {
    myservo.writeMicroseconds(1000); 
  }
  
  delay(1000) 
} 

