import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import '../models/product.dart';
import 'package:flutter_application_1/utils/const.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class EditProductScreen extends StatefulWidget {
  final Product product;

  EditProductScreen({required this.product});

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _namaProduct;
  late String _jenis;
  late String _merk;
  late String _deskripsi;
  late int _stok;
  late int _nominal;

  @override
  void initState() {
    super.initState();
    _namaProduct = widget.product.namaProduct;
    _jenis = widget.product.jenis;
    _merk = widget.product.merk;
    _deskripsi = widget.product.deskripsi;
    _stok = widget.product.stok;
    _nominal = widget.product.nominal;
  }

  Future<void> _updateProduct() async {
    final response = await http.put(
      Uri.parse('$host/api/product/${widget.product.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: json.encode({
        'namaProduct': _namaProduct,
        'jenis': _jenis,
        'merk': _merk,
        'deskripsi': _deskripsi,
        'stok': _stok,
        'nominal': _nominal,
      }),
    );

    if (response.statusCode == 200) {
      log('Product updated successfully');
      Navigator.pop(context);
      Alert(
        context: context,
        title: "Success",
        desc: "Product updated successfully!",
        type: AlertType.success,
      ).show();
    } else {
      log('Failed to update product');
      Alert(
        context: context,
        title: "Error",
        desc: "Failed to update product.",
        type: AlertType.error,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Menambahkan SingleChildScrollView untuk mengatasi overflow
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: _namaProduct,
                  decoration: InputDecoration(labelText: 'Nama Product'),
                  onChanged: (value) {
                    _namaProduct = value;
                  },
                ),
                TextFormField(
                  initialValue: _jenis,
                  decoration: InputDecoration(labelText: 'Jenis'),
                  onChanged: (value) {
                    _jenis = value;
                  },
                ),
                TextFormField(
                  initialValue: _merk,
                  decoration: InputDecoration(labelText: 'Merk'),
                  onChanged: (value) {
                    _merk = value;
                  },
                ),
                TextFormField(
                  initialValue: _deskripsi,
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  onChanged: (value) {
                    _deskripsi = value;
                  },
                ),
                TextFormField(
                  initialValue: _stok.toString(),
                  decoration: InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _stok = int.tryParse(value) ?? _stok;
                  },
                ),
                TextFormField(
                  initialValue: _nominal.toString(),
                  decoration: InputDecoration(labelText: 'Nominal'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    _nominal = int.tryParse(value) ?? _nominal;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    _updateProduct();
                  },
                  child: Text('Update Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
