import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/product.dart';
import 'package:flutter_application_1/screens/UserScreen/Payment_Page.dart';
import 'package:flutter_application_1/utils/const.dart'; 
import 'package:flutter_application_1/services/api_service.dart' as api; // Pastikan submitOrder didefinisikan di sini

class CheckoutScreen extends StatefulWidget {
  final Product? product;
  final quantity;

  const CheckoutScreen({Key? key, this.product, this.quantity}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _alamatController = TextEditingController();
  final _noHpController = TextEditingController();
  final _catatanController = TextEditingController();
  final _kurirController = TextEditingController();
  final _provinsiController = TextEditingController();
  final _kabupatenController = TextEditingController();

  bool _isSubmitting = false;

  // Fungsi untuk submit order
  Future<void> _submitOrder() async {
  setState(() {
    _isSubmitting = true;
  });

  try {
    // Mengambil data dari form
    String alamat = _alamatController.text;
    String noHp = _noHpController.text;
    String catatan = _catatanController.text;
    String kurir = _kurirController.text;
    String provinsi = _provinsiController.text;
    String kabupaten = _kabupatenController.text;
    double ongkir = 5000; // Biaya ongkir tetap
    List<int> productIds = [widget.product!.id];
    List<int> quantities = [widget.quantity]; // Misalnya, hanya 1 produk
    List<int> subTotals = [ (widget.product!.nominal * widget.quantity).toInt() ];;
    String paymentMethod = 'COD'; // Pilihan metode pembayaran

    // Panggil fungsi submitOrder dari ApiService
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

    // Tambahkan ongkir ke totalAmount
    int totalAmount = subTotals.reduce((a, b) => a + b) + ongkir.toInt();
    // Buat Snap Token
    String? snapToken = await api.ApiService().createTokenOrder(
      phone: _noHpController.text,
      totalAmount: totalAmount, 
    );

    print('init snap token : ${snapToken}');

    if (snapToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Snap token tidak ditemukan')),
      );
      return;
    }

    // Panggil Midtrans Payment
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


  // Fungsi untuk menampilkan halaman pembayaran Midtrans
  void _showMidtransPayment(String snapToken) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(snapToken: snapToken),
        
      ),
      
    );
print("Snap Token diterima dengan total: ${snapToken}");
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
     int subtotal = ((widget.product?.nominal ?? 0) * (widget.quantity ?? 1)).toInt();

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
              // Menampilkan gambar produk
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
                      // Menampilkan gambar produk
                      Image.network(
                        Uri.encodeFull('$host/${widget.product?.gambar ?? 'default.jpg'}'),
                        height: 200, // Ukuran gambar
                        width: double.infinity, // Lebar gambar memenuhi kontainer
                        fit: BoxFit.cover, // Gambar menyesuaikan ukuran
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.product?.namaProduct ?? 'Nama Produk',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Jenis: ${widget.product?.jenis ?? 'N/A'}',
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Harga: Rp ${subtotal ?? 0}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Form pengiriman
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
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text('$value'),
                        ))
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Pilih kurir';
                  }
                  return null;
                },
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

              // Tombol untuk memproses checkout
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
    );
  }
}
