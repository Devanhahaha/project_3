import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Gambar background teknologi
          // Container(
          //   // decoration: const BoxDecoration(
          //   //   // image: DecorationImage(
          //   //   //   // image: AssetImage('assets/images/tech-background.jpg'),
          //   //   //   fit: BoxFit.cover,
          //   //   // ),
          //   // ),
          // ),
          // Overlay untuk efek semi-transparan
          Container(
            color: Colors.blue.withOpacity(0.6),
          ),
          // Konten utama
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo-tab.png', height: 100),
                const Text(
                  'Welcome To DEVAN CELL',
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // warna tombol login
                  ),
                  child: const Text('Login'),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white, // warna tombol register
                  ),
                  child: const Text('Register'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
