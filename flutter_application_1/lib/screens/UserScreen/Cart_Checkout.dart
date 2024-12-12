import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/UserScreen/Payment_Page.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:flutter_application_1/services/api_service.dart' as api;
import 'package:flutter_application_1/models/cartitem.dart';

class CartCheckout extends StatefulWidget {
  final List<CartItem> products; 

  const CartCheckout({Key? key, required this.products}) : super(key: key);

  @override
  _CartCheckoutState createState() => _CartCheckoutState();
}

class _CartCheckoutState extends State<CartCheckout> {
  final _alamatController = TextEditingController();
  final _noHpController = TextEditingController();
  final _catatanController = TextEditingController();
  final _kurirController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _kabupatenController = TextEditingController();

  bool _isSubmitting = false;

  // Fungsi untuk menghitung total harga produk
  int _calculateTotalAmount() {
    int total = widget.products.fold(0, (sum, product) => sum + product.price);
    int ongkir = 5000;  // Ongkos kirim
    return total + ongkir;
  }

  Future<void> _submitOrder() async {
    setState(() {
      _isSubmitting = true;
    });

    try {
      String alamat = _alamatController.text;
      String noHp = _noHpController.text;
      String catatan = _catatanController.text;
      String kurir = _kurirController.text;
      String provinsi = _provinsiController.text;
      String kabupaten = _kabupatenController.text;
      double ongkir = 5000;  // Ongkos kirim

      List<int> productIds = widget.products.map((product) => product.productId).toList();
      List<int> quantities = widget.products.map((product) => 1).toList(); // Asumsikan jumlah produk 1
      List<int> subTotals = widget.products.map((product) => (product.price * 1).toInt()).toList(); // Asumsikan harga produk * 1 quantity
      String paymentMethod = 'COD';

      bool success = await api.ApiService.submitOrder(
        alamat,
        noHp,
        catatan,
        kurir,
        provinsi,
        kabupaten,
        ongkir,
        productIds,
        quantities,
        subTotals,
        paymentMethod,
      );

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal melakukan order')),
        );
        return;
      }

      int totalAmount = subTotals.reduce((a, b) => a + b) + ongkir.toInt();
      String? snapToken = await api.ApiService().createTokenOrder(
        phone: _noHpController.text,
        totalAmount: totalAmount,
      );

      if (snapToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Snap token tidak ditemukan')),
        );
        return;
      }

      _showMidtransPayment(snapToken);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  void _showMidtransPayment(String snapToken) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(snapToken: snapToken),
      ),
    );

    if (result == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran berhasil!')),
      );
    } else if (result == 'error') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pembayaran gagal!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    int totalAmount = _calculateTotalAmount();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display selected products
              ...widget.products.map((product) {
                int subtotal = product.price;

                return Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(
                          Uri.encodeFull('$host/${product.imageUrl}'),
                          height: 200,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          product.productName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Harga: Rp $subtotal',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),
              const Text(
                'Alamat Pengiriman',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat Lengkap',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noHpController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _catatanController,
                decoration: InputDecoration(
                  labelText: 'Catatan',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                items: ['JNE', 'TIKI', 'POS']
                    .map((value) => DropdownMenuItem<String>(value: value, child: Text(value)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _kurirController.text = value ?? '';
                  });
                },
                value: _kurirController.text.isNotEmpty ? _kurirController.text : null,
                decoration: const InputDecoration(
                  labelText: 'Kurir',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _provinsiController,
                decoration: InputDecoration(
                  labelText: 'Provinsi',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _kabupatenController,
                decoration: InputDecoration(
                  labelText: 'Kabupaten',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              // Card for Total Price and Order Confirmation Button
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Harga: Rp $totalAmount',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _isSubmitting
                          ? const Center(child: CircularProgressIndicator())
                          : ElevatedButton(
                              onPressed: _submitOrder,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                textStyle: const TextStyle(fontSize: 16),
                              ),
                              child: const Text('Konfirmasi Pesanan', style: TextStyle(color: Colors.white)),
                            ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
