//#include <Servo.h> 
//Servo myservo;
//const int threshValue = 250;
void setup() 
{ 
  //myservo.attach(9);
  Serial.begin(9600);
} 

void loop() 
{ 
//  int samples[21];
//  int sum = 0;
//  int max = 0;
//  for(int i = 0; i < 21; i = i+1){
//    samples[i] = analogRead(A0);
  int a = analogRead(A0);
//    if (a > max){
//        max = a;
//    }
//    sum += a;
    
//  }
  
//  float avg = sum/20.0;
//  int mvc = 10;
//  a = a / mvc;
//  
//  if(a > 16)
//  { 
//    myservo.write(0); 
//  } 
//  else{
//    myservo.write(0);
//  }
  //delay(100);
  int value = a * 5 / 1023; 
  Serial.println(value); 
  delay(1);
}
