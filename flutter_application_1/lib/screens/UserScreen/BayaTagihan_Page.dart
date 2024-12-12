import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/UserScreen/Payment_Page.dart';
import 'package:flutter_application_1/services/api_service_cust.dart';

class BayarTagihanPage extends StatefulWidget {
  @override
  _BayarTagihanPageState createState() => _BayarTagihanPageState();
}

class _BayarTagihanPageState extends State<BayarTagihanPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noTagihanController = TextEditingController();
  String? _tipeTagihan;
  int? _selectedNominal;

  // Fungsi untuk menampilkan SnackBar
  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Fungsi untuk submit form
  void _submit() async {
    // Validasi field
    if (_formKey.currentState!.validate()) {
      if (_tipeTagihan == null) {
        showSnackbar('Pilih tipe tagihan');
        return;
      }

      if (_selectedNominal == null) {
        showSnackbar('Pilih nominal tagihan');
        return;
      }

      // Mengirim data tagihan ke API
      bool res = await ApiServiceCust().submitBayartagihanOrder(
        _namaController.text,
        _noTagihanController.text,
        _tipeTagihan ?? 'Tipe Tagihan',
        _selectedNominal?.toDouble() ?? 0.0, // Pastikan nominal adalah double
      );

      if (!res) {
        showSnackbar('Gagal mengirim pesanan pulsa');
        return;
      }

      // Panggil API untuk mendapatkan snapToken
      String? snapToken = await ApiServiceCust().createTokenBayarTagihan(
        nominal: _selectedNominal!,
        name: _namaController.text,
        number: _noTagihanController.text,
        jenisTagihan: _tipeTagihan!,
      );

      if (snapToken == null) {
        showSnackbar('Snap token tidak ditemukan');
        return;
      }

      // Menampilkan halaman pembayaran Midtrans
      _showMidtransPayment(snapToken);
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

    if (result == 'success') {
      showSnackbar('Pembayaran berhasil!');
    } else if (result == 'error') {
      showSnackbar('Pembayaran gagal!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Bayar Tagihan'),
        backgroundColor: Colors.orange,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Input Nama
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Input Nomor Tagihan
              TextFormField(
                controller: _noTagihanController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Tagihan',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nomor tagihan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Dropdown Tipe Tagihan
              DropdownButtonFormField<String>(
                items: ['Listrik', 'Air', 'Internet', 'Telepon']
                    .map((value) => DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _tipeTagihan = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Tipe Tagihan',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih tipe tagihan';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              
              // Dropdown Nominal
              DropdownButtonFormField<int>(
                items: [50000, 100000, 150000, 200000, 250000]
                    .map((value) => DropdownMenuItem<int>(
                          value: value,
                          child: Text('Rp $value'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedNominal = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: 'Nominal',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null) {
                    return 'Pilih nominal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              
              // Tombol Submit
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
