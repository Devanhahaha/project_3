import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'user_layanan.dart';
import 'User_Product.dart';
import 'user_dashboard.dart';
import '../login_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  int _currentIndex = 1;

  // Daftar halaman untuk navigasi
  final List<Widget> _pages = [
    UserLayanan(),
    UserDashboard(),
    UserProduct(),
  ];

  void _logout() {
    // Navigasi ke LoginScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LoginScreen(),
      ),
    );
  }

  // Fungsi menampilkan dialog konfirmasi logout
  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Konfirmasi Logout'),
          content: Text('Apakah Anda yakin ingin logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text('Tidak'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
                _logout(); // Lakukan logout
              },
              child: Text('Ya'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.blueAccent,
        color: Colors.white,
        buttonBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        height: 60,
        animationDuration: Duration(milliseconds: 300),
        index: _currentIndex,
        items: [
          Icon(Icons.build,
              size: 20, color: const Color.fromARGB(255, 0, 0, 0)), // Pulsa
          Icon(Icons.dashboard,
              size: 20,
              color: const Color.fromARGB(255, 32, 32, 32)), // Layanan
          Icon(Icons.shopping_cart,
              size: 20,
              color: const Color.fromARGB(255, 26, 26, 26)), // Product
          Icon(Icons.logout,
              size: 20, color: const Color.fromARGB(255, 255, 0, 0)),
        ],
        onTap: (index) {
          if (index == 3) {
            _showLogoutDialog();
          } else {
            setState(() {
              _currentIndex = index; // Ubah halaman dengan mengatur indeks
            });
          }
        },
      ),
    );
  }
}
