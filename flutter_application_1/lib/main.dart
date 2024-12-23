import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/splash_screen.dart';
import 'package:flutter_application_1/screens/login_screen.dart';
import 'package:flutter_application_1/screens/UserScreen/user_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'package:flutter_application_1/providers/cart_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesHelper.instance.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyServiceApp(),
    ),
  );
}

class MyServiceApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    String userType = PreferencesHelper.instance.userType ?? 'guest';
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEVAN CELL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/', 
      routes: {
        '/': (context) => SplashScreen(),
        '/home': (context) => const HomeScreen(),
        '/user': (context) =>  UserScreen(role: '$userType'),
        '/login': (context) => LoginScreen(),
      },
    );
  }
}
