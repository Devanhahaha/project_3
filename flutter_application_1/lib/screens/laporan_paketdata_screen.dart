import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/paketdata.dart';
import '../services/api_service.dart';

class LaporanPaketdataScreen extends StatelessWidget {
  const LaporanPaketdataScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Paket Data'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<Paketdata>>(
        future: ApiService().fetchPaketdataOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            List<Paketdata> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Paketdata order = orders[index];
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(order.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order.nama}'),
                      Text('Nomor Telp: ${order.noTelp}'),
                      Text('Nominal: ${order.nominal}'),
                      Text('Tipe Kartu: ${order.tipeKartu}'),
                      Text('Harga: ${order.harga}'),
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
