import 'package:flutter/material.dart';
import 'package:my_appbus/screen/logo.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: "My Title",
      home: Scaffold(
        backgroundColor: Color(0xFFD6F1FF),
        body: SplashScreen(),
        //body: PinCodeWidget(),
        //body: MenuScreen(ipAddress: "49.0.69.152:4491"),
        //body: Bus(ipAddress: "49.0.69.152:4491"),
      ),
    );
  }
}
