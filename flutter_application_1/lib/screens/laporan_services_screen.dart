import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/services.dart';
import '../services/api_service.dart';

class LaporanServicesScreen extends StatelessWidget {
  const LaporanServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Services'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<Services>>(
        future: ApiService().fetchServicesOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            List<Services> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Services order = orders[index];
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(order.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order.nama}'),
                      Text('Keluhan: ${order.keluhan}'),
                      Text('Jenis_HP: ${order.jenisHp}'),
                      Text('Kontak: ${order.kontak}'),
                      Text('Alamat: ${order.alamat}'),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
