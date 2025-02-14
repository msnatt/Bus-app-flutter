// global.dart
library global;

String globalVar = "Hello, World!"; // ตัวแปร global

int maxroundCall = 1;
int roundCall = 0;

// หรือสามารถใช้ global function ได้
int GetroundCall() {
  return roundCall;
}
void AddroundCall(int x){
  roundCall += x;
}
void SetroundCall(int x){
  roundCall = x;
}
int Getmaxroundcall() {
  return maxroundCall;
}
