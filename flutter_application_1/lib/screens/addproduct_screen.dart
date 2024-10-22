import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:developer';
import 'dart:io'; 
import 'package:image_picker/image_picker.dart'; 
import 'package:flutter_application_1/utils/const.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _namaProduct;
  String? _jenis;
  String? _merk;
  String? _deskripsi;
  int? _stok;
  int? _nominal;
  File? _image; 
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery); 

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        log('No image selected.');
      }
    });
  }

  Future<void> _addProduct() async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$host/api/product'));

      request.headers['Content-Type'] = 'multipart/form-data';
      request.headers['Accept'] = 'application/json';

      request.fields['namaProduct'] = _namaProduct ?? '';
      request.fields['jenis'] = _jenis ?? '';
      request.fields['merk'] = _merk ?? '';
      request.fields['deskripsi'] = _deskripsi ?? '';
      request.fields['stok'] = _stok?.toString() ?? '0';
      request.fields['nominal'] = _nominal?.toString() ?? '0';

      // Menambahkan file gambar jika ada
      if (_image != null) {
        request.files.add(await http.MultipartFile.fromPath('gambar', _image!.path));
      }

      // Mengirim request dan menunggu response
      var response = await request.send();

      if (response.statusCode == 201) {
        log('Product added successfully');
        Navigator.pop(context);
        Alert(
          context: context,
          title: "Success",
          desc: "Product added successfully!",
          type: AlertType.success,
        ).show();
      } else {
        var responseData = await response.stream.bytesToString();
        log('Failed to add product: $responseData');
        Alert(
          context: context,
          title: "Error",
          desc: "Failed to add product.",
          type: AlertType.error,
        ).show();
      }
    } catch (e) {
      log('Error adding product: $e');
      Alert(
        context: context,
        title: "Error",
        desc: "An error occurred while adding the product.",
        type: AlertType.error,
      ).show();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Product'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nama Product'),
                  onSaved: (value) {
                    _namaProduct = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Jenis'),
                  onSaved: (value) {
                    _jenis = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Merk'),
                  onSaved: (value) {
                    _merk = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Deskripsi'),
                  onSaved: (value) {
                    _deskripsi = value;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Stok'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _stok = int.tryParse(value ?? '');
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Nominal'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    _nominal = int.tryParse(value ?? '');
                  },
                ),
                SizedBox(height: 20),
                _image != null
                    ? Image.file(_image!, height: 150) // Menampilkan gambar jika sudah dipilih
                    : Text('No image selected.'),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: Text('Pick Image'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState?.save();
                      _addProduct();
                    }
                  },
                  child: Text('Add Product'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
