import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BayarTagihanScreen extends StatefulWidget {
  const BayarTagihanScreen({super.key});

  @override
  _BayarTagihanScreenState createState() => _BayarTagihanScreenState();
}

class _BayarTagihanScreenState extends State<BayarTagihanScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _nomorTagihanController = TextEditingController();
  final _nominalController = TextEditingController();
  String _jenisTagihan = "BPJS"; // Default value for dropdown

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      final data = {
        'nama': _nameController.text,
        'nomor_tagihan': _nomorTagihanController.text,
        'nominal': _nominalController.text,
        'jenis_tagihan': _jenisTagihan,
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
        'http://127.0.0.1:8000/api/bayartagihan'; // Ganti dengan URL API Anda
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // Mengatasi overflow saat keyboard muncul
      appBar: AppBar(
        title: const Text('Bayar Tagihan'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: SingleChildScrollView(
        // Untuk membuat scroll jika konten terlalu panjang
        child: Padding(
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
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide:
                          BorderSide(color: Colors.blueAccent, width: 1.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
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
                  controller: _nomorTagihanController,
                  decoration: InputDecoration(
                    labelText: 'Nomor Tagihan',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
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
                      return 'Masukkan nomor tagihan';
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
                      color: Colors.blueGrey,
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
                DropdownButtonFormField<String>(
                  value: _jenisTagihan,
                  decoration: InputDecoration(
                    labelText: 'Jenis Tagihan',
                    labelStyle: TextStyle(
                      color: Colors.blueGrey,
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
                  items: const [
                    DropdownMenuItem(value: "BPJS", child: Text("BPJS")),
                    DropdownMenuItem(value: "PLN", child: Text("PLN")),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _jenisTagihan = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
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
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
