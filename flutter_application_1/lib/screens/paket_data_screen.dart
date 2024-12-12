import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/api_service.dart';

class PaketDataScreen extends StatefulWidget {
  const PaketDataScreen({super.key});

  @override
  _PaketDataScreenState createState() => _PaketDataScreenState();
}

class _PaketDataScreenState extends State<PaketDataScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  String _jenisKartu = "";
  String? _selectedPaket;

  final Map<String, List<String>> paketDataOptions = {
    'Telkomsel': [
      '10GB - Rp. 50.000',
      '1.5GB - Rp. 20.000',
      '14GB - Rp. 75.000'
    ],
    'Indosat': ['90GB - Rp. 100.000', '30GB - Rp. 50.000', '10GB - Rp. 25.000'],
    'Axis': ['1.5GB - Rp. 15.000', '3GB - Rp. 25.000', '10GB - Rp. 50.000'],
    'XL': ['66GB - Rp. 70.000', '186GB - Rp. 150.000', '122GB - Rp. 120.000'],
    'Three': ['9GB - Rp. 45.000', '42GB - Rp. 90.000', '30GB - Rp. 75.000'],
    'Lainnya': []
  };

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
      _selectedPaket = null; // Reset selected package when card type changes
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate() && _selectedPaket != null) {
      final res = await ApiService().submitPaketdataOrder(
        _nameController.text,
        _phoneController.text,
        _selectedPaket!,
        _jenisKartu,
      );

      if (res) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data berhasil disimpan')),
        );
        _formKey.currentState!.reset();
        setState(() {
          _selectedPaket = null;
          _jenisKartu = "";
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pilih paket data terlebih dahulu')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('Paket Data'), backgroundColor: Colors.blueAccent),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Name and Phone fields remain the same
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
              // Paket Data Dropdown
              DropdownButtonFormField<String>(
                value: _selectedPaket,
                items: paketDataOptions[_jenisKartu]?.map((paket) {
                  return DropdownMenuItem(value: paket, child: Text(paket));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaket = value;
                  });
                },
                decoration: InputDecoration(
                  labelText: 'Nominal/Paket Data',
                  border: OutlineInputBorder(),
                  contentPadding: const EdgeInsets.all(12.0),
                ),
                validator: (value) {
                  if (value == null) return 'Pilih paket data';
                  return null;
                },
              ),
              const SizedBox(height: 16.0),

              // Display selected card type
              Text('Jenis Kartu: $_jenisKartu'),

              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent),
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
