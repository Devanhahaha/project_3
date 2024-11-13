import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/productcust.dart';
import 'package:flutter_application_1/utils/const.dart';
import '../services/api_service.dart';

class LaporanPemesananProductScreen extends StatelessWidget {
  const LaporanPemesananProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Laporan Pemesanan Product'),
        automaticallyImplyLeading: false, // Remove back arrow
        backgroundColor: Colors.blueAccent, // AppBar color
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
            List<ProductCust> orders = snapshot.data!;
            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                ProductCust order = orders[index];
                // Image URL encoding
                String? imageUrl;
                if (order.product != null && order.product!.gambar.isNotEmpty) {
                  imageUrl = Uri.encodeFull('$host/${order.product!.gambar}');
                }
                return ListTile(
                  leading: imageUrl != null
                      ? Image.network(
                          imageUrl,
                          width: 50,
                          height: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image_not_supported, size: 50),
                  title: Text(order.product?.namaProduct ?? 'No Product Name Available'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (order.product != null) ...[
                        Text('Jenis: ${order.product!.jenis}'),
                        Text('Merk: ${order.product!.merk}'),
                        Text('Deskripsi: ${order.product!.deskripsi}'),
                      ] else
                        const Text('No product details available'),
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
