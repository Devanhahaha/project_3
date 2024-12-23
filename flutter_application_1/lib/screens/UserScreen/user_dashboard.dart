import 'package:flutter/material.dart';

class UserDashboard extends StatelessWidget {
  final String role;

  // Tambahkan parameter role pada konstruktor
  const UserDashboard({Key? key, required this.role}) : super(key: key);
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 255, 255, 255),
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Nama Aplikasi (Enhanced with Blue Gradient)
            Stack(
              alignment: Alignment.center,
              children: [
                // Bayangan teks untuk efek tiga dimensi
                Text(
                  'DEVACOM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade200,
                    letterSpacing: 2,
                  ),
                ),
                // Teks utama
                Text(
                  'DEVACOM',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Colors.lightBlueAccent,
                          Colors.blue,
                          Colors.indigo,
                        ],
                      ).createShader(Rect.fromLTWH(0.0, 0.0, 200.0, 70.0)),
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

           // Welcome User 
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, $role!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are delighted to have you back. Explore and enjoy our services!',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey[700],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Tentang Kami
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Tentang Kami',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10),
                    SingleChildScrollView(
                      child: Text(
                        'DevanCell adalah aplikasi yang dirancang untuk mempermudah '
                        'kebutuhan digital Anda, mulai dari pembelian pulsa, paket data, '
                        'pembayaran tagihan, hingga pengiriman barang. '
                        'Kami berdedikasi untuk memberikan layanan yang cepat, aman, dan terpercaya.',
                        style: TextStyle(fontSize: 16, color: Colors.grey[800]),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Footer
            SizedBox(height: 20),
            Text(
              '© 2024 Devacom. All rights reserved.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
