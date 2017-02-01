#include <Servo.h> 
Servo myservo;
const int threshValue = 250;
void setup() 
{ 
  myservo.attach(9);
  Serial.begin(9600);
} 

void loop() 
{ 
  int samples[21];
  int sum = 0;
  for(int i = 0; i < 21; i = i+1){
//    samples[i] = analogRead(A0);
    sum += analogRead(A3);
  }
  
  float avg = sum/20.0;
  int mvc = 10;
  avg = avg / mvc;
  
  if(avg > 16)
  { 
    myservo.write(180); 
  } 
  else{
    myservo.write(0);
  }
  delay(100);
  Serial.println(avg); 
}
