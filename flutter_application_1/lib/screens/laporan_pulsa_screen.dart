import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/pulsa.dart';
import '../services/api_service.dart';

class LaporanPulsaScreen extends StatelessWidget {
  const LaporanPulsaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pulsa'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<Pulsa>>(
        future: ApiService().fetchPulsaOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            List<Pulsa> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Pulsa order = orders[index];
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(order.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order.nama}'),
                      Text('Nomor Telp: ${order.noTelp}'),
                      Text('Nominal: ${order.nominal}'),
                      Text('Harga: ${order.harga}'),
                      Text('Tipe Kartu: ${order.tipeKartu}'),
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
