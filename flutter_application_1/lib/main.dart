import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/dashboard_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'screens/auth_screen.dart';
// import 'screens/login_screen.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesHelper.instance.init();
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
      home: PreferencesHelper.instance.accessToken != null ? const HomeScreen() : const AuthScreen(), // Mulai dari layar AuthScreen
    );
  }
}
