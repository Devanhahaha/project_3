import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_application_1/screens/UserScreen/user_screen.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'package:flutter_application_1/utils/preferences_helper.dart';
import 'package:flutter_application_1/providers/cart_provider.dart'; 
import 'screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesHelper.instance.init();

  // Mengambil userType dari SharedPreferences
  String userType = PreferencesHelper.instance.userType ?? 'guest';

  runApp(
    MultiProvider(
      providers: [
        // Add CartProvider here
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyServiceApp(userType: userType),
    ),
  );
}

class MyServiceApp extends StatelessWidget {

  final String userType;

  const MyServiceApp({super.key, required this.userType});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'DEVAN CELL',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PreferencesHelper.instance.accessToken != null 
        ? (userType == 'admin' ? const HomeScreen() : const UserScreen()) // Menampilkan Dashboard jika user admin
        : const AuthScreen(),  // Jika belum login, tampilkan AuthScreenn
    );
  }
}
