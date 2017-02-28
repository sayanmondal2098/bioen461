#include <Servo.h>

Servo myservo;
bool firstAct = false;// boolean for receiving muscle activation
bool secAct = false;
bool closed = true; // inital condition is closed grip 
bool opened = false; 
int count = 0;
int threshold = 10;
void setup()
{
  myservo.attach(9); // for servo_2
}

void loop() {
  int sensorValue = analogRead(A0); // reading signal from myoware
  Serial.println(sensorValue);
  //  recognizing the first activation
  while(sensorValue > threshold) {
    sensorValue = analogRead(A0); 
    firstAct = true;
  }
  // recognizing the gap between first and second activation
  while(sensorValue < threshold && firstAct) {
    sensorValue = analogRead(A0);
  }
  // recognizing the second activation
  while(sensorValue > threshold) {
    sensorValue = analogRead(A0);
    firstAct = false;
    secAct = true;
  }
  // produce control signal 
  if(secAct) {
    if (closed) {
      myservo.writeMicroseconds(1000);
      delay(3000); // delay for myservo to finish turning
      myservo.writeMicroseconds(1500);
      opened = true;
      closed = false;
    } else if (opened) {
      myservo.writeMicroseconds(2000);
      delay(3000); // delay for myservo to finish turning
      myservo.writeMicroseconds(1500);
      opened = false;
      closed = true;
    }
  }
  delay(200);
  secAct = false; // reset the whole control system 
}

