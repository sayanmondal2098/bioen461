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
  //average over a 
  int samples[21];
  int sum = 0;
  for(int i = 0; i < 21; i = i+1){
    samples[i] = analogRead(A0);
    sum = sum+ analogRead(A0);
  }
  float avg = sum/20.0;
  int mvc = 400;
  avg = avg / 400;
  
  if(avg > 0.5)
  { 
            myservo.write(avg * 180); 
  } 
  else{
    myservo.writeMicroseconds(0);
  }
  Serial.println(avg); 
}
