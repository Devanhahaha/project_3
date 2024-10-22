import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PulsaScreen extends StatefulWidget {
  const PulsaScreen({super.key});

  @override
  _PulsaScreenState createState() => _PulsaScreenState();
}

class _PulsaScreenState extends State<PulsaScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _nominalController = TextEditingController();
  String _jenisKartu = "";

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _nameController.text,
        'nomor_telepon': _phoneController.text,
        'nominal': _nominalController.text,
        'jenis_kartu': _jenisKartu,
      };

      // Panggil fungsi untuk mengirim data ke API
      await _sendDataToApi(data);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );

      // Reset form setelah submit
      _formKey.currentState!.reset();
    }
  }

  Future<void> _sendDataToApi(Map<String, String> data) async {
    const apiUrl =
        'http://127.0.0.1:8000/api/pulsa'; // Ganti dengan URL API Anda
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        // Jika data berhasil disimpan
        print('Data berhasil disimpan');
      } else {
        // Jika ada kesalahan dari server
        print('Gagal menyimpan data: ${response.statusCode}');
      }
    } catch (e) {
      // Jika ada kesalahan dalam pengiriman request
      print('Error: $e');
    }
  }

  void _updateJenisKartu() {
    setState(() {
      if (_phoneController.text.startsWith('0811') ||
          _phoneController.text.startsWith('0812')) {
        _jenisKartu = 'Telkomsel';
      } else if (_phoneController.text.startsWith('0856') ||
          _phoneController.text.startsWith('0857')) {
        _jenisKartu = 'Indosat';
      } else if (_phoneController.text.startsWith('0831') ||
          _phoneController.text.startsWith('0832')) {
        _jenisKartu = 'Axis';
      } else if (_phoneController.text.startsWith('0871') ||
          _phoneController.text.startsWith('0877')) {
        _jenisKartu = 'XL';
      } else {
        _jenisKartu = 'Lainnya';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pulsa'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey, // Warna label teks
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nama Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey, // Warna label teks
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  _updateJenisKartu();
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor telepon';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _nominalController,
                decoration: InputDecoration(
                  labelText: 'Nominal',
                  labelStyle: TextStyle(
                    color: Colors.blueGrey, // Warna label teks
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.blueAccent,
                      width: 2.0,
                    ),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nominal';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              Text(
                'Jenis Kartu: $_jenisKartu',
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.blueAccent,
                ),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Warna tombol
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // Warna teks tombol
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
