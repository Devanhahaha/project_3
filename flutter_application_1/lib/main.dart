import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
// import 'screens/login_screen.dart'; 

void main() {
  runApp(const MyServiceApp());
}

class MyServiceApp extends StatelessWidget {
  const MyServiceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEVAN CELL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const AuthScreen(), // Mulai dari layar AuthScreen
    );
  }
}
