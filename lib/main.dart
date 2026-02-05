
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';

void main() {
  runApp(const RentGoApp());
}

class RentGoApp extends StatelessWidget {
  const RentGoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'RentGo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const LoginScreen(),
    );
  }
}