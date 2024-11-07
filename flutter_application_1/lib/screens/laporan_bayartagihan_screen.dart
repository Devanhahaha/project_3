import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/bayartagihan.dart';
import '../services/api_service.dart';

class LaporanBayarTagihanScreen extends StatelessWidget {
  const LaporanBayarTagihanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Bayar Tagihan'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<Bayartagihan>>(
        future: ApiService().fetchBayartagihanOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            List<Bayartagihan> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                Bayartagihan order = orders[index];
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(order.nama),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Nama: ${order.nama}'),
                      Text('Nomor Kartu: ${order.noTagihan}'),
                      Text('Nominal: ${order.nominal}'),
                      Text('Harga: ${order.harga}'),
                      Text('Jenis Tagihan: ${order.tipeTagihan}'),
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
