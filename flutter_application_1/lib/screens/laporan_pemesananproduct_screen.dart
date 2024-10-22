import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productcust.dart';
import '../services/api_service.dart';

class LaporanPemesananProductScreen extends StatelessWidget {
  const LaporanPemesananProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pemesanan Product'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: FutureBuilder<List<ProductCust>>(
        future: ApiService().fetchProductCustOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Tidak ada data'));
          } else {
            List<ProductCust> orders = snapshot.data ?? [];
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                ProductCust order = orders[index];
                return ListTile(
                  leading: const Icon(Icons.phone_android),
                  title: Text(order.noHp),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('No HP: ${order.noHp}'),
                      Text('Alamat: ${order.alamat}'),
                      Text('Catatan: ${order.catatan}'),
                      Text('Provinsi: ${order.provinsi}'),
                      Text('Kabupaten: ${order.kabupaten}'),
                      Text('Ongkir: ${order.ongkir}'),
                      Text('Kurir: ${order.kurir}'),
                      Text('Quantity: ${order.quantity}'),
                      Text('Subtotal: ${order.subTotal}'),
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
