import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/UserScreen/Payment_Page.dart';
import '../../services/api_service_cust.dart';

class PaketDataPage extends StatefulWidget {
  @override
  _PaketDataPageState createState() => _PaketDataPageState();
}

class _PaketDataPageState extends State<PaketDataPage> {
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

  String _getTipeKartu(String nomor) {
    if (nomor.startsWith('0811') || nomor.startsWith('0812') || nomor.startsWith('0813')) {
      return 'Telkomsel';
    } else if (nomor.startsWith('0857') || nomor.startsWith('0858')) {
      return 'Indosat';
    } else if (nomor.startsWith('0817') || nomor.startsWith('0818') || nomor.startsWith('0819')) {
      return 'XL';
    } else if (nomor.startsWith('0896') || nomor.startsWith('0897') || nomor.startsWith('0898')) {
      return 'Three';
    } else if (nomor.startsWith('0838') || nomor.startsWith('0831')) {
      return 'Axis';
    } else {
      return 'Lainnya';
    }
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {

      if (_selectedPaket == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pilih nominal terlebih dahulu')),
        );
        return;
      }

      bool isPaketDataOrderSubmitted  = await ApiServiceCust().submitPaketdataOrderCust(
        _nameController.text,
        _phoneController.text,
        _selectedPaket!,
        _jenisKartu,
      );

      if (!isPaketDataOrderSubmitted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengirim pesanan pulsa')),
        );
        return;
      }

      String? snapToken = await ApiServiceCust().createTokenPaketData(
        name: _nameController.text, 
        number: _phoneController.text,
        jenis : _jenisKartu, 
        nominal: _selectedPaket!,
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
        title: Text('Form Paket Data'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Nomor Telepon',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  setState(() {
                    _jenisKartu = _getTipeKartu(value);
                    _selectedPaket = null; // Reset pilihan paket data
                  });
                },
              ),
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Tipe Kartu',
                  border: OutlineInputBorder(),
                ),
                readOnly: true,
                controller: TextEditingController(text: _jenisKartu),
              ),
              SizedBox(height: 10),
              DropdownButtonFormField<String>(
                items: (paketDataOptions[_jenisKartu] ?? [])
                    .map((value) => DropdownMenuItem(
                          value: value,
                          child: Text(value),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPaket = value;
                  });
                },
                value: _selectedPaket,
                decoration: InputDecoration(
                  labelText: 'Paket Data',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null ? 'Pilih paket data' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Simpan'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
