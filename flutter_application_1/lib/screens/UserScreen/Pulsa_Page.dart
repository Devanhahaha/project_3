import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/UserScreen/Payment_Page.dart';
// import 'package:flutter_application_1/services/api_service.dart';
import 'package:flutter_application_1/services/api_service_cust.dart';

class PulsaPage extends StatefulWidget {
  @override
  _PulsaPageState createState() => _PulsaPageState();
}

class _PulsaPageState extends State<PulsaPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _jenisKartu = ""; 
  int? _selectedNominal;

  // Fungsi untuk memvalidasi dan mengirim data ke API
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedNominal == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih nominal terlebih dahulu')),
        );
        return;
      }

      double nominalInDouble = _selectedNominal?.toDouble() ?? 0.0;

      // Kirim data ke API Laravel untuk transaksi pulsa
      bool isPulsaOrderSubmitted = await ApiServiceCust().submitPulsaOrderCust(
        _nameController.text,
        _phoneController.text,
        nominalInDouble,
        _jenisKartu,
      );

      if (!isPulsaOrderSubmitted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim pesanan pulsa')),
        );
        return;
      }

      // panggil api token
      String? snapToken = await ApiServiceCust().createTokenPulsa(
        name: _nameController.text, 
        phone: _phoneController.text, 
        nominal: _selectedNominal!,
      );

      if (snapToken == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Snap token tidak di temukan')),
        );
        return;
      }
      _showMidtransPayment(snapToken);
    }
  }

  // Fungsi untuk mendapatkan tipe kartu berdasarkan nomor
  String _getTipeKartu(String nomor) {
    if (nomor.startsWith('0811') || nomor.startsWith('0812') || nomor.startsWith('0813')) {
      return 'Telkomsel';
    } else if (nomor.startsWith('0857') || nomor.startsWith('0858')) {
      return 'Indosat';
    } else if (nomor.startsWith('0817') || nomor.startsWith('0818') || nomor.startsWith('0819')) {
      return 'XL';
    } else if (nomor.startsWith('0896') || nomor.startsWith('0897') || nomor.startsWith('0898')) {
      return 'Tri';
    } else if (nomor.startsWith('0838') || nomor.startsWith('0831')) {
      return 'Axis';
    } else {
      return 'Tipe kartu tidak ditemukan';
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Pulsa'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
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
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    _jenisKartu = _getTipeKartu(value);
                  });
                },
              ),
              const SizedBox(height: 10),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Tipe Kartu',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(text: _jenisKartu),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                items: [5000, 10000, 25000, 50000, 100000]
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
                value: _selectedNominal,
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
              ElevatedButton(
                onPressed: _submit,
                child: const Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
