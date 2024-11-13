import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_application_1/services/api_service.dart';
import 'dart:convert';

class ServicesScreen extends StatefulWidget {
  const ServicesScreen({super.key});

  @override
  _ServicesScreenState createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _jenisHpController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // final data = {
      //   'nama': _nameController.text,
      //   'keluhan': _keluhanController.text,
      //   'jenis_hp': _jenisHpController.text,
      //   'kontak': _kontakController.text,
      //   'alamat': _alamatController.text,
      // };

      // Panggil fungsi untuk mengirim data ke API
      // await _sendDataToApi(data);
       final res = await ApiService().submitServicesOrder(_nameController.text, _keluhanController.text, _jenisHpController.text, _kontakController.text, _alamatController.text,);
       if(res){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data berhasil disimpan')),
      );

      // Reset form setelah submit
      _formKey.currentState!.reset();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal')),
          );
    }
    }
  }

  // Future<void> _sendDataToApi(Map<String, String> data) async {
  //   const apiUrl =
  //       'http://127.0.0.1:8000/api/services'; // Ganti dengan URL API Anda
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       headers: <String, String>{
  //         'Content-Type': 'application/json; charset=UTF-8',
  //       },
  //       body: jsonEncode(data),
  //     );

  //     if (response.statusCode == 200 || response.statusCode == 201) {
  //       // Jika data berhasil disimpan
  //       print('Data berhasil disimpan');
  //     } else {
  //       // Jika ada kesalahan dari server
  //       print('Gagal menyimpan data: ${response.statusCode}');
  //     }
  //   } catch (e) {
  //     // Jika ada kesalahan dalam pengiriman request
  //     print('Error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services'),
        automaticallyImplyLeading: false, // Hapus panah back
        backgroundColor: Colors.blueAccent, // Warna AppBar
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Nama
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  labelStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
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

              // Keluhan
              TextFormField(
                controller: _keluhanController,
                decoration: InputDecoration(
                  labelText: 'Keluhan',
                  labelStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan keluhan Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Jenis HP
              TextFormField(
                controller: _jenisHpController,
                decoration: InputDecoration(
                  labelText: 'Jenis HP',
                  labelStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan jenis HP Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Kontak
              TextFormField(
                controller: _kontakController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Kontak',
                  labelStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor kontak Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Alamat
              TextFormField(
                controller: _alamatController,
                decoration: InputDecoration(
                  labelText: 'Alamat',
                  labelStyle: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: const OutlineInputBorder(
                    borderSide:
                        BorderSide(color: Colors.blueAccent, width: 2.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan alamat Anda';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Tombol Submit
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
    );
  }
}
