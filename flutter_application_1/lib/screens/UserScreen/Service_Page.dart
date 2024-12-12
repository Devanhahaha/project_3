import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_application_1/services/api_service.dart'; 

class ServicePage extends StatefulWidget {
  @override
  _ServicePageState createState() => _ServicePageState();
}

class _ServicePageState extends State<ServicePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _keluhanController = TextEditingController();
  final TextEditingController _jenisHpController = TextEditingController();
  final TextEditingController _kontakController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  
  bool _isSubmitted = false; // Status submit

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Simulasikan pengiriman data
      setState(() {
        _isSubmitted = false; // Menjaga state form sebelum melakukan submit
      });

      bool isSuccess = await ApiService().submitServicesOrder(
        _nameController.text, 
        _keluhanController.text, 
        _jenisHpController.text, 
        _kontakController.text, 
        _alamatController.text,
      );

      if (isSuccess) {
        setState(() {
          _isSubmitted = true; // Status submit berhasil
        });
      } else {
        setState(() {
          _isSubmitted = false; // Jika submit gagal
        });
      }

      // Reset form setelah submit
      _formKey.currentState!.reset();
      _nameController.clear();
      _keluhanController.clear();
      _jenisHpController.clear();
      _kontakController.clear();
      _alamatController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Service'),
        backgroundColor: Colors.blueAccent,
      ),
      body: AnimatedContainer(
        duration: const Duration(seconds: 1), // Durasi animasi perubahan warna
        color: _isSubmitted ? Colors.green : Colors.white, // Warna latar belakang berubah setelah submit
        child: Column(
          children: [
            // Cek apakah sudah submit, jika belum tampilkan form, jika sudah tampilkan animasi
            _isSubmitted
                ? Expanded(
                    flex: 2, // Memberikan lebih banyak ruang untuk animasi
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Lottie.asset(
                            'assets/images/success.json', // Pastikan path benar
                            width: 150, 
                            height: 150,
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 50.0), // Sesuaikan padding
                            child: const Text(
                              'Kami akan mengirimkan pihak kami ke alamat anda pastikan data yang anda masukkan sesuai!!!',
                              style: TextStyle(fontSize: 18, color: Colors.white),
                              textAlign: TextAlign.center, // Menambahkan textAlign ke sini
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0), // Padding di sekitar form
                      child: SingleChildScrollView(
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  labelText: 'Nama',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'Nama wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _keluhanController,
                                decoration: const InputDecoration(
                                  labelText: 'Keluhan',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 3,
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'Keluhan wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _jenisHpController,
                                decoration: const InputDecoration(
                                  labelText: 'Jenis HP',
                                  border: OutlineInputBorder(),
                                ),
                                validator: (value) => value == null || value.isEmpty
                                    ? 'Jenis HP wajib diisi'
                                    : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _kontakController,
                                decoration: const InputDecoration(
                                  labelText: 'Kontak (No. HP)',
                                  border: OutlineInputBorder(),
                                ),
                                keyboardType: TextInputType.phone,
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'Kontak wajib diisi' : null,
                              ),
                              const SizedBox(height: 10),
                              TextFormField(
                                controller: _alamatController,
                                decoration: const InputDecoration(
                                  labelText: 'Alamat',
                                  border: OutlineInputBorder(),
                                ),
                                maxLines: 2,
                                validator: (value) =>
                                    value == null || value.isEmpty ? 'Alamat wajib diisi' : null,
                              ),
                              const SizedBox(height: 20),
                              Center(
                                child: ElevatedButton(
                                  onPressed: _submit,
                                  child: const Text('Simpan'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blueAccent,
                                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
